#
# FormalSum.rb
#
# Time-stamp: <2012-09-18 00:12:17 (ryosuke)>
#

require('Term')

#-------------------------------
class FormalSum
#
  Zero = Term.new('1', 0)
  One = Term.new('1', 1)

  InvalidArgument = Class.new(StandardError)

  def initialize(*arr)
    @terms = [Zero]

    arr.flatten.each do |trm| 
      if trm.is_a?(Term) then
        self << trm
      elsif trm.is_a?(String) then
        str2terms(trm).each{ |t| self.terms << t}
      else
        raise InvalidArgument, "the argument is a #{t.class.name} class object."
      end
    end
    @terms.delete_at(0) unless @terms.size == 1
  end
  attr_accessor :terms

  def [](int)
    @terms[int]
  end

  def opposite
    @terms.map! { |t| t.opposite }
  end

  def -(another_fs) 
    self + another_fs.opposite
  end
  def +(another_fs)
    case another_fs.class.name
    when self.class.name
    when 'Term', 'String'
      another_fs = self.class.new(another_fs)
    else
      raise InvalidArgument
    end

    myfs = self.class.new(self.terms)
    another_fs.terms.each{ |t| myfs << t }
    myfs.terms.delete_at(0) if (myfs.terms.size > 1 and myfs.terms[0] == Zero)
    return myfs
  end
    
  def *(another_fs)
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

  def opposite
    @terms.map!{ |t| t.opposite }
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
      case a.class.name
      when 'Fixnum'
        ints << a
      when 'Array', 'Range'
        ints << a.to_a.flatten.keep_if { |i| i.is_a?(Integer) }
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
    self.dup.simplify!
  end
  def simplify!
    hp_hash = Hash.new
    self.terms.each do |t|
      deg = t.degree
      hp_hash[deg] = FormalSum.new unless hp_hash.has_key?(deg)
      hp_hash[deg] << t
    end
    #
    simp_fs = self.class.new
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
      simp_fs = simp_fs + tmp
    end
    #
    return simp_fs.sort
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
