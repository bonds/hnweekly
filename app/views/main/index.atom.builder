xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Hacker News'
    xml.description "The top #{@articles.size} stories on Hacker News for the week ending #{Time.at(@end_date).to_date}"
    xml.link "http://hnweekly.herokuapp.com/"

    for article in @articles
      xml.item do
        xml.title article['title']
        xml.author article['author']
        xml.description article['description']
        xml.pubDate article['created_at']
        xml.link article['url']
        xml.guid article['objectID']
      end
    end
  end
end
