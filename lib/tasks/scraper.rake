namespace :scrape do
	desc "Clear all tables in the database"	
	task :drop_all => :environment do
		m = MovieScraper.new
		m.drop_all
	end

	desc "Scrapes for new info"
	task :scrape_all => :environment do
		m = MovieScraper.new
		m.scrape_all
	end

	desc "Do it all!"
	task :drop_and_scrape => :environment do
		m = MovieScraper.new
		m.drop_all
		m.scrape_all
	end
end