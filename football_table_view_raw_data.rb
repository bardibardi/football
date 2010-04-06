require 'deductions_hash'

class ResultsLineData

  attr_accessor :win, :draw, :loss, :for_goals, :against_goals

  def initialize
    @win = 0
    @draw = 0
    @loss = 0
    @for_goals = 0
    @against_goals = 0
  end

end

class ResultsSummaryData

  include Comparable

  attr_reader :rating, :games, :points, :goal_difference,
              :for_goals, :against_goals, :team_sym

  def initialize(rating, team_sym, home_rld, away_rld)
    @rating = rating
    @team_sym = team_sym
    @games = home_rld.win + home_rld.draw + home_rld.loss +
             away_rld.win + away_rld.draw + away_rld.loss
    @points =  3*(home_rld.win + away_rld.win) +
               home_rld.draw + away_rld.draw
    deduction = Deductions.hash[team_sym]
    @points -= deduction.to_i if deduction
    @for_goals = home_rld.for_goals + away_rld.for_goals
    @against_goals = home_rld.against_goals + away_rld.against_goals
    @goal_difference = @for_goals - @against_goals
  end

  def <=>(rsd)
    return 1 if @points > rsd.points
    return -1 if @points < rsd.points
    return 1 if @goal_difference > rsd.goal_difference
    return -1 if @goal_difference < rsd.goal_difference
    return 1 if @for_goals > rsd.for_goals
    return -1 if @for_goals < rsd.for_goals
    return 1 if @rating > rsd.rating
    return -1 if @rating < rsd.rating
    return 1 if @team_sym.to_s > rsd.team_sym.to_s
    -1
  end

end

class FootballTableViewData

  attr_reader :data

  def initialize(ratings, results)
    @ratings = ratings
    @results = results
    data = []
    @results.each do |team_sym, team_results|
      data << line_as_parts(@ratings[team_sym], team_sym, team_results)
    end
    @data = data.sort do |a, b|
      b[0] <=> a[0]
    end
  end

  def results_lines(team_sym, team_results)
    home = ResultsLineData.new
    away = ResultsLineData.new
    team_results.each do |result|
      if team_sym == result.home_team then
        home.win += 1 if result.home_score > result.away_score
        home.draw += 1 if result.home_score == result.away_score
        home.loss += 1 if result.home_score < result.away_score
        home.for_goals += result.home_score
        home.against_goals += result.away_score
      else
        away.win += 1 if result.away_score > result.home_score
        away.draw += 1 if result.away_score == result.home_score
        away.loss += 1 if result.away_score < result.home_score
        away.for_goals += result.away_score
        away.against_goals += result.home_score
      end
    end
    [home, away]
  end

  def line_as_parts(rating, team_sym, team_results)
     home, away = results_lines(team_sym, team_results)
     summary = ResultsSummaryData.new(rating, team_sym, home, away)
     [summary, home, away]
  end

end
