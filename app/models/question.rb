class Question < ActiveRecord::Base
  attr_accessor :seed, :final_scores

  def self.weight
    {
      "I don't care" => 0,
      "I care a little" => 1,
      "I care so much it hurts" => 2
    }
  end

  def self.runtimes
    {
      "Fewer than 90 min" => 0,
      "90 min - 120 min" => 1,
      "Greater than 120 min" => 2
    }
  end

  def arr_to_i(arr)
    arr.map { |s| s.to_i } if arr.is_a?(Array)
  end

  def calculate_score(score, weight)
    if weight == 1
      score = Math.sqrt(score) == 0 ? 0.2 : (Math.sqrt(score)) * 0.9
      return score
    elsif weight == 2
      return score
    else
      return nil
    end
  end

  def single_match(score, weight)
    if weight == 1
      return (score-0.3).abs
    elsif weight == 2
      return score
    else
      return nil
    end
  end

  def find_my_movies
    movie_scores ||= {}

    if seed[:genre][:weight] && seed[:genre][:weight] != "0"
      Movie.all.each do |m|
        g_weight = seed[:genre][:weight].to_i
        intersection = m.genres.pluck(:id) & arr_to_i(seed[:genre][:answer])
        g_score = intersection.count.to_f / m.genres.pluck(:id).count

        score = calculate_score(g_score, g_weight) unless calculate_score(g_score, g_weight) == nil

        movie_scores[m.title] ||= []
        movie_scores[m.title] << score
      end
    end

    if seed[:rating][:weight] && seed[:rating][:weight] != "0"
      Movie.all.each do |m|
        r_weight = seed[:rating][:weight].to_i

        r_score = seed[:rating][:answer].include?(m.rating) ? 1 : 0
        
        score = single_match(r_score, r_weight) unless single_match(r_score, r_weight) == nil

        movie_scores[m.title] ||= []
        movie_scores[m.title] << score
      end
    end

    if seed[:runtime][:weight] && seed[:runtime][:weight] != "0"
      Movie.all.each do |m|
        r_weight = seed[:runtime][:weight].to_i

        if m.runtime > 120
          run_key = 2
        elsif m.runtime < 90
          run_key = 0
        else
          run_key = 1
        end
        r_score = arr_to_i(seed[:runtime][:answer]).include?(run_key) ? 1 : 0
        score = single_match(r_score, r_weight) unless single_match(r_score, r_weight) == nil

        movie_scores[m.title] ||= []
        movie_scores[m.title] << score
      end
    end

    if seed[:actor][:weight] && seed[:actor][:weight] != "0"
      Movie.all.each do |m|
        movie_actor_ids = m.actors.pluck(:id)

        r_weight = seed[:actor][:weight].to_i

        intersection = m.actors.pluck(:id) & arr_to_i(seed[:actor][:answer])
        g_score = (6.0 + intersection.count) / 10 unless intersection.count == 0

        unless g_score == nil
          score = calculate_score(g_score, r_weight)
        end
        movie_scores[m.title] ||= []
        movie_scores[m.title] << score unless score == nil
      end
    end

    if seed[:director][:weight] && seed[:director][:weight] != "0"
      Movie.all.each do |m|
        r_weight = seed[:director][:weight].to_i

        r_score = seed[:director][:answer].include?(m.director) ? 1 : 0
        score = single_match(r_score, r_weight) unless single_match(r_score, r_weight) == nil

        movie_scores[m.title] ||= []
        movie_scores[m.title] << score unless score == nil
      end
    end

    find_final_scores(movie_scores)
  end

  def find_final_scores(movie_scores)
    self.final_scores ||= {}
    movie_scores.each do |movie, scores|
      self.final_scores[movie] = scores.inject {|sum, elem| sum + elem } / scores.size
    end
  end



end
