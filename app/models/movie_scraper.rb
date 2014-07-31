require 'nokogiri'
require 'open-uri'
require 'pry'

class MovieScraper

  def drop_all
    Movie.destroy_all
    Actor.destroy_all
    Genre.destroy_all
    TopDirector.destroy_all
    TopActor.destroy_all
  end

  def scrape_all
    self.current_movies
    self.top_dir
    self.top_act
  end

  def current_movies
    doc = Nokogiri::HTML(open('http://www.imdb.com/movies-in-theaters/?ref_=nv_mv_inth_1'))

    doc.css(".overview-top").each do |movie|
      m = Movie.new
      
      index = movie.children[1].children.children.text.index("(")
      m.title   = movie.children[1].children.children.text[1..index-2]
      m.rating  = movie.children[3].children[1].attributes["title"].value
      m.runtime = movie.children[3].children[3].children.text

      genres = movie.children[3].css("span").children.text.split('|')[0..-1]
      genres.each do |genre|
        m.genres << Genre.find_or_create_by(name: "#{genre}")
      end

      m.description = movie.children[7].children.text.gsub("\n", "").strip
      m.director    = movie.children[9].children.children.children.children.text

      actors = movie.children[11].children.children.children.text.split("\n")[1..-1]
      actors.each do |actor|
        m.actors << Actor.find_or_create_by(name: "#{actor}")
      end
      m.image_url = movie.parent.css(".poster")[0]["src"]

      m.save
    end
  end

  def top_dir
      doc = Nokogiri::HTML(open('http://www.imdb.com/list/ls008344500/?start=1&view=compact&sort=listorian:asc&scb=0.20908019482158124'))

      doc.css("td.name").each do |director|
        d = TopDirector.new

        d.name = director.children.children.text

        d.save
      end
  end

  def top_act
    doc = Nokogiri::HTML(open('http://www.imdb.com/list/ls000004615/?start=1&view=compact&sort=listorian:asc&scb=0.8744896727148443'))

      doc.css("td.name").each do |actor|
        a = TopActor.new

        a.name = actor.children.children.text

        a.save
      end
  end
end
