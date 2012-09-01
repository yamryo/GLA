#
# test_Term.rb
#
# Time-stamp: <2012-04-20 14:13:41 (ryosuke)>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)

require('rubygems')
require('test/unit')
require('test_unit_extensions')
require('Term.rb')

class TermClassTest < Test::Unit::TestCase
  def setup
    @term = Term.new('a',1)
  end
#---
  must "initialize with a string argument" do
    assert_equal 'a', @term.to_s
    assert_equal 1, @term.coeff
  end

  must "initialize with ignoring non-alphabet letters" do
    ['(abc)', 'a0b2c3', '-abc', 'a?bc'].each do |str|
      @term = Term.new(str, 1)
      assert_equal 'abc', @term.to_s
      assert_equal 1, @term.coeff
    end
  end
#    
  must "initialize without a coefficient" do
      @term = Term.new('abc')
      assert_equal 'abc', @term.to_s
      assert @term.coeff == 1
  end
#    
  must "not contract a given word" do
      assert_equal 'ab1c', Term.new('ab1c').to_s
      assert_equal '11', Term.new('11').to_s
      assert_equal 'aA', Term.new('aA').to_s
      assert_equal 'aA11', Term.new('aA11').to_s
  end
#    
  must "initialize with negative coefficient" do
    assert_equal '-a', Term.new('a', -1).to_s
  end
#    
  must "initialize with coefficient zero" do
    ['a', '1', 'abc', 'aBc0', '-abc', '+a?bc'].each do |str|
      @term = Term.new(str, 0)
      assert_equal '0', @term.to_s
    end
   end
#    
  must "raise an error when Fixnum 1 is given as word" do
    assert_raises(ArgumentError){ @term = Term.new(1, 1) }
  end
#
  must "raise an error when a string is given as coefficient" do
    assert_raises(ArgumentError){ @term = Term.new('abc', 'a') }
  end
#    
  must "compare two terms right" do
    assert @term == Term.new('a',1)
    assert !(@term == Term.new('a',2))
  end
#    
  must "compare words only" do
    assert @term =~ Term.new('a', 9)
    assert !(@term =~ Term.new('b',2))
   end
#    
  must "product two terms right" do
    assert_equal "-2ab", (@term*Term.new('b',-2)).to_s
    assert_equal "-aA", (@term*Term.new('A',-1)).to_s
    assert_equal "0", (@term*Term.new('b', 0)).to_s
    assert_equal "a", (@term*Term.new('1', 1)).to_s
    assert_equal "3a", (Term.new('1', 3)*@term).to_s
    assert_equal "10abc", (Term.new('a', 2)*Term.new('bc',5)).to_s
  end
#    
  must "return sign of terms right" do
    t = Term.new('Abc', 5)
    assert_equal "+,-,true,false", [t.sign, (t*Term.new('a', -1)).sign, t.positive?, t.negative?].join(',')
  end
#    
  must "allow a scaler multiplication" do
    assert_equal "8a", (@term*8).to_s
    assert_equal "0", (@term*0).to_s
  end
#    
  must "be multiplied by a negative number" do
    assert_equal "-5a", (@term*(-5)).to_s
  end
#    
  must "contract right" do
    t = @term*Term.new('bBc', -3)
    assert_equal "-3ac", t.contract.to_s
    assert_equal "12", (t*Term.new('CA', -4)).contract.to_s
  end
#    
  must "count the degree of term" do
    assert_equal 3, Term.new('Abc', -4).degree
    assert_equal 2, Term.new('AbcC', -4).degree
    assert_equal 0, Term.new('aA', -4).degree
  end
#    
end
#----------
#End of File
