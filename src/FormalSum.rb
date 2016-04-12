#
# GLA/src/FormalSum.rb
#
# Time-stamp: <2016-04-12 16:45:39 (ryosuke)>
#
require('Term')

ZeroTerm = Term.new('1',0)

#-----------------------------------
module FS_module
  #---
  def initialize(arg)
    @terms = [Term.new('1',arg)]
  end
  #---
  attr_accessor :terms
end
#-----------------------------------
#-----------------------------------
class FormalSum
  include FS_module
  #---
  InvalidArgument = Class.new(StandardError)
  #---
  Zero = self.new(0)
  One = self.new(1)
  #---

  def initialize(*arr)
    super(0)
    arr.flatten.each{ |trm| self << trm }
    @terms.delete_at(0) unless @terms.size == 1
  end

  def [](int)
    @terms[int]
  end

  def deepcopy
    # For the following arithmetic operations,
    # we need a deep copy method of an instance of this class.
    # self.dup and even self.class.new(@terms) are too shallow.
    new_terms = @terms.each_with_object([]) do |t, arr|
      arr << Term.new(t[:word], t[:coeff])
    end
    return self.class.new(new_terms)
  end

  def opposite
    (self.deepcopy).opposite!
  end
  def opposite!
    @terms.map!{ |t| t.opposite }
    return self
  end

  def +(another_fs)
    former = self.deepcopy
    latter = case another_fs
             when self.class then another_fs.deepcopy
             when Term, String, Fixnum then self.class.new(another_fs)
             else raise(InvalidArgument) end
    #
    (former.terms).concat(latter.terms)
    former.terms.delete_at(0) if (former.terms[0] == ZeroTerm and former.terms.size > 1 )
    return former
  end
  def -(another_fs)
    self + another_fs.opposite
  end

  def *(another)
    case another
    when Numeric
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
    self.class.new.tap do |result|
      myterms = @terms.dup.reverse
      #
      while myterms.size > 0 do
        former = myterms.pop
        another_fs.terms.each do |latter|
          result << former*latter
        end
      end
      #
      result.terms.delete_at(0) unless result.terms.empty?
    end
  end
  def multiply_by(num)
    self.deepcopy.tap do |result|
      result.terms.map! { |t| t.multiplied_by!(num) }
    end
  end
  def multiply_by!(num)
    case num
      when Numeric
      self.terms.map! { |t| t.multiplied_by!(num) }
      return self
    else
      raise(InvalidArgument)
    end
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
    ints = arg.each_with_object([]) do |a, ints|
      case a
      when Fixnum
        ints << a
      when Array, Range
        ints << a.to_a.flatten.keep_if{ |i| i.kind_of?(Integer) }
        ints.flatten!
      else
        raise InvalidArgument
      end
    end
    ints.uniq.keep_if{ |i| i>=0 }
    #
    myterms = @terms.dup
    myterms.keep_if{ |t| ints.include?(t.degree) }
    myterms << ZeroTerm if myterms.empty?
    #
    return self.class.new(myterms)
  end

  def degree
    @terms.max.degree
  end

  def simplify
    self.deepcopy.simplify!
  end
  def simplify!
    #collect same words into a sigle word, not delete zero words.
    hp_hash = Hash.new
    #
    @terms.each do |t|
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
      tmp.terms.delete_at(0) unless tmp.terms == [ZeroTerm]
      (@terms << tmp.terms).flatten!
    end
    #
    return self.sort!
  end

  def to_s
    mstr = (@terms.dup).delete_if{ |t| t[:coeff]==0 }.join('+').gsub('+-','-')
    return (mstr.empty?) ? '0' : mstr
  end

  def show
    @terms.map(&:show).join('+')
  end

  def to_fs
    return self
  end

  #--- protected and private methods ---
  def <<(arg)
    case arg
    when Term then @terms << arg
    when Generator, Word, Fixnum, Rational then @terms << Term.new(arg)
    when String then splitter(arg).each{ |t| @terms << Term.new(t) }
    else
      raise InvalidArgument, "Your argument is a #{arg.class.name} class object."
    end
    #
    return self
  end
  protected :<<

  def splitter(str)
    re_sign = %r{([+-])}
    myterms = []
    myarr = str.split( re_sign ).delete_if(&:empty?).reverse
    while (myarr.size > 0) do
      mystr = myarr.pop
      #
      if re_sign.match(mystr) then
        raise StarndardError if myarr.empty?
        mystr += myarr.pop
      end
      #
      myterms << mystr
    end
    #
    return myterms
  end
  private :splitter
#
end
#-----------------------------------

#End of File
