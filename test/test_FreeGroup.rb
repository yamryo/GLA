#
# test_FreeGroup.rb
#
# Time-stamp: <2012-04-11 14:49:39 (ryosuke)>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)

require('rubygems')
#require('test/unit/full')
require('test/unit')
require('test_unit_extensions')
require('FreeGroup')

class FreeGroupClassTest < Test::Unit::TestCase
  def setup
    @str = 'acb&who(vcpj83~:\--40t3qjf'
    @fg = FreeGroup.new(@str)
  end
#---

  must "initializing right with a string argument" do
    assert_equal @str[0], @fg.generators[@str[0].to_sym].to_c
    assert_equal @str[0].upcase, @fg.generators[@str[0].to_sym].inverse.to_c
  end

  must "build the trivial group with argument 1" do
    assert_equal [:"1"], FreeGroup.new('1').generators.keys
  end

  must "raise an exception when no arguments given" do
    assert_raises(ArgumentError){FreeGroup.new}
  end

  must "raise an exception when a wrong argument given" do
    assert_raises(FreeGroup::InvalidArgument){FreeGroup.new('&%#25)(*+;@]')}
  end

  must "alph method return the alphabet of the group" do
    assert_equal @str.gsub(/[^a-zA-Z]/,'').downcase.split('').uniq.sort, 
    @fg.alphabet
  end

end
#----------

#End of File
