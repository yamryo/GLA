#
# GLA/src/LieBracket.rb
#
# Time-stamp: <2014-03-18 13:46:01 (ryosuke)>
#

require('pry')
require('pry-byebug')

require('FormalSum')

#-------------------------------
class LieBracket < FormalSum

  InvalidArgument = Class.new(StandardError)

  #-----------------
  def initialize(elm_1=One, elm_2=One)
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
  attr_accessor :couple

  def deepcopy
    # Override FormalSum.deepcopy
    # couple_copy = []
    # @couple.each do |elm|
    #   couple_copy << elm.dup
    # end
    #return self.class.new(couple_copy[0],couple_copy[1])
    cdup = couple.dup
    return self.class.new(cdup[0],cdup[1])
  end

  def *(another)
    case another
    when Numeric
      return self.multiply_by(another)
    # when Term, Word, String
    #   self.product_with(self.class.new(another))
    # when FormalSum
    #   self.product_with(another)
    else
      raise(InvalidArgument)
    end
  end
  def multiply_by(scalar)
    mylb = super(scalar)
    mylb.couple[0] = mylb.couple[0]*scalar
    return mylb
    #return scalar.kind_of?(Fixnum) ? super(scalar).couple[0]*scalar : self
  end

  def to_s
    return "[#{(@couple.map{ |x| x.to_s }).join(',')}]"
  end
#  def inspect
#    string = "#<#{self.class.name}:0x" << ('%x' % (self.object_id << 1)) << '>'
#    return string
#  end
  def inspect_couple
    return "[#{@couple.map{ |x| x.inspect }.join(',')}]"
  end
  
  def expand
    return FormalSum.new(self.terms)
  end
  #
end
#---------------------------------

#End of File
