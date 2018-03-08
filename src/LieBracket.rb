#
# GLA/src/LieBracket.rb
#
# Time-stamp: <2016-04-12 16:53:13 (ryosuke)>
#

require('FormalSum')

#-------------------------------
class LieBracket < FormalSum

  #-----------------
  def initialize(elm_1=One, elm_2=One)
    @coeff = 1
    @couple = [elm_1, elm_2]
    #
    tmp = @couple.map do |elm|
      case elm
      when self.class
        FormalSum.new(elm.terms)
      when FormalSum
        elm
      when Term, Word, String
        FormalSum.new(elm)
      when Generator
        FormalSum.new(elm.to_char)
      when Numeric
        FormalSum.new(Term.new(elm))
      else
        raise InvalidArgument, "Your argument is of #{elm.class} object."
      end
    end
    #
    trms = ((tmp[0]*tmp[1])-(tmp[1]*tmp[0])).terms rescue binding.pry
    super(trms)
    #
  end
  #-----------------
  attr_accessor :couple, :coeff

  def coeff=(arg)
    raise(InvalidArgument) unless arg.kind_of?(Numeric)
    arg = arg.truncate(0) if (arg.kind_of?(Rational) && arg.denominator == 1)
    @coeff = arg
  end

  def +(another)
    self.addition(another, false)
  end
  def -(another)
    self.addition(another, true)
  end
  def addition(another, minus_flag)
    self.to_fs.tap do |former|
      latter = case another
               when self.class, FormalSum then another.to_fs
               when Term, Word, String, Fixnum, Rational then FormalSum.new(another)
               else raise(InvalidArgument, "#{another.class}") end
      latter.opposite! if minus_flag
      #---
      (former.terms).concat(latter.terms)
      former.terms.delete_at(0) if (former.terms.first == ZeroTerm and former.terms.size > 1 )
    end
  end

  def *(another)
    case another
    when Numeric
      return self.multiply_by!(another)
    # when Term, Word, String
    #   self.product_with(self.class.new(another))
    # when FormalSum
    #   self.product_with(another)
    else
      raise(InvalidArgument)
    end
  end
  def multiply_by(scalar)
    super(scalar).tap{ |result| result.coeff = @coeff * scalar }
  end
  def multiply_by!(scalar)
    super(scalar).tap{ |slf| @coeff *= scalar }
  end

  def flip
    self.class.new(@couple[1], @couple[0])*(@coeff*(-1))
  end
  def flip!
    @couple.reverse!
    @coeff = @coeff*(-1)
    return self.opposite!
  end

  def to_s
    str = @couple.map(&:to_s).join(',')
    (@coeff.to_s + "[#{str}]").gsub(/^([-]*)1(\[)/, '\1\2')
  end
#  def inspect
#    string = "#<#{self.class.name}:0x" << ('%x' % (self.object_id << 1)) << '>'
#    return string
#  end
  def inspect_couple
    "[#{@couple.map{ |x| x.inspect }.join(',')}]"
  end

  def to_fs
    self.expand
  end
  def expand
    FormalSum.new(self.terms)
  end

  #---
  def deepcopy
    # Override FormalSum.deepcopy
    # couple_copy = []
    # @couple.each do |elm|
    #   couple_copy << elm.dup
    # end
    #return self.class.new(couple_copy[0],couple_copy[1])
    cdup = couple.dup
    return self.class.new(cdup[0],cdup[1])*@coeff
  end
end
#---------------------------------

#End of File
