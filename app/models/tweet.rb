class Tweet < ActiveRecord::Base

  TWITTER = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['CONSUMER_KEY']
    config.consumer_secret = ENV['CONSUMER_SECRET']
    config.access_token = ENV['ACCESS_TOKEN']
    config.access_token_secret = ENV['ACCESS_SECRET']
  end

  PLACE = 23424977 # USA
  NUM_TWEETS = 25 # Number of tweets to store and parse per trending topic

  @@topics = []
  @@trending_tweets = {}

  cattr_reader :topics

  def self.get_trending_topics
    trends = (TWITTER.trends(id = PLACE)).to_h
    @@topics = trends[:trends].collect do |t|
      t[:name].include?("#") ? t[:name].gsub!("#","") : t[:name]
    end
  end

  def self.get_top_tweets
    get_trending_topics
    @@topics.each do |topic|
      TWITTER.search(topic, {result_type: "popular", lang: "en", count: NUM_TWEETS}).to_h[:statuses].each do |status|
        @@trending_tweets[topic] ||= []
        @@trending_tweets[topic] << status[:text]
      end
    end
  end

  def self.populate_db
    get_top_tweets
    @@trending_tweets.each do |topic, contents|
      contents.each do |content|
        Tweet.create(topic: topic, content: content)
      end
    end
  end

end
