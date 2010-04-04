require 'football_data'
require 'football_model'
require 'hash_data'

module VD

  @@team_names = HashData.new('eng2010teamsym.txt').hash
  @@next_games = FootballData.new('eng2010nextgames.txt').data
  @@fd = FootballData.new('eng2010football.txt')
  @@games = @@fd.data
  @@fr = FootballRatings.new(@@games)
  @@base_ratings = @@fr.base_ratings

  @@date = 'morning of 4 April 2010'
  def self.date
    @@date
  end

  @@title = 'Rating Football'
  def self.title
    @@title
  end

  @@home_field_advantage =
    (1.0*@@fr.home_field_advantage + 0.00005).to_s[0...6]
  def self.home_field_advantage
    @@home_field_advantage
  end

  def self.cook_rating(r)
    r = 1000.0*r + 10000.5
    r.to_s[1...2] + '.' + r.to_s[2...5]
  end

  @@ratings_view_data = nil
  def self.ratings_view_data
    return @@ratings_view_data if @@ratings_view_data
    data = []
    keys = @@team_names.keys
    keys.each do |key|
      away_r = @@base_ratings[key]
      home_r = @@fr.home_field_advantage*away_r
      data << [@@team_names[key], cook_rating(away_r), cook_rating(home_r)]
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

  def self.cook_month(month)
    return 'January' if '01' == month
    return 'February' if '02' == month
    return 'March' if '03' == month
    return 'April' if '04' == month
    return 'May' if '05' == month
    return 'June' if '06' == month
    return 'July' if '07' == month
    return 'August' if '08' == month
    return 'September' if '09' == month
    return 'October' if '10' == month
    return 'November' if '11' == month
    return 'December' if '12' == month
  end
  
  def self.cook_date_time(date)
    d = date.to_s
    year = d[0...4]
    month = d[4...6]
    day = d[6...8]
    day[0] = ' ' if 48 == day[0]
    if 8 == d.length then
      return day + '&nbsp;' + cook_month(month)
    end
    hour = d[8...10]
    minute = d[10...12]
    day + '&nbsp;' + cook_month(month) +
      ' at ' + hour + ':' + minute
  end

  def self.home_draw_away(home_team, away_team)
    @@fr.home_draw_away(home_team, away_team)
  end

  def self.cook_probability(p)
    p = 10000.0*p + 10000.5
    cp = p.to_s[1...3] + '.' + p.to_s[3...5] + '%'
    cp[0] = ' ' if 48 == cp[0]
    cp
  end

  @@games_view_data = nil
  def self.games_view_data
    return @@games_view_data if @@games_view_data
    items = []
    @@next_games.each do |g|
      h, d, a = @@fr.home_draw_away(g.home_team, g.away_team)
      hc = cook_probability(h)
      dc = cook_probability(d)
      ac = cook_probability(a)
      items << [cook_date_time(g.date),
        @@team_names[g.home_team], @@team_names[g.away_team],
        hc, dc, ac]
    end
    @@games_view_data = items
  end

end

