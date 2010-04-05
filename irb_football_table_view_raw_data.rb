require 'football_data'
require 'football_model'

load 'football_table_view_raw_data.rb'

def l
  load 'irb_football_table_view_raw_data.rb'
end

FD = FootballData.new 'eng2010football.txt'
FR = FootballRatings.new FD.data
TV = FootballTableViewData.new FR.calc_ratings, FR.results
