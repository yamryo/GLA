#
# scratch.rb
#
# Time-stamp: <2012-09-18 14:39:49 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('StdMagnusExp')

theta = StdMagnusExp

#length = 2
#str_1 = ('a'..'z').to_a.sample(length).join
#str_2 = ('a'..'z').to_a.sample(length).join
str_1, str_2 = 'ab', 'cd'

mwrd = Word.new(str_1)
conj = mwrd.conjugated_with(Word.new(str_2))

#p mwrd.to_s + ' --> ' + theta.expand(mwd).to_s
p mwrd.to_s + ' --> ' + theta.expand(mwrd).homo_part(2).to_s
p conj.to_s + ' --> ' + theta.expand(conj).homo_part(2).to_s
p (theta.expand(mwrd).homo_part(2) - theta.expand(conj).homo_part(2)).simplify.to_s

p "= (c+d)(a+b)-(a+b)(c+d) = [c+d,a+b]"

#End of File
