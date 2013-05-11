require_relative 'config/data'
require 'hash_data'

module Deductions

  @@deductions = HashData.new('data/eng' + YEAR_DATA + 'deductions.txt').hash

  def self.hash
    @@deductions
  end

end

