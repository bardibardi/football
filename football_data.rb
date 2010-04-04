class FootballResult
  DATE_FIELD = 0
  HOME_TEAM_FIELD = 1
  AWAY_TEAM_FIELD = 2
  HOME_SCORE_FIELD = 3
  AWAY_SCORE_FIELD = 4
  JULY = '07'

  attr_reader :date, :home_team, :away_team, :home_score, :away_score

  def initialize(csv_str)
    result = csv_str.chomp.split(',')
    date_str = result[DATE_FIELD]
    if date_str > JULY then
      date_str = '2009' + date_str
    else
      date_str = '2010' + date_str
    end
    @date = date_str.to_i
    @home_team = result[HOME_TEAM_FIELD].to_sym
    @away_team = result[AWAY_TEAM_FIELD].to_sym
    @home_score = result[HOME_SCORE_FIELD].to_i
    @away_score = result[AWAY_SCORE_FIELD].to_i
  end

end

class FootballData
  attr_reader :filename, :data

  def initialize(filename)
    @filename = filename
    init_data
  end

  def init_data
    @data = []
    IO.foreach(@filename) do |line|
      data << FootballResult.new(line)
    end 
  end

end

