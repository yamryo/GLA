#
# GLA/src/Term.rb
#
# Time-stamp: <2016-03-02 16:52:04 (ryosuke)>
#
require('Word')

#---------------------------
class Term < Hash

  InvalidArgument = Class.new(StandardError)
  # A Regexp which matchs the scalars (Integers and Rationals) part of Strings
  RgxScalar = /(^[+-]\d*|^\d+)(\/\d+)?/

#--- initialize ----------------
  def initialize(*arg)
    self[:coeff] = nil #0
    self[:word] = nil #Word.new('1')

    #--- put given arguments into a Hash 'myarg' rightly ---
    arg << 1 << 1 # to make arg.size to be >= 2
    myarg = {}
    if arg[0].kind_of?(Numeric) then
      myarg[:num] = arg[0]
      myarg[:str] = (arg[1].kind_of?(Numeric)) ? '1' : arg[1]
    else
      myarg[:num] = (arg[1].kind_of?(Numeric)) ? arg[1] : 1
      myarg[:str] = arg[0]
    end
    if (RgxScalar.match(myarg[:str]) rescue raise(InvalidArgument)) then
      sparr = separate(myarg[:str])
      myarg[:num] = (myarg[:num] == 1) ? sparr[0] : myarg[:num]
      myarg[:str] = sparr[1]
    end
    #-------------------------------------------------------

    set_coeff( myarg[:num] )
    set_word( myarg[:str] )
  end
#-------------------------------

  def word=(wrd)
    if wrd.is_a?(Word) then
      self[:word] = wrd
    elsif wrd.is_a?(String) then
      self[:word] = Word.new(wrd)
    else
      raise(InvalidArgument)
    end
    return self
  end

  def coeff=(num)
    raise(InvalidArgument) unless num.kind_of?(Numeric)
    self[:coeff] = num
    return self
  end

  def =~(other_term)
    raise(InvalidArgument) unless other_term.is_a?(self.class)
    return (self[:word] == other_term[:word])
  end

  def <=>(other_term)
    unless (self.degree == other_term.degree) then
      rtn = ( (self.degree < other_term.degree) ? -1 : 1 )
    else
      rtn = self[:word].casecmp(other_term[:word])
    #
      if rtn == 0 then
        k=0
        while k < self[:word].size do
          rtn = (self[:word][k] <=> other_term[:word][k])*(-1)
          k = ( (rtn == 0) ? k + 1 : self[:word].size )
        end
      end
      #
      rtn = (self[:coeff] <=> other_term[:coeff]) if rtn == 0
      #
      return rtn
    end
  end

  def *(other)
    if other.is_a?(self.class) then
      self.product_with(other)
    elsif other.is_a?(Numeric) then
      self.multiplied_by(other)
    else
      raise InvalidArgument, "the argment should be of Term or of Numeric"
    end
  end
  def product_with(other_term)
    self.class.new( self[:word]*other_term[:word], self[:coeff] * other_term[:coeff])
  end
  def multiplied_by(k)
    self.class.new( self[:word], self[:coeff] * ( k.is_a?(Numeric) ? k : 1 ))
  end
  def multiplied_by!(k)
    self.coeff = self[:coeff] * ( k.is_a?(Numeric) ? k : 1 )
    return self
  end

  def contract
    self[:word].contract
    return self
  end

  def degree
    if self[:coeff] == 0 then
      rtn = -1/0.0 # which means -Infinity.
    else
      cont_word = self[:word].dup.contract
      rtn = (cont_word == '1') ? 0 : cont_word.size
    end
    #
    return rtn
  end

  def sign
    if self[:coeff] == 0 then
      return nil
    else
      self[:coeff] > 0 ? '+' : '-'
    end
  end
  def positive?
    return (self[:coeff] > 0)
  end
  def negative?
    return (self[:coeff] < 0)
  end
  def opposite
    self.coeff = self[:coeff]*(-1)
    return self
  end

  def to_s
    case self[:coeff]
    when 0 then return '0'
    when 1 then return self[:word]
    when -1 then return '-' + self[:word]
    else
      self[:word] == '1' ? self[:coeff].to_s : self[:coeff].to_s + self[:word]
    end
  end
  def show
    return '('+self[:coeff].to_s+')'+self[:word]
  end

  #--------------------------------
  private
  def []=(*arg)
    super
  end

  def set_word(arg)
    case arg
    when Generator, String
      self[:word] = Word.new(arg)
    when Word
      self[:word] = arg
    else
      raise InvalidArgument,
            "The first argument must be a Word or a Generator or a String."
    end
  end

  def set_coeff(arg)
    if arg.kind_of?(Numeric) then
      self[:coeff] = arg
    else
      raise InvalidArgument,
            "The argument for the key :coeff must be a Numeric."
    end
  end

  def separate(str)
    # First, seperate str to the scalar part and the other.
    sparr = str.split(RgxScalar).delete_if{ |x| x.empty?}
    # Second, fix Array sparr to have just two entries, a scalar and the other.
    if (%r{[+-]/}.match(str).nil?) then
      unless (%r{/\d+}.match(sparr[1]).nil?) then
        # if you are here, the scalar is a Rational
        tmp = sparr.shift
        sparr[0] = tmp + sparr[0]
      end
    end
    case sparr.size
    when 1 # The case where no scalars or no letters
      sparr.push('1')
      sparr.reverse! if sparr[0].match(RgxScalar).nil?
    when 2 # The normal case
      sparr[0] += '1' if sparr[0].match( %r{^[+-]$} )
    else
      raise InvalidArgument,
            "The first argument must be a Word or a Generator or a String or a Numeric."
    end
    #Finaly, convert sparr[0] into Integer or Rational
    sparr[0] = sparr[0].match('/') ? sparr[0].to_r : sparr[0].to_i
    return sparr
  end
end
#---------------------------

#End of File
