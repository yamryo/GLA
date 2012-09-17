#
# Generator.rb
#
# Time-stamp: <2012-09-18 02:27:08 (ryosuke)>
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
      (times == []) ? k=1 : k=times[0].to_i 
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
      product_word = (self.to_c + gen.to_c).sub('1','')
      if product_word.length == 1 then # if one of two is '1' 
        return self.set(product_word) 
        # then retrun the self replaced its letter to #{product_word}
      else 
        #  in general, retrun an array with two generators
        return Array[self, gen]
      end
    end
  end
#
end 

#End of File
