require 'hash_data'

module Deductions

  @@deductions = HashData.new('eng2010deductions.txt').hash

  def self.hash
    @@deductions
  end

end

