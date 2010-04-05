require 'team_names_hash'
require 'view_data_hash'
require 'games_array'
require 'next_games_array'
require 'ratings_hash'

require 'cook'

module VD

  @@date = ViewData.hash[:date]
  def self.date
    @@date
  end

  @@title = ViewData.hash[:title]
  def self.title
    @@title
  end

  @@home_field_advantage =
    (1.0*Ratings.home_field_advantage + 0.00005).to_s[0...6]
  def self.home_field_advantage
    @@home_field_advantage
  end

  @@ratings_view_data = nil
  def self.ratings_view_data
    return @@ratings_view_data if @@ratings_view_data
    data = []
    keys = TeamNames.hash.keys
    keys.each do |key|
      away_r = Ratings.hash[key]
      home_r = Ratings.home_field_advantage*away_r
      data << [TeamNames.hash[key], Cook.rating(away_r), Cook.rating(home_r)]
    end
    @@ratings_view_data = data.sort do |a, b|
      if a[1] < b[1] then
        r = 1
      elsif a[1] > b[1]
        r = -1
      elsif a[0] > b[0]
        r = 1
      elsif
        r = -1
      end
      r
    end
  end
 
  @@games_view_data = nil
  def self.games_view_data
    return @@games_view_data if @@games_view_data
    items = []
    NextGames.array.each do |g|
      h, d, a = Ratings.home_draw_away(g.home_team, g.away_team)
      hc = Cook.probability(h)
      dc = Cook.probability(d)
      ac = Cook.probability(a)
      items << [Cook.date_time(g.date),
        TeamNames.hash[g.home_team], TeamNames.hash[g.away_team],
        hc, dc, ac]
    end
    @@games_view_data = items
  end

end

