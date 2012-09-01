#
# Word_test.rb
#
# Time-stamp: <2010-04-28 21:23:24>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)
require('Word.rb')

#------------------------
def timer(&block)
  start = Time.now
  block.call
  stop = Time.now
  printf "  [ done in #{stop-start} seconds. ]\n"
end
#------------------------

$Alph = Word.new('abcdefgh').G.alphabet
len = 20

mystr = ''
(1..len).each{ |k| mystr << $Alph[rand($Alph.size)] }
w = Word.new(mystr)

#----------
timer{printf "w = #{w} \n\t --contract--> #{w.dup.contract}"}
timer{printf "w.dup.contract_once = #{w.dup.contract_once}"}
timer{printf "w.conjugate_by('ab') = #{w.conjugate_by('ab')}"}

id = w*w.invert
timer{printf "w*w.invert = #{id} \n\t --contract--> #{id.dup.contract}"}
#----------

#End of File
