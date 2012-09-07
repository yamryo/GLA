#
# test_FoxCalc.rb
#
# Time-stamp: <2010-10-27 20:24:56 (ryosuke)>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)

require('rubygems')
require('test/unit/full')

require('FoxCalc.rb')

class FoxCalcClassTest < Test::Unit::TestCase
#
  def setup
    @word = Word.new('1')
    @gen = Generator.new('a')
#    p 'Setting the generator of new calculator to \'a\'.'

    @fc = FoxCalculator
  end
#
  def test_for_generators
#    @gen.set('a')
    other_gen = Generator.new('a')
    assert_equal "1", @fc[@gen].calc(other_gen).to_s

    ['1', '2', 'b', 'B', 'z'].each do |c|
      assert_equal "0", @fc[@gen].calc(other_gen.set(c)).to_s
    end

    assert_equal "-A", @fc[@gen].calc(other_gen.set('A')).to_s
  end
#
  def test_for_normal_words
#    @gen.set('a')
    @word.replace('abAB')  # 1+a(0+b(-A+A(0))) = 1+a0+ab(-A)+abA0 = 1-abA
    assert_equal "1-abA", @fc[@gen].send(@word)

    # d(Bab)/d(a) = B(1+a(0)) = B
    assert_equal "B", @fc[@gen].send(@word.replace('a').conj('b'))

    @word.replace('bAcaBACBa') 
    # 0+b(-A+A(0+c(1+a(0+B(-A+A(0+C(0+B(1)..) = b(-A)+bAc1+bAcaB(-A)+bAcaBACB = -bA+bAc-bAcaBA+bAcaBACB
    assert_equal "-bA+bAc-bAcaBA+bAcaBACB", @fc[@gen].send(@word)

    @word.replace('bAcaBAcCaBa') 
    # 0+b(-A+A(0+c(1+a(0+B(0+B(1)..) = -bA+bAc+bAcaBB
    assert_equal "-bA+bAc+bAcaBB", @fc[@gen].send(@word)
  end
#
  def test_for_words_contracting_to_the_identity 
    # @gen.set('a')
    # d(aA)/d(a) = 1+a(-A+0) = 1+a*(-A)+0 = 1-aA  = 0

    ['aA', 'ZaAz', 'cBDdaAbC', 'cBDdaA-3(b+C)'].each do |str|
      @word.replace(str)  
      assert_equal "0", @fc[@gen].send(@word)
    end
  end
#----------
end

#End of File
