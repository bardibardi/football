class HashPair
  KEY_FIELD = 0
  VALUE_FIELD = 1

  attr_reader :key, :value

  def initialize(csv_str, delimiter = ',')
    result = csv_str.chomp.split(delimiter)
    @key = result[KEY_FIELD].to_sym
    @value = result[VALUE_FIELD]
  end

end

class HashData
  attr_reader :filename, :hash

  def initialize(filename, delimiter = ',')
    @filename = filename
    @delimiter = delimiter
    init_hash
  end

  def init_hash
    @hash = {}
    IO.foreach(@filename) do |line|
      hp = HashPair.new(line, @delimiter)
      @hash[hp.key] = hp.value
    end 
  end

end

