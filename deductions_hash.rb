require 'hash_data'

module Deductions

  @@deductions = HashData.new('data/eng2010deductions.txt').hash

  def self.hash
    @@deductions
  end

end

