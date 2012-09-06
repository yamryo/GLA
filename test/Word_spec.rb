#
# Word_spec.rb
#
# Time-stamp: <2012-09-07 01:58:14 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('Word.rb')
#--------------------------------------------------
describe Word, "when initializing" do
  context "with a string of alphabet and '1'" do
    it { Word.new('xaybzc').should == 'xaybzc' }
    it { %w[a A x aA].each{ |c| Word.new(c).should == c} }
    it { Word.new('1').should == '1' }
  end
#
  context "without arguments" do
    it "should raise error" do
      expect{ Word.new }.to raise_error
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
    it "should raise Word::InvalidArgument error" do
      ['0', '2', '00', '28302370', '&;/:;*+][', '*3]0:[2+8;'].each do |str|
        expect{ Word.new(str) }.to raise_error(Word::InvalidArgument)
      end
    end
  end
#
  context "with a non-String argument" do
    it "should raise Word::InvalidArgument error" do
      [1, 0.238, [1,1,1], 5..10].each do |non_str|
        expect{ Word.new(non_str) }.to raise_error(Word::InvalidArgument)
      end
    end
  end
#
end
#------------------------

#------------------------
describe Word, "#show" do
  before { @mwd = Word.new('aioStwfmXb')}
  subject { @mwd.show }
  it { should == {:value => @mwd, :obj_id => @mwd.object_id} }
end
#------------------------

#------------------------
describe Word, "#==" do
  before { @mwrd = Word.new('aBAa') }
  context "comparing a Word with itself" do
    subject { @mwrd == @mwrd}
    it { should be_true}
  end
#
  context "comparing a Word with itself contracted" do
    subject { @mwrd == Word.new('aB') }
    it { should be_false}
  end
#    
  context "comparing a Word with a String" do
    subject { @mwrd == 'aBAa' }
    it { should be_true }
  end
#    
end
#------------------------

#------------------------
describe Word, "#replace" do
  before :all do
    @mwrd = Word.new('abC') 
    @id = @mwrd.show[:obj_id]
    @mstr = 'xoIeRs'
  end
#
  context "with a String in alphabets" do
    subject { @mwrd.replace(@mstr) }
    it { should eq @mstr }
    it "should keep the obj_id" do
      @mwrd.show[:obj_id].should == @id
    end
  end
#
  context "with a general Stirng" do
    subject { @mwrd.replace('xo#Ie/9Rs_+:') }
    it { should eq @mstr }
    it "should keep the obj_id" do
      @mwrd.show[:obj_id].should == @id
    end
  end
#
  context "with another Word" do
    subject { @mwrd.replace(Word.new(@mstr)) }
    it { should eq @mstr }
    it "should keep the obj_id" do
      @mwrd.show[:obj_id].should == @id
    end
  end
#
  context "with neither a Word nor a String" do    
    it { expect{ @mwrd.replace(1) }.to raise_error(Word::InvalidArgument) }
  end
#
end
#------------------------

#------------------------
describe Word, "#contract" do
  before(:all){ }
#
  context "in a normal action" do
#    "should make the same word in the shortest expression"
    it { Word.new('aBAa').contract.should == 'aB' }
    it { Word.new('aBsAaSkKb').contract.should == 'a' }
  end
#
  context "for a product of a word with its inverse" do
    before  { @myw = Word.new('aBcdE') }
    subject { (@myw*@myw.invert).contract }
    it { should == '1' }
  end
#
end
#------------------------

#------------------------ 
describe Word, "#===" do
  subject { Word.new('aBc') === Word.new('aBsSc') }
  it { should be_true }
end
#------------------------

#------------------------
describe Word, "#product" do
  before :all do
    @mwd = Word.new('aBc')
  end
 #
  context "with the identity" do
    it "should be the original Word 'aBc'" do
      (@mwd*Word.new('1')).should eq @mwd 
      (Word.new('1')*@mwd).should eq @mwd 
    end
  end
 #
  context "with another normal Word 'xYz'" do
    subject { @mwd*Word.new('xYz')}
    it { should eq 'aBcxYz'}
  end
 #
  context "with the inverse" do
    subject { @mwd*@mwd.invert}
    it { should eq 'aBcCbA'}
  end
 #
end
#------------------------

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
