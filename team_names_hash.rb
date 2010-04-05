require 'hash_data'

module TeamNames

  @@team_names = HashData.new('eng2010teamsym.txt').hash

  def self.hash
    @@team_names
  end

end

