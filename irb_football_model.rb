load 'football_model.rb'

def l
  load 'irb_football_model.rb'
end

FD = FootballData.new 'data/eng' + YEAR_DATA + 'football.txt'
FR = FootballRatings.new FD.data

