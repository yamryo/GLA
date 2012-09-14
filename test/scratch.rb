#
# scratch.rb
#
# Time-stamp: <2012-09-14 20:48:45 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('StdMagnusExp')

theta = StdMagnusExp

#str_1 = (('a'..'z').to_a+('A'..'Z').to_a).sample(3).join
#str_2 = (('a'..'z').to_a+('A'..'Z').to_a).sample(3).join

length = 2
#str_1 = ('a'..'z').to_a.sample(length).join
#str_2 = ('a'..'z').to_a.sample(length).join

str_1 = 'ab'
str_2 = 'cd'


mwrd = Word.new(str_1)
conj = mwrd.conjugated_with(Word.new(str_2))

#p mwrd.to_s + ' --> ' + theta.expand(mwd).to_s
p mwrd.to_s + ' --> ' + theta.expand(mwrd).homo_part(2).to_s
p conj.to_s + ' --> ' + theta.expand(conj).homo_part(2).to_s
p (theta.expand(mwrd).homo_part(2) - theta.expand(conj).homo_part(2)).simplify.to_s

p "= (c+d)(a+b)-(a+b)(c+d) = [c+d,a+b]"

#End of File
