#
# Generator.rb
#
# Time-stamp: <2012-04-11 16:50:50 (ryosuke)>
#

class Generator

  InvalidLetter = Class.new(StandardError)

  def initialize(*arg)
    @letter = "1"
    @inverse = false
    
    self.set(arg[0][0,1]) if arg.length > 0
  end
  attr_reader :letter

  def set(char)
    raise(InvalidLetter) if !(char =~ /[1a-zA-Z]/)
    
    @letter = char.downcase
    @inverse = (@letter != char) # true or false

    return self
  end
  def to_c
    @inverse ? @letter.upcase : @letter
  end

  def inverse(*times)
    (times == []) ? k=1 : k=times[0].to_i
#    raise(ArgumentError) if times[0].class != Fixnum

    @inverse = !@inverse if k.odd?
    return self
  end

  def inverse?
    return @inverse
  end

  def multiple_by(gen)
    if (@letter == gen.letter and @inverse != gen.inverse?) then
      return Generator.new
    else
      product_word = (self.to_c + gen.to_c).sub('1','')
      if product_word.length == 1 then 
        # if one of two is 1 then retrun the other generators in general
        return Generator.new(product_word)
      else 
        # retrun an array with two generators in general
        return Array[self, gen]
      end
    end
  end
  def *(gen)
    self.multiple_by(gen)
  end
#
end 

#End of File
