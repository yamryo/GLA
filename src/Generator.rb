#
# GLA/src/Generator.rb
#
# Time-stamp: <2016-04-03 21:27:25 (ryosuke)>
#
#-----------------------------------
module Gen_module
  #---
  def initialize(arg='1')
    @letter = arg[0].downcase
    @inverse = (@letter == '1') ? nil : (@letter != arg) # true or false
  end
  attr_reader :letter
end
#-----------------------------------
#-----------------------------------
class Generator
  include Gen_module
  #---
  InvalidLetter = Class.new(StandardError)
  Identity = self.new
  #---
  def initialize(arg='1')
    raise InvalidLetter, "You can use '1' and alphabets" unless arg =~ /[1a-zA-Z]/
    super(arg)
  end
  # attr_reader :letter
  #---
  def to_char
    @inverse ? @letter.upcase : @letter
  end
  def to_s
    to_char
  end
  #---
  def inverse?
    return @inverse
  end
  #---
  def invert!(*times)
    begin
      k = (times.size == 0) ? 1 : times[0].to_i
    rescue
      raise(ArgumentError)
    end
    unless @letter == '1' then
      @inverse = !@inverse if k.odd?
    end
    return self
  end
  #---
  def =~(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    (self.letter == another.letter)
  end
  #---
  def ==(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    return ( (self =~ another) and (self.inverse? == another.inverse?) )
  end
  #---
  def ===(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    return ( (self == another) and (self.object_id == another.object_id) )
  end
  #---
  def <=>(another)
    raise(ArgumentError) unless another.is_a?(Generator)
    return ( self.to_char <=> another.to_char )
  end
  #---
  def *(gen)
    self.product!(gen)
  end
  def product!(gen)
    product_word = ((self =~ gen) and !(self == gen))  ? '1' : (self.to_char + gen.to_char).sub('1', '')
    # In the case where gen is the inverse of self, return the identity.
    # In the case where self or gen is '1',
    # retrun new Generator with #{product_word} as its letter.
    # Otherwise, retrun an Array of two generators.
    return (product_word.length == 1) ? Generator.new(product_word) : Array[self, gen]
  end
end
#-----------------------------------

#End of File
