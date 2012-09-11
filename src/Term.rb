#
# Term.rb
#
# Time-stamp: <2012-09-11 20:48:06 (ryosuke)>
#

require('Word')

#---------------------------
class Term < Hash
  
  InvalidArgument = Class.new(StandardError)
  RgxScaler = %r{(^[+-]\d*|^\d+)}  #This matchs the scalers

#--- initialize ----------------
  def initialize(*arg)
      self[:word] = Word.new('1')
      self[:coeff] = 0

    if arg.size > 0 then
      case arg[0].class.name
      when 'Word' then 
        self[:word] = arg[0]
        self[:coeff] = 1
      when 'String' then
        pair = arg[0].split(RgxScaler).delete_if{ |x| x.empty? }
        #
        if pair.size == 1 then
          pair.push('1')
          pair.reverse! if pair[0].match(RgxScaler).nil? 
        end
        #
        pair[0] += '1' if pair[0].match( %r{^[+-]$} )
        self[:coeff] = pair[0].to_i
        self[:word] = Word.new(pair[1])
      when 'Integer', 'Fixnum' then
        self[:coeff] = arg[0]
      else 
        raise InvalidArgument, "The argument is not a Word or a String." 
      end
    end
    
    if arg.size > 1 then 
      if arg[1].kind_of?(Integer) then
        self[:coeff] = arg[1]
      else
        raise InvalidArgument, "The second argument must be an integer." 
      end
    end
  end
#-------------------------------

  def word=(wrd)
    if wrd.kind_of?(Word) then
      self[:word] = wrd 
    elsif wrd.kind_of?(String) then
      self[:word] = Word.new(wrd)
    else
      raise(InvalidArgument)
    end
    return self
  end

  def coeff=(num)
    num.kind_of?(Fixnum) ? self[:coeff] = num : raise(InvalidArgument)
    return self
  end

  def =~(other_term)
    raise(InvalidArgument) unless other_term.kind_of?(Term)
    return (self[:word] == other_term[:word])
  end

  def <=>(other_term)
    rtn = self[:word].casecmp(other_term[:word])
#    binding.pry if self[:word] == 'aK'
    #
    if rtn == 0 then
      k=0
      while k < self[:word].size do
        rtn = (self[:word][k] <=> other_term[:word][k])*(-1)
        if rtn == 0 then
          k += 1
        else
          k = self[:word].size
        end
      end
    end
    #
    rtn = (self[:coeff] <=> other_term[:coeff]) if rtn == 0
    #
    return rtn
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
    self.class.new( self[:word]*other_term[:word], self[:coeff] * other_term[:coeff])
  end
  def multiplied_by(k)
    self.class.new( self[:word], self[:coeff] * k.to_i) 
  end
  
  def contract
    self[:word].contract
    return self
  end

  def degree
    tmp = self[:word].dup.contract 
    tmp == '1' ? 0 : tmp.size
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
