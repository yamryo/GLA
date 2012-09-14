#
# StdMagnusExp.rb
#
# Time-stamp: <2012-09-14 13:37:36 (ryosuke)>
#

require('FormalSum')

module StdMagnusExp
  extend self

  Zero = FormalSum::Zero
  One = FormalSum::One

  def expand(word)
    marr = []
    #
    if word.kind_of?(Generator) then
      marr << self.map(word)
    elsif word.kind_of?(Word) 
      word.contract
      word.each_char{ |chr| marr << self.map(Generator.new(chr)) }
    else
      raise ArgumentError, "The argument is not a Word."
    end
    #
    marr.reverse!
    marr << (marr.pop)*(marr.pop) until marr.size == 1
    #
#    binding.pry if word == 'bAcaBACBa'
    return marr[0].simplify
  end
  
  def map(gen) 
    # The standerd Magnus expansion theta_std(gen) maps 
    # a Generator gen of downcase letter to a FormalSum '1+#{gen.to_c}'.
    #
    gen = Generator.new(gen[0]) if gen.kind_of?(String)  # a String is acceptable
    raise ArgumentError, "The argument is not a Generator" unless gen.kind_of?(Generator)
    #
    if gen.letter == '1' then
      mstr = "1" 
    elsif gen.inverse? then
      gen.inverse
      mstr = "1-#{gen.to_c}+#{gen.to_c}#{gen.to_c}-#{gen.to_c}#{gen.to_c}#{gen.to_c}" 
    else
      mstr = "1+#{gen.to_c}"
    end
    #
    return FormalSum.new(mstr)
  end
  
end

#==============
# End of File
#==============
