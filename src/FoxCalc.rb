#
# FoxCalc.rb
#
# Time-stamp: <2012-09-13 18:37:36 (ryosuke)>
#
require('Word')

module FoxCalculator
  extend self

  Zero = FormalSum::Zero
  One = FormalSum::One

  def initialize(*arg)
    if arg.size >0 and arg[0].class == Generator then
      @generator = arg[0]
    else
      @generator = Generator.new('1')
    end
    @generator.inverse if @generator.inverse? 
  end
  attr_reader :generator

  def [](gen)
    if gen.class == Generator then
      @generator = gen 
    elsif gen.class == String then
      @generator = Generator.new(gen[0])
    else
      @generator = Generator.new('1')
    end
    return self
  end

  def calc(gen) 
    # del(gen)/del(@generator) returns Zero, One or Term '-#{gen.to_c}' 
    gen = Generator.new(gen[0]) if gen.class == String  # can accept a string
    raise ArgumentError, "The argument is not a word." unless gen.class == Generator

    if @generator.letter == gen.letter then
      !gen.inverse? ? One : Term.new(gen.to_c, -1)
    else 
      return Zero
    end
  end

  def send(word)
    raise ArgumentError, "The argument is not a word." unless word.class == Word

    word.contract
    myarr = [Zero, One]
    word.each_char do |chr|
      t = self.calc(Generator.new(chr))
      last = myarr.pop
      myarr.concat [last*t, last*Term.new(chr)]
    end
    myarr.pop
#    myarr.delete_at 0
#    myarr.delete(Zero) if myarr.size > 1
#    myarr.delete_if{ |x| x.coeff == 0}

    return FormalSum.new(myarr).to_s
#    
  end
#
end

#==============
# End of File
#==============
