#
# Loop_tester.rb
#
# Time-stamp: <2010-04-27 20:27:48>
#

src_path = Dir.pwd + '/../src'
$LOAD_PATH.unshift(src_path)
require('Loop.rb')

 loops = Hash.new
 loops[:a] = Loop.new('abc')
 loops[:b] = Loop.new('def')
 loops[:comp] = loops[:a]*loops[:b]
 # loops[:invt] = loops[:a]*(loops[:b].invert)
 # loops[:conj] = loops[:a].conjugate_by(loops[:b])
 # loops[:powr] = loops[:a]^3
 # loops[:cntr] = (loops[:a]*loops[:a].invert).contract
 #p loops

 # loops.each do |k,v|
 #   p [k, v, v.class, v.G.alphabet]
 # end

 l = loops[:comp]
 #(-l.size..l.size).each{ |i| p l.cyclic(i)}
 #(-l.size..l.size).each{ |k| p [k, l.segment(k), l.segment(k).class].inspect} 
 p l
 l.twist_along(loops[:b])

#End of File
