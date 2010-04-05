require 'football_data'

module NextGames

  @@next_games = FootballData.new('eng2010nextgames.txt').data

  def self.array
    @@next_games
  end

end

