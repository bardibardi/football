require 'football_data'

module Games

  @@games = FootballData.new('data/eng2010football.txt').data

  def self.array
    @@games
  end

end

