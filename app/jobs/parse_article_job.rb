require 'mechanize'
class ParseArticleJob < ApplicationJob
  queue_as :default

  def perform(count)
    parser = Mechanize.new
    articles_on_page = 30
    if count.to_i > articles_on_page  
        
        #Первая страница
        page = parser.get("https://news.ycombinator.com/")
        authors = page.search('.subtext').take(articles_on_page)
        articles = page.search('.athing').take(articles_on_page)
        #Вторая страница
        page = parser.get("https://news.ycombinator.com/news?p=2")
        authors += page.search('.subtext').take(count.to_i - articles_on_page)
        articles += page.search('.athing').take(count.to_i - articles_on_page)

    else
        page = parser.get("https://news.ycombinator.com/")
        authors = page.search('.subtext').take(count.to_i)
        articles = page.search('.athing').take(count.to_i)
        
    end
    articles.each_with_index do |item,i|
        
        title = item.search('.storylink').text
        url = item.search('.storylink').attr('href')
        if authors[i].search('.hnuser').text.length > 0
            author = authors[i].search('.hnuser').text
        else
            author = 'anonym'
        end
        Post.create(:title => title,:author => author,:url => url)
    end
      
  end
end
