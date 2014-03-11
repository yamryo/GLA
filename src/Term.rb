#
# Term.rb
#
# Time-stamp: <2014-03-11 19:44:14 (ryosuke)>
#

require('Word')

#---------------------------
class Term < Hash
  
  InvalidArgument = Class.new(StandardError)
  RgxScaler = %r{(^[+-]*\d+/*\d*)}  #This matchs the Strings expressing scalers (Integers and Rationals)

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
        pair = arg[0].split(RgxScaler).delete_if{ |x| x.empty? }
        #
        if pair.size == 1 then
          pair.push('1')
          pair.reverse! if pair[0].match(RgxScaler).nil? 
        end
        #
        pair[0] += '1' if pair[0].match( %r{^[+-]$} )
        self[:coeff] = pair[0].match('/') ? pair[0].to_r : pair[0].to_i
        self[:word] = Word.new(pair[1])
      when Numeric
        self[:coeff] = arg[0]
      else 
        raise InvalidArgument, "The argument is not a Word or a Generator or a String." 
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
    self.class.new( self[:word], self[:coeff] * k.to_i) 
  end
  def multiplied_by!(k)
    self.coeff = self[:coeff] * (k.is_a?(Numeric) ? k : 1)
    return self
  end
  
  def contract
    self[:word].contract
    return self
  end

  def degree
    rtn = 0
    #
    if self[:coeff] == 0 then 
      rtn = -1.0/0.0 
    else
      cont_word = self[:word].dup.contract
      rtn = cont_word.size unless cont_word == '1'
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
