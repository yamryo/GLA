#
# Term.rb
#
# Time-stamp: <2012-04-22 16:30:33 (ryosuke)>
#

require('Word')

#---------------------------
class Term
  
  def initialize(word, *arg)
    case word.class.name
    when 'Word' then @word = word
    when 'String' then @word = Word.new(word)
    else raise ArgumentError, "The argument is not of Word or String class." 
    end

    if arg.size > 0 then 
      unless arg[0].to_i == arg[0] then
        raise ArgumentError, "The second argument must be an integer." 
      end
      @coeff = arg[0]
    else
      @coeff = 1
    end
  end
  attr_reader :word, :coeff

  def setup
    return self
  end

  def coeff=(num)
    @coeff = num
    @word = '1' if num == 0
  end

  def ==(other_term)
    (@word == other_term.word) and (@coeff == other_term.coeff)
  end
  def =~(other_term)
    @word == other_term.word
  end

  def product_with(other_term)
    self.class.new(@word*other_term.word, @coeff * other_term.coeff)
  end
  def multiplied_by(k)
    @coeff *= k.to_i
    return self
  end
  def *(other)
    if other.class == Term then
      self.product_with(other)
    elsif other.class == Fixnum then
      self.multiplied_by(other)
    else
      raise ArgmentError, "the argment should be an object of Term class or Fixnum class"
    end
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
