require 'football_view_data'

module T

  @@app = nil
  def self.link_app(app)
    @@app = app unless @@app
  end

  def self.list(sym, items)
    @@app.haml(sym,
      :locals => {
        :list => items
      }
    )
  end

  def self.football(body)
    @@app.haml(:football,
      :locals => {
        :title => VD.title,
        :date => VD.date,
        :links => @@app.haml(:links),
        :body => body
      }
    )
  end

  def self.about
    @@app.haml(:'about.html')
  end

  def self.glossary
    @@app.haml(:'glossary.html')
  end

  def self.rating(h_rating, rating, team)
    @@app.haml(:rating,
      :locals => {
        :h_rating => h_rating,
        :rating => rating,
        :team => team
      }
    )
  end

  def self.ratings
    items = []
    VD.ratings_view_data.each do |r|
      items << rating(r[2], r[1], r[0])
    end
    @@app.haml(:'ratings.html',
      :locals => {
        :home_field_advantage => VD.home_field_advantage,
        :list => items
      }
    )
  end

  def self.game(date_time, home_team, away_team, home, draw, away)
    @@app.haml(:game,
      :locals => {
        :date_time => date_time,
        :home_team => home_team,
        :away_team => away_team,
        :home => home,
        :draw => draw,
        :away => away
      }
    )
  end

  def self.games
    items = []
    VD.games_view_data.each do |r|
      items << game(r[0], r[1], r[2], r[3], r[4], r[5])
    end
    list(:'games.html', items)
  end

end
