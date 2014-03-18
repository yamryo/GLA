#
# GLA/src/Term.rb
#
# Time-stamp: <2014-03-18 13:46:23 (ryosuke)>
#
require('Word')

#---------------------------
class Term < Hash
  
  InvalidArgument = Class.new(StandardError)
  # A Regexp which matchs the scalars (Integers and Rationals) part of Strings
  RgxScalar = /(^[+-]\d*|^\d+)(\/\d+)?/
  
#--- initialize ----------------
  def initialize(*arg)
    self[:word] = Word.new('1')
    self[:coeff] = 0

    if arg.size > 0 then
      case arg[0]
      when Generator
        self[:word] = Word.new(arg[0])
        self[:coeff] = 1
      when Word
        self[:word] = arg[0]
        self[:coeff] = 1
      when String
        # First, seperate arg[0] to the scalar part and the other.
        sparr = arg[0].split(RgxScalar).delete_if{ |x| x.empty?}
        # Second, fix Array sparr up to have just two entries, the scalar and the another.
        #binding.pry if arg[0] == '+/50'
        if (%r{[+-]/}.match(arg[0]).nil?) then
          unless (%r{/\d+}.match(sparr[1]).nil?) then
            # if you are here, the scalar is a Rational
            tmp = sparr.shift
            sparr[0] = tmp+sparr[0]
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
          "The argument must be a Word or a Generator or a String or a Numeric." 
        end
        #Finaly, set entries of sparr to :coeff and :word.
        self[:coeff] = sparr[0].match('/') ? sparr[0].to_r : sparr[0].to_i
        self[:word] = Word.new(sparr[1])
      when Numeric
        self[:coeff] = arg[0]
      else 
        raise InvalidArgument,
        "The argument must be a Word or a Generator or a String or a Numeric." 
      end
    end
    
    if arg.size > 1 then 
      if arg[1].is_a?(Numeric) then
        self[:coeff] = arg[1]
      else
        raise InvalidArgument, "The second argument must be a Numeric." 
      end
    end
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
      raise InvalidArgment, "the argment should be of Term or of Numeric"
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
  
  private
  def []=(*arg)
    super
  end

end
#---------------------------

#End of File
