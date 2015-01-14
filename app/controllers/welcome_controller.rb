class WelcomeController < ApplicationController
  def index
    # Article.destroy_all
    # Hplink.destroy_all
    # Tweet.destroy_all

    # Tweet.populate_db
    # Hplink.populate_db
    # Article.populate_db

    @paths =  ["frontpage", "politics", "entertainment", "technology", "media", "sports"]
    gon.frontpage = Article.where(section: @paths[0]).limit(nil).to_a
    gon.politics = Article.where(section: @paths[1]).limit(nil).to_a
    gon.entertainment = Article.where(section: @paths[2]).limit(nil).to_a
    gon.technology = Article.where(section: @paths[3]).limit(nil).to_a
    gon.media = Article.where(section: @paths[4]).limit(nil).to_a
    gon.sports = Article.where(section: @paths[5]).limit(nil).to_a
  end

end


# On page load there is a dropdown containing the different HuffPo sections.

# User selects one and clicks submit. (gets added to parameter)

# Show action receives that parameter and proliferates table (Article.where(section: @section).each {}) via AJAX? partial


# <%= form_for(Article) do |f| %>
# <%= f.collection_select(:article, @paths, prompt: true) %>
# <% end %>

# to be used in index:
