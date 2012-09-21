#
# FormalSum.rb
#
# Time-stamp: <2012-09-21 09:45:35 (ryosuke)>
#
require('Term')

#-------------------------------
class FormalSum
#
  Zero = Term.new('1', 0)
  One = Term.new('1', 1)

  InvalidArgument = Class.new(StandardError)

  #-----------------------------------------
  def initialize(*arr)
    @terms = [Zero]

    arr.flatten.each do |trm| 
      case trm
      when Term
        self << trm
      when String
        str2terms(trm).each{ |t| self.terms << t }
      else
        raise InvalidArgument, "Your argument is a #{trm.class.name} class object."
      end
    end
    @terms.delete_at(0) unless @terms.size == 1
  end
  #-----------------------------------------
  attr_accessor :terms

  def [](int)
    @terms[int]
  end

  def deepcopy
    # [ self.dup ] and even [ self.class.new(self.terms) ] is shallow for later use.

    terms_copy = []
    self.terms.each do |t|
      terms_copy << Term.new(t[:word], t[:coeff])
      #terms_copy << t
    end
    return self.class.new(terms_copy)
    # return Marshal.load(Marshal.dump(self))
  end

  def opposite
    (self.deepcopy).opposite!
  end
  def opposite!
    @terms.map!{ |t| t.opposite }
    return self
  end

  def -(another_fs) 
    self + another_fs.opposite
  end
  def +(another_fs)
    former = self.deepcopy
    latter = case another_fs
             when self.class then another_fs.deepcopy
             when Term, String, Fixnum then self.class.new(another_fs)
             else raise(InvalidArgument) end
    #
    (former.terms).concat(latter.terms)
    former.terms.delete_at(0) if (former.terms[0] == Zero and former.terms.size > 1 )
    return former
  end
    
  def *(another)
    case another
    when Integer, Fixnum
      self.multiply_by(another)
    when Term, Word, String
      self.product_with(self.class.new(another))
    when FormalSum
      self.product_with(another)
    else
      raise(InvalidArgument)
    end
  end
  def product_with(another_fs)
    myfs = self.class.new
    myterms = self.terms.dup.reverse
    #
    while myterms.size > 0 do
      former = myterms.pop
      another_fs.terms.each do |latter|
        myfs << former*latter
      end
    end
    #
    myfs.terms.delete_at(0) unless myfs.terms.size == 0
    return myfs
  end
  def multiply_by(int)
    myfs = self.dup
    myfs.terms.each{ |t| t.coeff = t[:coeff]*int }
    return myfs
  end
  
  def <<(term)
    if term.is_a?(Term) then
      @terms << term
    elsif term.is_a?(String) then
      @terms << Term.new(term) 
    else
      raise InvalidArgument
    end
    #
    return self
  end

  def reverse
    self.class.new(@terms).reverse!
  end
  def reverse!
    @terms.reverse!
    return self
  end

  def sort
    self.class.new(@terms).sort!
  end
  def sort!
    @terms.sort!{ |a,b| a <=> b }
    return self
  end

  def homo_part(*arg)
    ints = []
    arg.each do |a|
      case a
      when Fixnum
        ints << a
      when Array, Range
        ints << a.to_a.flatten.keep_if { |i| i.kind_of?(Integer) }
        ints.flatten!
      else 
        raise InvalidArgument
      end
    end
    ints.uniq.keep_if{ |i| i>=0 }
    #
    myterms = self.terms.dup
    myterms.keep_if{ |t| ints.include?(t.degree) }
    myterms << Zero if myterms.empty? 
    #
    return self.class.new(myterms)
  end

  def degree
    self.terms.max.degree
  end

  def simplify
    self.deepcopy.simplify!
  end
  def simplify!
    #collect same words into a sigle word, not delete zero words.

    hp_hash = Hash.new
    #
    self.terms.each do |t|
      deg = t.degree
      unless hp_hash.has_key?(deg) 
        hp_hash[deg] = FormalSum.new(t) 
      else
        hp_hash[deg] << t
      end
    end
    #
    @terms.clear
    hp_hash.each_value do |hp|
      hp.sort!
      tmp = self.class.new
      #
      until hp.terms.empty?
        tmp << hp.terms.pop
        #
        until (hp.terms.empty? or (hp.terms.last[:word] != tmp.terms.last[:word]))
          (tmp.terms.last).coeff = (tmp.terms.last)[:coeff] + (hp.terms.pop)[:coeff]
        end
        #
      end
      #
      tmp.terms.delete_at(0) unless tmp.terms == [Zero]
      (self.terms << tmp.terms).flatten!
    end
    #
    return self.sort!
  end

  def to_s
    mstr = (@terms.dup).delete_if{ |t| t[:coeff]==0}.join('+').gsub('+-','-')
    mstr = '0' if mstr.size == 0
    return mstr
  end

  def show
    @terms.map{ |t| t.show }.join('+')
  end

  private
  def str2terms (str)
    myterms = []
    #
    myarr = str.split( %r{([+-])} ).delete_if{ |x| x.empty?}
    myarr.reverse!
    while (myarr.size > 0) do
      mystr = myarr.pop
      #
      unless mystr.match( %r{(^[+-]$)} ).nil? then
        raise Error if myarr.size == 0
        mystr = (mystr + myarr.pop)
      end
      #
      myterms << Term.new(mystr)
    end
    #
    return myterms
  end
#
end
#---------------------------------

#End of File
