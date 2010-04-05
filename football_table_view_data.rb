require 'team_results_hash'
require 'football_table_view_raw_data'
require 'ratings_hash'
require 'team_results_hash'

module TVD

  @@ratings = Ratings.hash
  @@results = TeamResults.hash
  @@array_array = FootballTableViewData.new(@@ratings, @@results).data

  def self.array_array
    @@array_array
  end

end
