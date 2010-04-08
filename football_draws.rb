require 'football_model'
require 'games_array'

module FootballDraws

  def self.dww(draw_weight, stronger_rating, weaker_rating)
    weaker_expectation = weaker_rating.quo(stronger_rating + weaker_rating)
    draw_factor = draw_weight/Math.sqrt(weaker_expectation)
    weaker_win = 2.0*weaker_expectation.quo(2.0 + draw_factor)
    [weaker_win*draw_factor, weaker_win]
  end

  def self.draw_count(games_array)
    draws = 0
    count = 0
    games_array.each do |result|
      count += 1
      draws += 1 if result.home_score == result.away_score
    end
    [draws, count]
  end

  def self.draw_expectation(draw_weight, home_field_advantage, ratings, games_array)
    draws = 0
    count = 0
    draw_exp = 0.0
    games_array.each do |result|
      stronger = home_field_advantage*ratings[result.home_team]
      weaker = ratings[result.away_team]
      stronger, weaker = weaker, stronger if weaker > stronger
      if (stronger / weaker < 10000) then
        draw, weaker_win = dww(draw_weight, stronger, weaker)
        draw_exp += draw
        count += 1
        draws += 1 if result.home_score == result.away_score
      end
    end
    [count, draws, draw_exp]
  end

  def self.draw_delta(draw_weight, home_field_advantage, ratings, games_array)
    count, draws, draw_exp = draw_expectation(draw_weight, home_field_advantage, ratings, games_array)
    (draw_exp - draws)/count
  end

end
