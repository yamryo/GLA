#
# test_Generator.rb
#
# Time-stamp: <2012-04-11 16:58:12 (ryosuke)>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)

require('rubygems')
#require('test/unit/full')
require('test/unit')
require('test_unit_extensions')
require('Generator')

class GeneratorClassTest < Test::Unit::TestCase
  def setup
    @arg = 'n'
    @gen = Generator.new(@arg)
  end
#---

  must "initializing right" do
    assert_equal @arg, @gen.to_c
    assert !@gen.inverse?
    assert_raises(Generator::InvalidLetter) do 
      Generator.new('&').to_c
    end
  end

  must "initializing right with no arg" do
    assert_equal '1', Generator.new.to_c
    assert !Generator.new.inverse?
  end

  must "raise exception when a wrong argument is given" do
    assert_raises(Generator::InvalidLetter) do 
      @gen.set('@').to_c
    end
  end

  must "upper case means inverse" do
    assert @gen.set(@arg.upcase).inverse?
  end

  must "inverse generators be shown as upper case charactors" do
    assert (@gen.inverse.to_c =~ /[A-Z]/)
  end

  must "inverse a generator with an integer argument" do
    [1,3,5].each{ |k| assert_equal @gen.inverse?, !@gen.dup.inverse(k).inverse?}
    [0,2,4].each{ |k| assert_equal @gen.inverse?, @gen.dup.inverse(k).inverse?}
  end

  must "multiplication with its inverse yields 1" do
    assert_equal '1', (@gen*@gen.dup.inverse).to_c
  end

  must "multiplication of two generators be an array of them" do
    other = Generator.new('S')
    assert_equal [@gen,other], @gen*other
  end
#    
end
#----------

#End of File
