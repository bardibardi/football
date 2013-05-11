require_relative 'config/data'
require 'football_model'
load 'football_draws.rb'

def l
  load 'irb_football_draws.rb'
end

FD = FootballData.new 'data/eng' + YEAR_DATA + 'football.txt'
GAMES = FD.data
FR = FootballRatings.new GAMES
RATINGS = FR.calc_ratings
HOME_FIELD_ADVANTAGE = FR.home_field_advantage

def delta(draw_weight)
  FootballDraws.draw_delta draw_weight, HOME_FIELD_ADVANTAGE, RATINGS, GAMES
end

def draw_exp(draw_weight)
  FootballDraws.draw_expectation draw_weight, HOME_FIELD_ADVANTAGE, RATINGS, GAMES
end
