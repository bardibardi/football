require 'football_data'

module Games

  @@games = FootballData.new('data/eng' + YEAR_DATA + 'football.txt').data

  def self.array
    @@games
  end

end

