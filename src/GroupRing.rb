#
# GroupRing.rb
#
# Time-stamp: <2010-09-01 10:34:40 (ryosuke)>
#

require('FreeGroup')

#---------------------------------------------
class GroupRing
  #--- initialize ----------------
  def initialize(frgr)
    @gr = frgr
  end
  #-------------------------------
  attr_reader :frgr

#------------------------------
#  private    # How does 'private' act???
  def collect(gen)
  end

  def expand(gen)
  end
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
