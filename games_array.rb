require 'football_data'

module Games

  @@games = FootballData.new('eng2010football.txt').data

  def self.array
    @@games
  end

end

