#
# FormalSum.rb
#
# Time-stamp: <2012-09-12 19:35:20 (ryosuke)>
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
      if trm.kind_of?(Term) then
        self << trm
      elsif trm.kind_of?(String) then
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

  def +(other_fs)
    case other_fs.class.name
    when self.class.name
    when 'Term', 'String'
      other_fs = self.class.new(other_fs)
    else
      raise InvalidArgument
    end

    myfs = self.class.new(self.terms)
    other_fs.terms.each{ |t| myfs << t }
    myfs.terms.delete_at(0) if myfs.terms.size > 1 and myfs.terms[0] == Zero
    return myfs
  end

  def <<(term)
    if term.kind_of?(Term) then
      @terms << term
    elsif term.kind_of?(String) then
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

  def homo_part(int)
    raise InvalidArgument unless ( int.kind_of?(Integer) and int >=0 )
    myterms = self.terms.dup
    myterms.keep_if{ |t| t.degree == int }
    myterms << Zero if myterms.empty? 
    return self.class.new(myterms)
  end

  def degree
    self.terms.max.degree
  end

  def simplify
    self.dup.simplify!
  end
  def simplify!
    hp_arr = []
    #
    (self.degree+1).times{ |d| hp_arr[d] = self.homo_part(d).sort!.reverse! }
    #
    hp_arr.map! do |hp|
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
      tmp  # the return value of this block called by map!
    end
    #
    simplified_str = hp_arr.map!{ |hp| hp.to_s}.join('+').gsub('+-','-')
    #
    self.class.new( simplified_str )
  end

  def to_s
    mstr = (@terms.dup).delete_if{ |t| t[:coeff]==0}.join('+').gsub('+-','-')
    mstr = '0' if mstr.size == 0
    return mstr
  end

  def show
    @terms.map{ |t| t.show }.join('+')
  end

  def opposite
    @terms.map!{ |t| t.opposite }
    return self
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
