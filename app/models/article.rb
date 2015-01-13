class Article < ActiveRecord::Base

  @@hotwords = {}
  @@topics = []
  ARBITRARY_FILTER = 10 # number of words an article must match with tweets to be considered relevant

  cattr_reader :hotwords, :topics


  def self.build_topic_keys
    Tweet.all.each {|t| @@topics << (t.topic) unless @@topics.include?(t.topic)}
    @@topics
  end

  def self.build_hotwords_hash
    build_topic_keys
    @@topics.each do |topic|
      relevant_tweets = Tweet.where(topic: topic).limit(nil)
      master_array = relevant_tweets.collect {|tweet| tweet.content}
      master_array = master_array.collect {|tweet| tweet.split(" ")}
      master_array.flatten!
      master_array = (master_array - STOPWORDS)
      # binding.pry
      master_array.each {|word| word.downcase!; word.gsub!(/[^\w]/, "")}
      @@hotwords[topic.to_sym] = master_array
    end
    @@hotwords
  end

  # MAKE WORK THEN MAKE IT SO EVERY VISIT TO A SITE IS A SESSION THAT ONLY ACCESSES

  def self.populate_db
    build_hotwords_hash
    Hplink.all.each do |link|
      doc = Nokogiri::HTML(open(link.url))
      title = doc.at_css("h1.title").children[0].to_s
      article_arr = doc.xpath('//div[@id="mainentrycontent"]/p/text()').collect {|par| par.text}
      all_text = (title + " " + article_arr.join(" ")).downcase!.gsub!(/[^\s\w]/, "")
      topic_and_matches = find_topic_and_matches(all_text)
       # binding.pry
      Article.create(title: title, body: article_arr.join(" "), topic: topic_and_matches.first , url: link.url, matches: topic_and_matches.last) if topic_and_matches.last > ARBITRARY_FILTER
    end

  end

  # hotwords = {topic1: ["blah", "blah", "blah"], topic2: ["yada"] topic3: ["stuff", "stuff"]}

  def self.find_topic_and_matches(all_text)
    matches = 0
    topic_match = "no topic"
    @@hotwords.each do |topic, hotwords_arr|
      curr_matches = 0
      hotwords_arr.each do |word|
        curr_matches += 1 if all_text.include?(word)
      end
      if curr_matches > matches
        matches = curr_matches
        topic_match = topic
      end
      # binding.pry
    end
    [topic_match, matches]
  end

end

# articleArr = doc.xpath('//div[@id="mainentrycontent"]/p/text()').collect {|par| par.text}

  # t.string :title
  # t.string :body
  # t.string :topic
  # t.string :url
  # t.integer :matches


  # def self.populate_db
  #   PATHS.each do |path|
  #     doc = Nokogiri::HTML(open(URL + path))
  #     links = doc.xpath("//a").select{|link| link.attributes["href"].inner_html.include?("huffingtonpost.com/201") if link.attributes["href"]}
  #     links.each do |link|
  #       path == "" ? section = "frontpage" : section = path
  #       title = link.children.inner_text
  #       address = link.attributes["href"].value
  #       Hplink.create(section: section, title: title, url: address)
  #     end
  #   end
  # end


  # Article.create(title: title, )

  # title = doc.at_css("h1.title").children[0].to_s

  # article = doc.xpath("//p").select{|par| par.parent.attributes["id"] == "mainentrycontent"}