#
# Word_spec.rb
#
# Time-stamp: <2012-09-06 21:00:03 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('Word.rb')
#--------------------------------------------------
describe Word, "when initializing" do
  before(:all) do
    @mstr = 'xaybzc'
    @word = Word.new(@mstr)
  end
#
  context "with a string of alphabet and '1'" do
    it { Word.new('xaybzc').should == 'xaybzc' }
    it { %w[a A x aA].each{ |c| Word.new(c).should == c} }
    it { Word.new('1').should == '1' } 
  end
#
  context "without arguments" do
    it "should raise error" do
      expect{ Word.new }.to raise_error(Word::InvalidArgument)
    end
  end
#
  context "with a string including non-alphabet letters" do
    it "should exclude non-alphabets" do
      Word.new('Al&p(hab]e$tO8nl0y/').should == 'AlphabetOnly'
    end
  end
#
  context "with a string consisting of non-alphabet letters" do
    it "should raise error" do
      ['0', '2', '00', '28302370', '&;/:;*+]['].each do |str| 
        expect{ Word.new(str) }.to raise_error(Word::InvalidArgument)
      end
    end
  end
#
end 
#------------------------    
describe Word, "#show" do
  it "should show information in hash table style" do
    info = Word.new('aioStwfmXb').show
    info.class.name.should == 'Hash'
    info.keys.should == [:value, :obj_id]
  end
#
end
#------------------------    
describe Word, "#==" do
  it "should compare words without contraction" do
    mwrd = Word.new('aBAa')
    (mwrd == Word.new('aB')).should be_false 
    (mwrd == Word.new('a3B-+A_a')).should be_true
  end
end
    
describe Word, "#replace" do
  it "should replace word's content to given string" do
    mwrd = Word.new('abC')
    id = mwrd.show[:obj_id]
    ['aBA3', 'aB#&/A', 'a?BA^', ':++aBA'].each do |str|
      mwrd.replace(str)
      mwrd.should == 'aBA' 
      mwrd.show[:obj_id].should == id
     end
   end
#
end    
#------------------------    
describe Word, "#contract" do
  before(:all) do
    @myw = Word.new('a')
  end
#
  it "should make a word the shortest express" do
    @myw.replace('aBAa').contract.should == 'aB' 
    @myw.replace('aBsAaSkKb').contract.should == 'a'
  end
#    
  it "should contract a product of a word with its inverse into 1" do
    (@myw*(@myw.replace('aBcdE').invert)).contract.should == '1' 
  end
#    
end
#------------------------    
describe Word, "#===" do
  it "should compare words after contraction" do
    (Word.new('aBc') === Word.new('aBsSc')).should be_true
  end
end
#------------------------    
# describe Word, "#product" do
#    before :all do
#      @mwd = Word.new('aBc')
#    end
#  #
#    context "with another normal Word" do
#      subject { @mwd*Word.new('xYz')}
#      it { should eq 'aBcxYz'}
#    end
#  #    
#    context "with the inverse" do
#      subject { @mwd*@mwd.invert} 
#      it { should eq 'aBcCbA'}
#    end
#  #
#    context "with the identity" do
#      it { @mwd*Word.new('1').should eq @mwd }
#      it { Word.new('1')*@mwd.should eq @mwd }
#    end
#  #
#end
#------------------------    
# #    
# #   must "allow to take product with string" do
# #     @word.replace('aBc')
# #     assert_equal 'aBcxYz', @word*'xYz'
# #     assert_kind_of Word, @word*'xYz'
# # #    assert_equal 'z', (@word*'xYz').G.generators[:z].to_c
# #   end
# #end
# #--------------------------------------------------
# # #    
# #   must "inverse a word right" do
# #     @word.replace('abCd')
# #     assert_equal 'DcBA', @word.invert
# #   end
# # #    
# #   must "get nth power of a word" do
# #     @word.replace('abC')
# #     assert_equal 'abCabCabC', @word^3
# #   end
# # #    
# #   must "get 1 when word is powered by zero" do
# #     ['a', 'A', '1', 'ab', 'abC'].each do |str|
# #       assert_equal '1', @word.replace(str)^0
# #     end
# #   end
# # #    
# #  must "take a conjugate of word" do
# #     @word.replace('a')
# #     other = Word.new('b')
# #     assert_equal 'Bab', @word.conj(other)
# 
# #     @word.replace('aBcde')
# #     other = Word.new('dgKy')
# #     assert_equal 'YkGDaBcdedgKy', @word.conj(other)
# #     assert_equal (other.invert)*@word*other, @word.conj(other)
# #   end
# # #    
# #   must "act rightly with random words" do
# #     mstr = ''
# #     alph = ('a'..'z').to_a.concat(('A'..'Z').to_a) 
# #     20.times{ |k| mstr += alph[rand(alph.size)] }
# 
# #     assert_nothing_raised do
# #       @word.replace(mstr)
# #       @word.to_s
# #       @word.invert
# #       @word.contract
# #       @word*@word
# #       @word*Word.new('abcde')
# #       (@word*@word.invert).contract
# #     end
# #   end
# # #   
# #----------

#--------------------------------------------------
# End of File
#--------------------------------------------------
