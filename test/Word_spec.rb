#
# Word_spec.rb
#
# Time-stamp: <2012-09-07 17:51:19 (ryosuke)>
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
    it { expect{ Word.new }.to raise_error }
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
  context "with a String 'UvW'" do
    it { (@mwd*'UvW').should eq 'aBcUvW'}
    it "should be an instance of Word class" do
      (@mwd*'UvW').kind_of?(Word).should be_true
    end
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
describe Word, "#invert" do  
  context "of a normal Word 'abCd'" do
    subject { Word.new('abCd').invert }
    it { should ==  'DcBA' }
  end
#
  context "of a Word of a single letter 'a'" do
    subject { Word.new('a').invert }
    it { should ==  'A' }
  end
#
  context "of the identity" do
    subject { Word.new('1').invert }
    it { should ==  '1' }
  end
#
end
#------------------------

#------------------------
describe Word, "#^ (power)" do
  before { @mwd = Word.new('bWd') }
  context "with a natural number" do
    subject { @mwd^3 }
    it { should == 'bWdbWdbWd' }
  end
#
  context "with zero" do
    it "should be '1'" do
     ['a', 'A', '1', 'ab', 'abC'].each do |str|
        (@mwd.replace(str)^0).should == '1'
      end
    end
#
  end
end
#------------------------

#------------------------
describe Word, "#conjugate" do
  before :all do
    @word = Word.new('a')
    @another = Word.new('b')
  end
#
  context "of 'a' with 'b'" do
    subject { @word.conj(@another) }
    it { should == 'Bab' }
  end
#
  context "of @word='aBcde' with @another='dgKy'" do
    subject { (@word.replace('aBcde')).conj(@another.replace('dgKy')) }
    it { should == 'YkGDaBcdedgKy' }
    it "should be equal to (@another.invert)*@word*@another" do
      should ==  (@another.invert)*@word*@another 
    end
  end
#
end
#------------------------

#------------------------
describe Word, "generated in a random manner" do
  before do
    @alph = ('a'..'z').to_a + ('A'..'Z').to_a + ['1']
  end
#
  it "should raise no error in any method" do
    10.times do |i|
      @mstr = ''
      20.times{ |k| @mstr += @alph[rand(@alph.size)] }
      random_word = Word.new(@mstr)
#      p random_word
      (expect do
        random_word.to_s
        random_word.invert
        random_word.replace('qoeEoKlrjfij')
        random_word^5
        random_word.contract
        random_word*random_word
        random_word*(Word.new('abcde'))
        (random_word*random_word.invert).contract
      end).not_to raise_error
    end
  end
end
#--------------------------------------------------
# End of File
#--------------------------------------------------
