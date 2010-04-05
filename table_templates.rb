require 'templates'
require 'football_table_view_data'
require 'team_names_hash'
require 'cook'

module TT

  @@app = nil
  def self.link_app(app)
    @@app = app unless @@app
  end

  def self.results_line_part(results_line_data)
    @@app.haml(:results_line_part,
      :locals => {
        :win => results_line_data.win,
        :draw => results_line_data.draw,
        :loss => results_line_data.loss,
        :for_goals => results_line_data.for_goals,
        :against_goals => results_line_data.against_goals,
      }
    )
  end

  def self.results_summary_line_part(results_summary_data)
    @@app.haml(:results_summary_line_part,
      :locals => {
        :rating => Cook.rating(results_summary_data.rating),
        :games => results_summary_data.games,
        :points => results_summary_data.points,
        :goal_difference => results_summary_data.goal_difference,
        :for_goals => results_summary_data.for_goals,
        :against_goals => results_summary_data.against_goals,
        :team => TeamNames.hash[results_summary_data.team_sym]
      }
    )
  end

  def self.results_line(results_line_parts)
    results_summary_data = results_line_parts[0]
    home_results_line = results_line_parts[1]
    away_results_line = results_line_parts[2]
    @@app.haml(:results_line,
      :locals => {
        :results_summary_line_part =>
          results_summary_line_part(results_summary_data),
        :home_results_line_part => results_line_part(home_results_line),
        :away_results_line_part => results_line_part(away_results_line)
      }
    )
  end

  def self.results_table()
    items = []
    TVD.array_array.each do |array|
      items << results_line(array)
    end
    @@app.haml(:results_table,
      :locals => {
        :list => items
      }
    )
  end

  def self.results_table_wrapper()
    @@app.haml(:results_table_wrapper,
      :locals => {
        :results_table => results_table
      }
    )
  end

end
