require 'hash_data'

module ViewData

  @@view_data = HashData.new('data/view_data.txt').hash

  def self.hash
    @@view_data
  end

end

