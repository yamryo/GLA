#
# FormalSum.rb
#
# Time-stamp: <2012-05-07 17:51:57 (ryosuke)>
#

require('Term')
require('ruby-debug')  #require('pry')

#-------------------------------
class FormalSum
#
  Zero = Term.new('1', 0)
  One = Term.new('1', 1)

  def initialize(*arr)
    @terms = []
    re_coeff = %r{([+-]\d*|^\d+)}  #This matchs the scalers

#--------------
# debugger  #binding.pry
#--------------

    arr.flatten.each do |t| 
      if t.class.name == 'Term' then
        @terms << t unless t == Zero
      elsif t.class.name == 'String' then
        myarr = t.split(re_coeff).delete_if{ |x| x.empty?}
        while myarr.size > 0 do
          myword, mycoeff = '1', 1

          mystr = myarr.pop
          if (mystr =~ re_coeff).nil? then
            myword = mystr 
            myarr.size > 0 ? mystr = myarr.pop : mystr = '1'
          end
          (mystr =~ %r{(^[+-]$)}).nil? ? mycoeff = mystr.to_i : mycoeff = (mystr+'1').to_i
          @terms << Term.new(myword, mycoeff) unless mycoeff == 0
        end
#--------------
# debugger  #binding.pry        
#--------------
        @terms.reverse!
      else
        raise ArgumentError, "the argument is a #{t.class.name} class object."
      end
    end
    @terms << Zero if @terms.size == 0
  end
  attr_accessor :terms

  def [](int)
    @terms[int]
  end

  def <<(term)
    @terms << term if term.class.name == 'Term'
    return nil
  end
  def +(other_fs)
    if other_fs.class.name == 'Term' then
      other_fs = self.class.new(other_fs)
    end
    raise ArgumentError unless other_fs.class.name == self.class.name
    
    myfs = self.class.new(self.terms)
    other_fs.terms.each{ |t| myfs << t }
    myfs.terms.delete_at 0 if myfs.terms.size > 1 and myfs.terms[0] == Zero
    return myfs
  end

  def homo_part(int)
    int = int.to_i
    raise ArgumentError unless int.class.name == "Fixnum"

    myfs = self.class.new
    self.sort.terms.each{ |t| myfs << t if t.degree == int}
    myfs.terms.delete_at 0 if myfs.terms.size > 1 and myfs.terms[0] == Zero
    return myfs
  end

  def sort!
    @terms.sort_by!{ |t| [t.degree, t.word, t.coeff] }
    return self
  end
  def sort
    self.class.new(@terms).sort!
  end

  def simplify!
    myhp = self.class.new
    k = 0 
    while myhp.size > 0 do
      myhp = self.homo_part(k)
    end

    return self
  end
  def simplify
    self.class.new(@terms).simplify!
  end

  def to_s
    @terms.join('+').gsub('+-','-')
  end
#
end
#---------------------------------

#End of File
