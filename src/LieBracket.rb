#
# LieBracket.rb
#
# Time-stamp: <2012-09-20 12:06:34 (ryosuke)>
#

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
      when Fixnum
        FormalSum.new(Term.new(elm))
      else
        raise(InvalidArgument)
      end
    end
    #
    trms = ((tmp[0]*tmp[1])-(tmp[1]*tmp[0])).terms rescue binding.pry
    super(trms)
    #
  end
  #-----------------

  def *(another)
    @couple[0]=@couple[0]*another if anoter.kind_of?(Fixnum)
    #
    super(another)
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
