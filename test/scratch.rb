#
# scratch.rb
#
# Time-stamp: <2012-09-17 00:35:23 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('StdMagnusExp')

theta = StdMagnusExp

length = 2
#str_1 = ('a'..'z').to_a.sample(length).join
#str_2 = ('a'..'z').to_a.sample(length).join
str_1 = 'abc'
str_2 = 'def'


mwrd = Word.new(str_1)
conj = mwrd.conjugated_with(Word.new(str_2))

#p mwrd.to_s + ' --> ' + theta.expand(mwd).to_s
p mwrd.to_s + ' --> ' + theta.expand(mwrd).homo_part(2).to_s
p conj.to_s + ' --> ' + theta.expand(conj).homo_part(2).to_s
p (theta.expand(mwrd).homo_part(2) - theta.expand(conj).homo_part(2)).simplify.to_s

# -ad-ae-af-bd-be-bf-cd-ce-cf+da+db+dc+ea+eb+ec+fa+fb+fc
# =-a(d+e+f)-b(d+e+f)-c(d+e+f)+d(a+b+c)+e(a+b+c)+f(a+b+c)
# =-(a+b+c)(d+e+f)+(d+e+f)(a+b+c)
# =(d+e+f)(a+b+c)-(a+b+c)(d+e+f)
# =[d+e+f,a+b+c]

#End of File
