#
# FormalSum.rb
#
# Time-stamp: <2012-09-11 19:31:14 (ryosuke)>
#

require('Term')

#-------------------------------
class FormalSum
#
  Zero = Term.new('1', 0)
  One = Term.new('1', 1)

  def initialize(*arr)
    @terms = [Zero]

    arr.flatten.each do |trm| 
      if trm.kind_of?(Term) then
        self << trm
      elsif trm.kind_of?(String) then
        str2terms(trm).each{ |t| self.terms << t}
      else
        raise ArgumentError, "the argument is a #{t.class.name} class object."
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
      raise ArgumentError
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
      raise ArgumentError
    end
    #
    return self
  end

  def sort!
    @terms.sort_by!{ |t| [t.degree, t] }
#    @terms.sort!{ |a,b| a <=> b }
    return self
  end
  def sort
    self.class.new(@terms).sort!
  end

  def homo_part(int)
    int = int.to_i
    raise ArgumentError unless int.class.name == "Fixnum"

    myfs = self.class.new
    self.sort.terms.each{ |t| myfs << t if t.degree == int}
    myfs.terms.delete_at 0 if myfs.terms.size > 1 and myfs.terms[0] == Zero
    return myfs
  end

  def simplify!
    myhp = self.class.new
    k = 0 
    while myhp.size > 0 do
      myhp = self.homo_part(k)
      #-- TODO --#
    end
    return self
  end
  def simplify
    self.class.new(@terms).simplify!
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
