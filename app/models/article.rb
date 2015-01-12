class Article < ActiveRecord::Base

  @@hotwords = {}
  @@topics = []

  cattr_reader :hotwords, :topics


  def self.build_topic_keys
    Tweet.all.each {|t| @@topics << (t.topic) unless @@topics.include?(t.topic)}
    @@topics
  end

  def self.build_hotwords_hash
    build_topic_keys
    @@topics.each do |topic|
      # binding.pry
      relevant_tweets = Tweet.where(topic: topic).limit(nil)
      master_array = relevant_tweets.collect {|tweet| tweet.content}
      master_array = master_array.collect {|tweet| tweet.split(" ")}
      master_array.flatten!
      master_string = (master_array - STOPWORDS).join(" ")
      @@hotwords[topic.to_sym] = master_string
    end
    @@hotwords
  end

  # MAKE WORK THEN MAKE IT SO EVERY VISIT TO A SITE IS A SESSION THAT ONLY ACCESSES

  def self.populate_db
    Hplink.all.each do |link|
      doc = Nokogiri::HTML(open(link.url))
      title = doc.at_css("h1.title").children[0].to_s
      article = doc.xpath("//p").collect {|par| par.text}
      all_text = article.join + title
      #TODO: SEARCH all_text FOR HOTWORDS MATCHES IN EACH VALUE OF HASH
      topic_and_matches = find_topic_and_matches(all_text)
      # Article.create(title: title, body: , topic: topic_and_matches.first , url: link.url , matches: topic_and_matches.last) if topic_and_matches.last
    end

  end

  # hotwords = {topic: "blah, blah, blah", topic: "yada", topic: "stuff"}

  # def find_topic_and_matches(all_text)
  #   matches = 0
  #   topic_match = nil

  #   @@hotwords.each do |topic, string|
  #     curr_matches = 0
  #     all_text.split.each do |word|
  #       curr_matches += 1 if string.include?(word)
  #     end
  #     topic_match = topic if matches > 0
  #   end
  # end





end

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