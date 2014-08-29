xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Hacker News'
    xml.description "The top 10 stories on Hacker News for the week ending #{Time.at(@end_date).to_date}"
    xml.link "https://ggr.com/hn/"

    for article in @articles[0..9]
      xml.item do
        xml.title article['title']
        xml.author article['author']
        xml.description article['details']['text']
        xml.pubDate article['created_at']
        xml.link article['url']
        xml.guid article['objectID']
      end
    end
  end
end
