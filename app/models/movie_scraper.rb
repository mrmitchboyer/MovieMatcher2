require 'nokogiri'
require 'open-uri'
require 'themoviedb'
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
    self.get_backdrops
    self.top_dir
    self.top_act
  end

  def get_backdrops
    Tmdb::Api.key("68c4c3e8cc8ce15135fc108230239dbf")

    Movie.all.each do |m|
      db_movie = Tmdb::Movie.find(m.title)[0]
      poster_path = db_movie.poster_path
      # returns nil if there is no poster
      m.image_url = "http://image.tmdb.org/t/p/w154" + poster_path unless poster_path == nil 
      backdrop_path = db_movie.backdrop_path
      # returns nil if there is no backdrop
      m.backdrop = "http://image.tmdb.org/t/p/w1280" + backdrop_path unless backdrop_path == nil
      m.save
    end
    
  end

  def current_movies
    doc = Nokogiri::HTML(open('http://www.imdb.com/movies-in-theaters/?ref_=nv_mv_inth_1'))

    doc.css(".overview-top").each do |movie|
      m = Movie.new
      
      index = movie.children[1].children.children.text.index("(")
      m.title = movie.children[1].children.children.text[1..index-2]
      # retunrs "Not Rated" if the movie has no rating
      if movie.children[3].children[1].attributes["title"]
        m.rating = movie.children[3].children[1].attributes["title"].value
      else
        m.rating = "Not Rated"
      end
      m.runtime = movie.children[3].children[3].children.text
      binding.pry

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

      # stubs out the link if there is no trailer url
      if movie.parent.parent.css(".overview-bottom a")[0]
        m.trailer = "http://www.imdb.com#{movie.parent.parent.css(".overview-bottom a")[0]["href"]}"
      else
        m.trailer = "#"
      end

      # stubs out the link if there is no tickets url
      if movie.parent.parent.css(".overview-bottom a")[2]
        m.ticket = "http://www.imdb.com#{movie.parent.parent.css(".overview-bottom a")[2]["href"]}"
      else
        m.ticket = "#"
      end
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
