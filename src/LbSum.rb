#
# GLA/src/LbSum.rb
#
# Time-stamp: <2014-08-04 14:29:24 (ryosuke)>
#

require('FormalSum')
require('LieBracket')

#-------------------------------
class LbSum
  #< FormalSum
  #undef_method :*, :product_with, :splitter

  #-----------------------------------------
  def initialize(*arr)
    @terms = [{ lb: LieBracket.new, coeff: 0 }]
    arr.flatten.each{ |trm| self << trm }
    @terms.delete_at(0) unless @terms.size == 1
  end
  #-----------------------------------------
  attr_accessor :terms

  def [](int)
    @terms[int]
  end

  def to_s
    #binding.pry
    arr = @terms.map do |t|
      (case t[:coeff]
       when 1 then ''
       when -1 then '-'
       else t[:coeff].to_s end) + t[:lb].to_s
    end
    return arr.join('+').gsub('+-', '-')
  end
  
  def deepcopy
    # For the following arithmetic operations, 
    # we need a deep copy method of an instance of this class.
    # self.dup and even self.class.new(@terms) are too shallow. 
    terms_copy = []
    @terms.each do |t|
      terms_copy << {lb: t[:lb], coeff: t[:coeff]}
    end
    return self.class.new(terms_copy)
  end
  
  def opposite
    (self.deepcopy).opposite!
  end
  def opposite!
    @terms.map!{ |t| t[:coeff] *= (-1) }
    return self
  end

  def +(another)
    former = self.deepcopy
    latter = case another
             when self.class then another.deepcopy
             when Term, String, Fixnum then self.class.new(another)
             else raise(InvalidArgument) end
    #
    (former.terms).concat(latter.terms)
    former.terms.delete_at(0) if (former.terms[0] == Zero and former.terms.size > 1 )
    return former
  end
  def -(another) 
    self + another.opposite
  end
    
  def bracket_with(another)
    case another
    when Term, Word, String
      another = self.class.new(another)
    when self.class
    else
      raise(InvalidArgument)
    end
    
    myfs = self.class.new
    myterms = @terms.dup.reverse
    #
    while myterms.size > 0 do
      former = myterms.pop
      another.terms.each do |latter|
        myfs << former*latter
      end
    end
    #
    myfs.terms.delete_at(0) unless myfs.terms.size == 0
    return myfs
  end
  
  def multiply_by(num)
    raise(InvalidArgument) unless another.is_a?(Numeric)
    
    myfs = self.deepcopy
    myfs.multiply_by!(num)
    return myfs
  end
  def multiply_by!(num)
    raise(InvalidArgument) unless another.is_a?(Numeric)
    
    self.terms.map!{ |t| t[:coeff] *= num }
    return self
  end
  
  #--- protected and private methods ---
  def <<(arg)
    case arg
    when LieBracket then @terms << { lb: arg, coeff: 1 }
    when Hash then
      (arg.has_key?(:lb) && arg[:lb].class == LieBracket) && (arg.has_key?(:coeff) && arg[:lb].class == LieBracket)
      
      @terms << arg
    else
      raise InvalidArgument, "Your argument is a #{arg.class.name} class object."
    end
    #
    return self
  end
  protected :<<

  # def splitter(str)
  #   myterms = []
  #   # binding.pry
  #   myarr = str.split( %r{([+-])} ).delete_if{ |x| x.empty?}.reverse
  #   while (myarr.size > 0) do
  #     mystr = myarr.pop
  #     #
  #     unless mystr.match( %r{(^[+-]$)} ).nil? then
  #       raise Error if myarr.size == 0
  #       mystr = (mystr + myarr.pop)
  #     end
  #     #
  #     myterms << mystr
  #   end
  #   #
  #   return myterms
  # end
  # private :splitter
#
end
#---------------------------------

#End of File
