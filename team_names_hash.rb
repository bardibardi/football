require_relative 'config/data'
require 'hash_data'

module TeamNames

  @@team_names = HashData.new('data/eng' + YEAR_DATA + 'teamsym.txt').hash

  def self.hash
    @@team_names
  end

end

