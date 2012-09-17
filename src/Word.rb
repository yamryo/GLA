#
# Word.rb
#
# Time-stamp: <2012-09-18 02:20:24 (ryosuke)>
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

 #--- mathematical operations ---
  def ===(word)
    (word*self.invert).dup.contract == '1'
  end

  def invert
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
     k == 0 ? str = '1' : str = "#{self}"*k
     return self.class.new(str)
   end
   def ^(int) self.powered_by(int) end

   def conjugated_with(other)  # The argument 'other' can be a String object.
     other = self.class.new(other) if other.is_a?(String)
     (other.invert)*self*other
   end
   def conj(another_word)
     self.conjugated_with(another_word)
   end

#--- destructive methods ------  
   def replace(other)
     other = other.gsub(/[^1a-zA-Z]/,'') rescue raise(InvalidArgument)
     super(other)
     return self
   end

   def [](int)
     c = super(int) rescue raise(InvalidArgument)
     #
     (c == c.downcase)? k=0 : k=1 
     gen = Generator.new(c.downcase).inverse(k)
     return gen
   end

   def each_gen(&block) 
     itr = Enumerator.new do |y|
       (self.size).times{ |k| y << self[k] } 
     end
     itr.each(&block)
   end

   def contract(*accelerate)
     #-- proccess with Generator class
     marr = self.each_gen.map{ |g| g }

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
     # my_str = ''
     # marr.each{|g| my_str << g.to_c}
     my_str = marr.map!{|g| g.to_c}.join
     #
     return self.replace(my_str)
   end

   undef_method :upcase!, :downcase!, :sub!, :gsub!, :concat, :[]=

end
#---------------------------

#End of File
