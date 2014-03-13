#
# GLA/src/LieBracket.rb
#
# Time-stamp: <2014-03-13 17:45:05 (ryosuke)>
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
    couple_copy = []
    @couple.each do |elm|
      couple_copy << elm.deepcopy
    end
    return self.class.new(couple_copy[0],couple_copy[1])
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
  def multiply_by(scaler)
    mylb = super(scaler)
    mylb.couple[0] = mylb.couple[0]*scaler
    return mylb
    #return scaler.kind_of?(Fixnum) ? super(scaler).couple[0]*scaler : self
  end

  def to_s
    return "[#{(@couple.map{ |x| x.to_s }).join(',')}]"
  end
  #
  def expand
    return FormalSum.new(self.terms)
  end
  #
end
#---------------------------------

#End of File
