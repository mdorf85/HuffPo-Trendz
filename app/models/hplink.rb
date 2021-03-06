require 'open-uri'

class Hplink < ActiveRecord::Base

  URL = "http://www.huffingtonpost.com/"
  PATHS = ["", "politics", "entertainment", "technology", "media", "sports"]

  def self.populate_db
    PATHS.each do |path|
      doc = Nokogiri::HTML(open(URL + path))
      links = doc.xpath("//a").select{|link| link.attributes["href"].inner_html.include?("huffingtonpost.com/201") if link.attributes["href"]}
      links.each do |link|
        path == "" ? section = "frontpage" : section = path
        title = link.children.inner_text
        address = link.attributes["href"].value
        Hplink.create(section: section, title: title, url: address) if (Hplink.where(url: address).empty? && (Hplink.where(url: address.gsub!("#comments","")).empty? if Hplink.where(url: address)))
      end
    end
  end

end
