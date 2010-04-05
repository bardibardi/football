require 'football_model'
require 'games_array'

module Ratings

  @@football_ratings = FootballRatings.new(Games.array)
  @@ratings = @@football_ratings.calc_ratings

  def self.hash
    @@ratings
  end

  def self.home_field_advantage
    @@football_ratings.home_field_advantage
  end

  def self.home_draw_away(home_team, away_team)
    @@football_ratings.home_draw_away(home_team, away_team)
  end

end

