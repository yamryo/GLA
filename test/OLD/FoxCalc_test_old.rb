#
# FoxCalc_test_old.rb
#
# Time-stamp: <2010-10-09 23:07:00 (ryosuke)>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)
#require('Generator.rb')
#require('Word.rb')
require('FoxCalc.rb')

#------------------------
def timer(&block)
  start = Time.now
  block.call
  stop = Time.now
  printf "  [ done in #{stop-start} seconds. ]\n"
end
#------------------------

g1=Generator.new('a')
g2=Generator.new('B')

p g2.inverse?

fc=FoxCalculator.new 

#----------
timer{printf "d[#{g2.to_c}]/d[#{g1.to_c}] = #{fc[g1].calc(g2)}"}
#----------

#w=Word.new('aBAaaBbcAba')
w=Word.new('abA')

#----------
timer do 
  printf "d[#{w}]/d[#{g1.to_c}] = #{fc[g1].send(w)}"
end
#----------

#End of File
