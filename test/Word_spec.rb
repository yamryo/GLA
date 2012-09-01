#
# test_Word.rb
#
# Time-stamp: <2012-09-01 14:08:06 (ryosuke)>
#

src_path = Dir.pwd + '/../src'
$:.unshift(src_path)

require('Word.rb')

describe Word, "when initializing" do
  before(:all) do
    @mstr = 'xaybzc'
    @word = Word.new(@mstr)
  end
#
  it "should be right" do
    @word.should == @mstr
    %w[a A x 1 aA].each{ |c| Word.new(c).should == c}
    # assert_equal %w[a b c x y z], @word.G.alphabet
   end
#
  it "should raise error if no arguments" do
    expect{ Word.new }.to raise_error
  end
#
  it "should consist of alphabet only" do
    Word.new('This&is(a]Test$8String0/').should == 'ThisisaTestString'
   end
#
  it "should ignore letters which are not alphabet" do
    Word.new('aBA3$#e0-c:').should == 'aBAec'
  end
#
end 

#   must "raise an error when a string without alphabet given" do
#     ['0', '2', '00', '28302370', '&;/:;*+]['].each do |str| 
#       assert_raises(Word::InvalidArgument){Word.new(str)}
#     end
#   end

#   must "show information in hash table style" do
#     assert_equal Hash, @word.show.class 
#     assert_equal [:value, :obj_id], @word.show.keys 
#   end

#   must "replace word's content right" do
#     id = @word.show[:obj_id]
#      ['aBA3', 'aB#&/A', 'a?BA^', ':++aBA'].each do |str|
#       @word.replace(str)
#       assert_equal 'aBA', @word
#       assert_equal id, @word.show[:obj_id]
#      end
#    end
    
#   must "compare words right without contraction" do
#     mword = Word.new('aBAa')
#     assert_equal false, @word == mword
#     assert_equal true, @word.replace('aBAa') == mword
#    end
    
#   must "contract right" do
#     @word.replace('aBAa')
#     assert_equal 'aB', @word.contract
#   end
# #    
#   must "be 1 when contract the product of a word with its inverse" do
#     @word.replace('aBcdE')
#     assert_equal '1', (@word.invert*@word).contract
#   end
# #    
#   must "compare with contraction rightly" do
#     @word.replace('aBc')
#     assert_equal true, @word === Word.new('aBsSc')
#    end
# #    
#   must "product words right" do
#     @word.replace('aBc')
#     assert_equal 'aBcxYz', @word*Word.new('xYz')
#     assert_equal 'aBc', @word*Word.new('1')
#     assert_equal 'aBc', Word.new('1')*@word
#     assert_equal 'aBcCbA', @word*@word.invert
#   end
# #    
#   must "allow to take product with string" do
#     @word.replace('aBc')
#     assert_equal 'aBcxYz', @word*'xYz'
#     assert_kind_of Word, @word*'xYz'
# #    assert_equal 'z', (@word*'xYz').G.generators[:z].to_c
#   end
# #    
#   must "inverse a word right" do
#     @word.replace('abCd')
#     assert_equal 'DcBA', @word.invert
#   end
# #    
#   must "get nth power of a word" do
#     @word.replace('abC')
#     assert_equal 'abCabCabC', @word^3
#   end
# #    
#   must "get 1 when word is powered by zero" do
#     ['a', 'A', '1', 'ab', 'abC'].each do |str|
#       assert_equal '1', @word.replace(str)^0
#     end
#   end
# #    
#  must "take a conjugate of word" do
#     @word.replace('a')
#     other = Word.new('b')
#     assert_equal 'Bab', @word.conj(other)

#     @word.replace('aBcde')
#     other = Word.new('dgKy')
#     assert_equal 'YkGDaBcdedgKy', @word.conj(other)
#     assert_equal (other.invert)*@word*other, @word.conj(other)
#   end
# #    
#   must "act rightly with random words" do
#     mstr = ''
#     alph = ('a'..'z').to_a.concat(('A'..'Z').to_a) 
#     20.times{ |k| mstr += alph[rand(alph.size)] }

#     assert_nothing_raised do
#       @word.replace(mstr)
#       @word.to_s
#       @word.invert
#       @word.contract
#       @word*@word
#       @word*Word.new('abcde')
#       (@word*@word.invert).contract
#     end
#   end
# #   
#----------

#End of File
