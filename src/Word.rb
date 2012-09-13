#
# Word.rb
#
# Time-stamp: <2012-09-13 19:43:26 (ryosuke)>
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
    else 
      if another_word == '1' then
        mystr = self
      else
        mystr = self+another_word
      end
    end
    self.class.new(mystr)
  end
  def *(another_word)
    self.product_with(another_word)
  end

   def powered_by(int)
     k = int.to_i
     if k then
       k == 0 ? str = '1' : str = "#{self}"*k
       return self.class.new(str)
     else
       return nil
     end
   end
   def ^(int) self.powered_by(int) end

   def conjugated_with(other)  # The argument 'other' can be a String object.
     other = self.class.new(other) if other.kind_of?(String)
     (other.invert)*self*other
   end
   def conj(another_word)
     self.conjugated_with(another_word)
   end

#--- destructive methods ------  
   def replace(other)
     begin
       other = other.gsub(/[^1a-zA-Z]/,'') 
     rescue 
       raise(InvalidArgument)
     end
     super(other)
     return self
   end

   def contract(*accelerate)
     #-- proccess with Generator class
     marr = []
     self.each_char do |c|
       (c == c.downcase)? k=0 : k=1 
       marr << Generator.new(c.downcase).inverse(k)
     end

     size_diff = 1
     while (size_diff > 0 and marr.size > 1) do
       previous_size = marr.size
       
       itr = (marr.size-1).times
       itr.each do |k|
         if (k < marr.size - 1) then
           pair = marr.slice!(k,2) 
           marr.insert(k, pair[0]*pair[1]).flatten!
         end
       end

       size_diff = previous_size - marr.size
     end
     
     my_str = ''
     marr.each{|g| my_str << g.to_c}

     return self.replace(my_str)
   end

   undef_method :upcase!, :downcase!, :sub!, :gsub!, :concat, :[]=

end
#---------------------------

#End of File
