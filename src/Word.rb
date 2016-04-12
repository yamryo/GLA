#
# GLA/src/Word.rb
#
# Time-stamp: <2016-04-12 16:58:33 (ryosuke)>
#
require('Generator')

class Word < String

  InvalidArgument = Class.new(ArgumentError)
  Identity = self.new('1')

#--- initialize ----------------
  def initialize(str)
    str = str.gsub(/[^1a-zA-Z]/,'') rescue raise(InvalidArgument)
    raise(InvalidArgument, "could not generate a word") if str.size == 0
    super(str)
  end
#-------------------------------

  def show
    {value: self, obj_id: self.object_id}
  end

  def gen_at(int)
    Generator.new( self[int] ) rescue raise(InvalidArgument)
  end

  def each_gen(&block)
    itr = Enumerator.new do |y|
      (self.size).times{ |k| y << self.gen_at(k) }
    end
    itr.each(&block)
  end

 #--- mathematical operations ---
  def ===(word)
    (word*self.invert).dup.contract == Identity
  end

  def invert()
    self.dup.reverse.swapcase
  end

  def product_with(another_word)  # another_word can be a String or a Generator.
    another_word = another_word.to_char if another_word.kind_of?(Generator)
    mystr = if self == Identity then
              another_word
            elsif another_word == Identity then
              self
            else
              self+another_word
            end
    #
    self.class.new(mystr)
  end
  def *(another_word)
    self.product_with(another_word)
  end

  def powered_by(int)
    k = int.to_i rescue raise(InvalidArgument)
    (k == 0) ? Identity : self.class.new("#{self}"*k)
  end
  def ^(int)
    self.powered_by(int)
  end

  def conjugated_with(other)  # For 'other', a String is acceptable.
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
     #
     size_diff = 1
     while (size_diff > 0 and marr.size > 1)
       previous_size = marr.size
       #
       marr.each_with_index do |val, idx|
         if (idx < marr.size - 1) then
           pair = marr.slice!(idx,2)
           marr.insert(idx, pair[0]*pair[1]).flatten!
         end
       end
       #
       size_diff = previous_size - marr.size
     end
     #
     return self.replace( marr.map!(&:to_char).join )
   end

   undef_method :upcase!, :downcase!, :sub!, :gsub!, :concat, :[]=

end
#---------------------------

#End of File
