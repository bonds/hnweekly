require 'ostruct'
require 'open-uri'

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
      @articles.each do |article|
        details = open("https://hn.algolia.com/api/v1/items/#{article['objectID']}")
        article['details'] = JSON.parse(details.read)
      end
      Rails.cache.write(cache_key, @articles)
    end
    respond_to do |format|
      format.atom {render :layout => false}
    end
  end
end

