#
# GLA/test/scratch.rb
#
# Time-stamp: <2014-08-04 14:34:09 (ryosuke)>
require('spec_helper')

require('StdMagnusExp')
require('LieBracket')

#str_1 = (('a'..'z').to_a+('A'..'Z').to_a).sample(3).join
#str_2 = (('a'..'z').to_a+('A'..'Z').to_a).sample(3).join

length = 2
#str_1 = ('a'..'z').to_a.sample(length).join
#str_2 = ('a'..'z').to_a.sample(length).join
str_1, str_2 = 'ab', 'cd'

mwrd = Word.new(str_1)
conj = mwrd.conjugated_with(Word.new(str_2))

theta = StdMagnusExp

#p mwrd.to_s + ' --> ' + theta.expand(mwd).to_s
p mwrd.to_s + ' --> ' + theta.expand(mwrd).homo_part(2).simplify.show
p conj.to_s + ' --> ' + theta.expand(conj).homo_part(2).simplify.show
p (theta.expand(mwrd).homo_part(2) - theta.expand(conj).homo_part(2)).show

lb = LieBracket.new('a','b')
p "#{lb.to_s} = #{lb.expand}"

#(theta.expand(mwrd).homo_part(2) - theta.expand(conj).homo_part(2)).simplify.terms.each do |t|
(theta.expand(mwrd).homo_part(2)).terms.each do |t|
  p t
end

#End of File
