require 'ostruct'
require 'open-uri'

MAX_ARTICLES = 5
MAX_COMMENTS = 5

class MainController < ApplicationController

def index
  base_date   = DateTime.parse(params[:date]) if params[:date]
  base_date ||= Time.now
  @end_date = (base_date - (base_date.wday+1).days).to_date.to_datetime.to_i
  @start_date = (@end_date - 7.days).to_i

  cache_key = "articles-#{@end_date}"
  @articles = Rails.cache.read(cache_key)
  if !@articles
    search = open("https://hn.algolia.com/api/v1/search?tags=story&numericFilters=created_at_i%3E#{@start_date},created_at_i%3C#{@end_date}")
    @articles = JSON.parse(search.read)['hits']
    @articles.sort_by! {|a| -DateTime.parse(a['created_at']).to_i}
    @articles = @articles[0..MAX_ARTICLES-1]
    @articles.each do |article|
      details = open("https://hn.algolia.com/api/v1/items/#{article['objectID']}")
      article['details'] = JSON.parse(details.read)
      article['hn_url'] = "https://news.ycombinator.com/item?id=#{article['objectID']}"
      article['description']  = ""
      article['description'] += '<p>' + article['details']['text'] + "<p/>" if article['details']['text']
      article['description'] += '<p>' + article['hn_url'] + "</p>"
      comments = find_comments(article['details'])
      comments = comments.sort_by {|a| -a['points'].to_i}
      comments = comments[0..MAX_COMMENTS-1]
      #binding.pry
      comments.each do |comment|
        article['description'] += "<p>***</p><p>" + comment['text'] + "</p>"
      end
    end
    Rails.cache.write(cache_key, @articles)
  end
  respond_to do |format|
    format.atom {render :layout => false}
    end
  end

  private

  def find_comments(comment)
    result = []
    if comment
      result << comment if comment['parent_id']
      if comment['children']
        comment['children'].each do |comment|
          result += find_comments(comment)
        end
      end
    end
    result
  end
end

