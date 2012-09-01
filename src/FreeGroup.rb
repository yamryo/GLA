#
# FreeGroup.rb
#
# Time-stamp: <2012-04-11 14:39:36 (ryosuke)>
#

require('Generator')

#---------------------------------------------
class FreeGroup

  InvalidArgument = Class.new(StandardError)
  
  #--- initialize ----------------
  def initialize(str)
#    @alphabet = [] 
    @generators = Hash.new
#    @special_words = Hash.new

    self.build_gens("#{str}")
  end
  #-------------------------------
  attr_reader :generators

#------------------------------
#  private    # How does 'private' act???
  def build_gens(str)
    @generators.clear.store('1'.to_sym, Generator.new)

    alphabet = str.gsub(/[^1a-zA-Z]/,'').downcase.split('').uniq.sort
    raise(InvalidArgument) if alphabet.size == 0
    alphabet.each do |a| 
      @generators.store(a.to_sym, Generator.new(a)) if a != '1'
    end

    return nil
  end

  def alphabet
    alph = []
    @generators.each{ |k,v| alph << v.to_c if (v.to_c != '1')}
    return alph
  end

  # def contraction_of(str, *accelerate)
  #   ### Contracting a string(word). Return nil if contraction does not occur.
  #   original_str_size = str.size
    
  #   if accelerate[0] then
  #     #-- faster proccess      
  #     if not str.gsub!(@special_words[:product_with_its_inverse]){'1'} then
  #       str.gsub!(@special_words[:product_with_identity]){ $+ }
  #     end
  #   else
  #     #-- proccess with Generator class
  #     cnt = 0
  #     last_size = str.size
  #     while cnt < str.size - 1
  #       str[cnt,2] = @generators[str[cnt,1].to_sym]*@generators[str[cnt+1,1].to_sym]
  #       cnt += 1
  #     end
  #   end

  #   if original_str_size == str.size then
  #     return nil
  #   else
  #     return str
  #   end
  # end
#
end
#---------------------------------------------

# def random_word(n)
#   mystr = ''
#   (1..n).each{ |k| mystr << @alphabet[rand(@alphabet.size)] }
#   return Word.new(mystr)
# end

# def contract_path(word, accel_flag)
#   word = Word.new("#{word}") if word.class != Word
#   path = [] << word.dup
    
#   while contraction_of(word, accel_flag)
#     path << word.dup
#   end
# #
#   return path
# end

#End of File
