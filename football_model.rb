require 'football_data'

module FootballOdds

  def self.draw_weaker_win(stronger_rating, weaker_rating)
    weaker_expectation = weaker_rating.quo(stronger_rating + weaker_rating)
    draw_factor = 0.8*Math.sqrt(0.5.quo(weaker_expectation))
    weaker_win = 2.0*weaker_expectation.quo(2.0 + draw_factor)
    [weaker_win*draw_factor, weaker_win]
  end

  def self.home_draw_away(home_field_advantage, home_rating, away_rating)
    effective_home_rating = home_field_advantage*home_rating
    if effective_home_rating < away_rating then
      draw, home = draw_weaker_win(away_rating, effective_home_rating)
      away = 1.0 - draw - home
    else
      draw, away = draw_weaker_win(effective_home_rating, away_rating)
      home = 1.0 - draw - away
    end
    [home, draw, away]
  end

  def self.expectation_from_odds(full_odds_str)
    odds_str, to_odds_str = full_odds_str.split('/')
    to_odds = 1.0
    to_odds = to_odds_str.to_f if to_odds_str
    odds = odds_str.to_f
    to_odds.quo(odds + to_odds)
  end

  def self.home_draw_away_from_odds(home_odds_str, draw_odds_str, away_odds_str)
    home = expectation_from_odds(home_odds_str)
    draw = expectation_from_odds(draw_odds_str)
    away = expectation_from_odds(away_odds_str)
    t = home + draw + away
    [home.quo(t), draw.quo(t), away.quo(t), t]
  end

  def self.count_twice_score(team_sym, team_results)
    count = 0
    twice = 0
    team_results.each do |result|
      count += 1
      home_score = result.home_score
      away_score = result.away_score
      twice += 1 if home_score == away_score
      if result.home_team == team_sym then
        twice += 2 if home_score > away_score
      else
        twice += 2 if home_score < away_score
      end
    end
    [count, twice]
  end

  def self.sum_of_expectations(home_field_advantage, team_sym,
                               team_results, ratings, team_rating)
    s = 0
    team_results.each do |result|
      if result.home_team == team_sym then
        home_rating = home_field_advantage * team_rating
        s += home_rating/(home_rating + ratings[result.away_team])
      else
        home_rating = home_field_advantage * ratings[result.home_team]
        s += team_rating/(team_rating + home_rating)
      end
    end
    s
  end

  def self.next_rating_pair(home_field_advantage, team_sym,
                            team_results, ratings, team_rating,
                            score,
                            low_rating, low_se, high_rating, high_se)
    se = sum_of_expectations(home_field_advantage, team_sym,
                             team_results, ratings, team_rating)
    if se >= score then
      high_rating = team_rating
      high_se = se
    else
      low_rating = team_rating
      low_se = se
    end   
    [low_rating, low_se, high_rating, high_se]
  end

  def self.next_rating_iter(score, low_rating, low_se, high_rating, high_se)
    return (10.0/11)*high_rating if nil == low_rating
    return 1.1*low_rating if nil == high_rating
    (low_rating + high_rating) / 2.0
#    slope = (high_rating - low_rating)/(high_se - low_se)
#    intercept = low_rating - slope*low_se
#    intercept + slope*score
  end

  def self.next_rating(home_field_advantage, team_sym, team_results, ratings)
    count, twice = count_twice_score(team_sym, team_results)
    score = twice/2.0
    team_rating = ratings[team_sym]
    low_rating = nil
    low_se = 0.0
    high_rating = nil
    high_se = 1.0*count
#    i = 0
#    while i < 10
#      i += 1
    delta = 0.0001*score
    while high_se - low_se > delta
      low_rating, low_se, high_rating, high_se =
        next_rating_pair(home_field_advantage, team_sym,
                         team_results, ratings, team_rating,
                         score,
                         low_rating, low_se, high_rating, high_se)
      team_rating =
        next_rating_iter(score, low_rating, low_se, high_rating, high_se)
    end
    team_rating
  end

  def self.next_ratings(home_field_advantage, results, ratings)
    nr = {}
    ratings.each_key do |team_sym|
      team_results = results[team_sym]
      team_rating =
        next_rating(home_field_advantage, team_sym, team_results, ratings)
      nr[team_sym] = team_rating
    end
    nr
  end

end

module NormalizeRatings

  def self.sum_of_expectations(home_field_advantage, ratings, team_rating)
    s = 0
    ratings.each_value do |rating|
      home_rating = home_field_advantage * team_rating
      s += home_rating/(home_rating + rating)
      home_rating = home_field_advantage * rating
      s += team_rating/(team_rating + home_rating)
    end
    s
  end

  def self.next_rating_pair(home_field_advantage, ratings, team_rating,
                            score, low_rating, low_se, high_rating, high_se)
    se = sum_of_expectations(home_field_advantage, ratings, team_rating)
    if se >= score then
      high_rating = team_rating
      high_se = se
    else
      low_rating = team_rating
      low_se = se
    end   
    [low_rating, low_se, high_rating, high_se]
  end

  def self.next_rating_iter(score, low_rating, low_se, high_rating, high_se)
    return (10.0/11)*high_rating if nil == low_rating
    return 1.1*low_rating if nil == high_rating
    (low_rating + high_rating) / 2.0
#    slope = (high_rating - low_rating)/(high_se - low_se)
#    intercept = low_rating - slope*low_se
#    intercept + slope*score
  end

  def self.next_rating(home_field_advantage, ratings)
    score = ratings.length
    sum = 0
    ratings.each_value do |rating|
      sum += rating
    end
    team_rating = sum/score
    low_rating = nil
    low_se = 0.0
    high_rating = nil
    high_se = 2.0*score
#    i = 0
#    while i < 10
#      i += 1
    delta = 0.0001*score
    while high_se - low_se > delta
      low_rating, low_se, high_rating, high_se =
        next_rating_pair(home_field_advantage, ratings, team_rating,
                         score,
                         low_rating, low_se, high_rating, high_se)
      team_rating =
        next_rating_iter(score, low_rating, low_se, high_rating, high_se)
    end
    team_rating
  end

  def self.normalize_ratings(home_field_advantage, ratings)
    nr = {}
    team_rating = next_rating(home_field_advantage, ratings)
    ratings.each do |team_sym, rating|
      nr[team_sym] = rating/team_rating
    end
    nr
  end

end

class FootballRatings
  attr_reader :data, :home_field_advantage, :results
  attr_reader :base_ratings, :calc_ratings

  def initialize(data)
    @data = data
    init_home_field_advantage
    init_results
    init_base_ratings
    init_calc_ratings
#    @base_ratings =
#      NormalizeRatings.normalize_ratings(@home_field_advantage, @base_ratings)
    @base_ratings = @calc_ratings
  end

  def init_results
    @results = {}
    @data.each do |result|
      home_sym = result.home_team
      away_sym = result.away_team
      @results[home_sym] = [] unless @results[home_sym]
      @results[home_sym] << result
      @results[away_sym] = [] unless @results[away_sym]
      @results[away_sym] << result
    end
  end

  def init_home_field_advantage
    count = 0
    twice = 0
    @data.each do |result|
      count += 1
      home_score = result.home_score
      away_score = result.away_score
      twice += 2 if home_score > away_score
      twice += 1 if home_score == away_score
    end
    expectation = twice.quo(count + count)
    @home_field_advantage = expectation / (1 - expectation)
  end

  def base_rating(team_sym)
    team_results = @results[team_sym]
    count, twice = FootballOdds.count_twice_score(team_sym, team_results)
    twice.quo(count + count - twice)
  end

  def init_base_ratings
    @base_ratings = {}
    @results.each_key do |team_sym|
      @base_ratings[team_sym] = 0.0
    end
    @base_ratings.each_key do |team_sym|
      @base_ratings[team_sym] = base_rating(team_sym)
    end
    @base_ratings
  end

  def init_calc_ratings
    @calc_ratings = @base_ratings
    (0...5).each do |i|
      @calc_ratings =
        FootballOdds.next_ratings(@home_field_advantage,
                                  @results, @calc_ratings)
    end
    @calc_ratings =
      NormalizeRatings.normalize_ratings(@home_field_advantage, @calc_ratings)
  end

  def home_draw_away(home_sym, away_sym, ratings = @base_ratings)
    FootballOdds.home_draw_away(@home_field_advantage,
      ratings[home_sym], ratings[away_sym])
  end

  def score(team_sym)
    count, twice = FootballOdds.count_twice_score(team_sym, results[team_sym])
    twice/2.0
  end

  def sum_of_expectations(team_sym, team_rating, ratings = @base_ratings)
    FootballOdds.sum_of_expectations(@home_field_advantage, team_sym,
                               @results[team_sym], ratings, team_rating)
  end

  def next_rating(team_sym, ratings = @base_ratings)
    FootballOdds.next_rating(@home_field_advantage, team_sym,
                             results[team_sym], ratings)
  end

end

