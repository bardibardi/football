require 'games_array'

module TeamResults

  @@results = {}
  Games.array.each do |result|
    home_sym = result.home_team
    away_sym = result.away_team
    @@results[home_sym] = [] unless @@results[home_sym]
    @@results[home_sym] << result
    @@results[away_sym] = [] unless @@results[away_sym]
    @@results[away_sym] << result
  end

  def self.hash
    @@results
  end

end

