#
# Generator.rb
#
# Time-stamp: <2012-09-07 13:24:39 (ryosuke)>
#

class Generator
#
  InvalidLetter = Class.new(StandardError)
#
  def initialize(*arg)
    @letter = "1"
    @inverse = false
    
    self.set(arg[0][0,1]) if arg.length > 0
  end
  attr_reader :letter
#
  def set(char)
    raise(InvalidLetter) unless char =~ /[1a-zA-Z]/
    
    @letter = char.downcase
    @inverse = (@letter != char) # true or false

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
    @inverse = !@inverse if k.odd?
    return self
  end
#
  def inverse?
    return @inverse
  end
#
  def =~(another)
    raise(ArgumentError) unless another.kind_of?(Generator)
    (self.letter == another.letter)
  end
#
  def ==(another)
    raise(ArgumentError) unless another.kind_of?(Generator)
    return ( (self =~ another) and (self.inverse? == another.inverse?) )
  end
#
  def ===(another)
    raise(ArgumentError) unless another.kind_of?(Generator)
    return ( (self == another) and (self.object_id == another.object_id) )
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
        return self.set(product_word) # then retrun the self replaced its letter to #{product_word}
      else 
        #  in general, retrun an array with two generators
        return Array[self, gen]
      end
    end
  end
#
end 

#End of File
