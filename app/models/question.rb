class Question < ActiveRecord::Base
  attr_accessor :seed, :final_scores

  def self.weight
    {
      "I don't care" => 0,
      "I care a little" => 1,
      "I care so much it hurts" => 2
    }
  end

  def arr_to_i(arr)
    arr.map { |s| s.to_i } if arr.is_a?(Array)
  end

  def calculate_score(score, weight)
    if weight == 1
      # lowest score possible == 0.2
      score = Math.sqrt(score) == 0 ? 0.2 : Math.sqrt(score)
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

  # ans: {
  #      "genre"=>{"name"=>"genre", "answer"=>["2", "3", "5"], "weight"=>"1"}, 
  #      "rating"=>{"name"=>"rating", "answer"=>["PG-13", "R"], "weight"=>"2"}
  #      }
  def find_my_movies
    movie_scores ||= {}

    if seed[:genre][:weight] != "0"
      Movie.all.each do |m|
        g_weight = seed[:genre][:weight].to_i
        intersection = m.genres.pluck(:id) & arr_to_i(seed[:genre][:answer])
        g_score = intersection.count.to_f / m.genres.pluck(:id).count

        score = calculate_score(g_score, g_weight) unless calculate_score(g_score, g_weight) == nil

        movie_scores[m.title] ||= []
        movie_scores[m.title] << score
      end
    end

    if seed[:rating][:weight] != "0"
      Movie.all.each do |m|
        r_weight = seed[:rating][:weight].to_i

        r_score = seed[:rating][:answer].include?(m.rating) ? 1 : 0
        score = single_match(r_score, r_weight) unless single_match(r_score, r_weight) == nil

        movie_scores[m.title] ||= []
        movie_scores[m.title] << score
      end
    end
    
    # binding.pry
    find_final_scores(movie_scores)
    # self.movie_scores[m.title] = score_sum.inject {|sum, elem| sum + elem } / score_sum.size unless score_sum == []
  end

  def find_final_scores(movie_scores)
    self.final_scores ||= {}
    movie_scores.each do |movie, scores|
      self.final_scores[movie] = scores.inject {|sum, elem| sum + elem } / scores.size
    end
  end

end
