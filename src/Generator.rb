#
# GLA/src/Generator.rb
#
# Time-stamp: <2014-03-12 16:41:59 (ryosuke)>
#

class Generator
#
  InvalidLetter = Class.new(StandardError)
#
  def initialize(arg='1')
    self.set(arg)
  end
  attr_reader :letter
#
  def set(char)
    raise(InvalidLetter) unless char =~ /[1a-zA-Z]/
    #
    @letter = char.downcase
    @letter == '1' ? @inverse = nil : @inverse = (@letter != char) # true or false
    #
    return self
  end
#
  def to_c
    @inverse ? @letter.upcase : @letter
  end
#
  def inverse(*times)
    begin
      k = (times == []) ? 1 : times[0].to_i 
    rescue 
      raise(ArgumentError)
    end
    unless @letter == '1' then
      @inverse = !@inverse if k.odd?
    end
    return self
  end
#
  def inverse?
    return @inverse
  end
#
  def =~(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    (self.letter == another.letter)
  end
#
  def ==(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    return ( (self =~ another) and (self.inverse? == another.inverse?) )
  end
#
  def ===(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    return ( (self == another) and (self.object_id == another.object_id) )
  end
#
  def <=>(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    return ( self.to_c <=> another.to_c )
  end
#
  def *(gen)
    self.multiple_by(gen)
  end
  def multiple_by(gen)
    if (@letter == gen.letter and @inverse != gen.inverse?) then
      return Generator.new
    else
      # In the case where one of self and gen is '1',
      # retrun self which is replaced its letter to #{product_word}.
      # In general, retrun an Array of two generators.
      product_word = (self.to_c + gen.to_c).sub('1','')
      return (product_word.length == 1) ? self.set(product_word) : Array[self, gen]
    end
  end
#
end 

#End of File
