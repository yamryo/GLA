#
# GLA/src/Word.rb
#
# Time-stamp: <2014-03-17 09:20:41 (ryosuke)>
#
require('Generator')

class Word < String

  InvalidArgument = Class.new(StandardError)

#--- initialize ----------------
  def initialize(str)
    str = str.gsub(/[^1a-zA-Z]/,'') rescue raise(InvalidArgument) 
    raise(InvalidArgument, "could not generate a word") if str.size == 0
    super(str)
  end
#-------------------------------

  def show
    {:value => self, :obj_id => self.object_id}
  end

  def each_gen(&block) 
    itr = Enumerator.new do |y|
      (self.size).times{ |k| y << Generator.new(self[k]) } 
    end
    itr.each(&block)
  end

   def gen_at(int)
     Generator.new( self[int] ) rescue raise(InvalidArgument)
   end
   
 #--- mathematical operations ---
  def ===(word)
    (word*self.invert).dup.contract == '1'
  end

  def invert()
    self.dup.reverse.swapcase
  end

  def product_with(another_word)  # another_word can be a String object.
    if self == '1' then 
      mystr = another_word
    elsif another_word == '1' then
      mystr = self
    else
      mystr = self+another_word
    end
    #
    self.class.new(mystr)
  end
  def *(another_word)
    self.product_with(another_word)
  end

  def powered_by(int)
    k = int.to_i rescue raise(InvalidArgument)
    str = ( k == 0 ? '1' : "#{self}"*k )
    return self.class.new(str)
  end
  def ^(int)
    self.powered_by(int)
  end
  
  def conjugated_with(other)  # The argument 'other' can be a String object.
    other = self.class.new(other) if other.is_a?(String)
    (other.invert)*self*other
  end
  def conj(another_word)
    self.conjugated_with(another_word)
  end

#--- destructive methods ------  
   def replace(other)
     super(other.gsub(/[^1a-zA-Z]/,'')) rescue raise(InvalidArgument)
     return self
   end

   def contract
     marr = self.each_gen.map{ |g| g } # split self into an Array of Generators
     
     size_diff = 1
     while (size_diff > 0 and marr.size > 1)
       previous_size = marr.size
       #
       marr.each.with_index do |val, idx|
         if (idx < marr.size - 1) then
           pair = marr.slice!(idx,2) 
           marr.insert(idx, pair[0]*pair[1]).flatten!
         end
       end
       #
       size_diff = previous_size - marr.size
     end
     #
     return self.replace( marr.map!{|g| g.to_char}.join )
   end

   undef_method :upcase!, :downcase!, :sub!, :gsub!, :concat, :[]=

end
#---------------------------

#End of File
