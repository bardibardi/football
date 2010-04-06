require 'football_data'

module NextGames

  @@next_games = FootballData.new('data/eng2010nextgames.txt').data

  def self.array
    @@next_games
  end

end

