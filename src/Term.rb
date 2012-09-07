#
# Term.rb
#
# Time-stamp: <2012-09-07 18:49:59 (ryosuke)>
#

require('Word')

#---------------------------
class Term
  
  InvalidArgument = Class.new(StandardError)

#--- initialize ----------------
  def initialize(*arg)
    raise(InvalidArgument, "no arguments!!") unless arg.size > 0
    word = arg[0]
    case word.class.name
    when 'Word' then @word = word
    when 'String' then @word = Word.new(word)
    else raise InvalidArgument, "The argument is not a Word or a String." 
    end
    
    if arg.size == 1 then 
      @coeff = 1
    else
      raise InvalidArgument, "The second argument must be an integer." unless arg[1].kind_of?(Fixnum)
      @coeff = arg[1]
    end
  end
  attr_reader :word, :coeff
#-------------------------------

  # def setup(*arg)
  #   self.initialize(*arg)
  #   return self
  # end

  def coeff=(num)
    num.kind_of?(Fixnum) ? @coeff = num : raise(InvalidArgument)
    return self
  end

  def ==(other_term)
    raise(InvalidArgument) unless other_term.kind_of?(Term)
    return ((@word == other_term.word) and (@coeff == other_term.coeff))
  end
  def =~(other_term)
    raise(InvalidArgument) unless other_term.kind_of?(Term)
    return (@word == other_term.word)
  end

  def *(other)
    if other.kind_of?(Term) then
      self.product_with(other)
    elsif other.kind_of?(Fixnum) then
      self.multiplied_by(other)
    else
      raise InvalidArgment, "the argment should be of Term or of Fixnum"
    end
  end
  def product_with(other_term)
    self.class.new(@word*other_term.word, @coeff * other_term.coeff)
  end
  def multiplied_by(k)
    self.class.new(@word, @coeff * k.to_i) 
  end
  
  def contract
    @word.contract
    return self
  end

  def degree
    tmp = @word.dup.contract 
    tmp == '1' ? 0 : tmp.size
  end
  def sign
    @coeff > 0 ? '+' : '-'
  end
  def positive?
    return (@coeff > 0)
  end
  def negative?
    return (@coeff < 0)
  end

  def to_s
    case @coeff
    when 0
      return '0'
    when 1
      return @word
    when -1
      return '-' + @word
    else
      @word == '1' ? @coeff.to_s : @coeff.to_s + @word
    end
  end
end
#---------------------------

#End of File
