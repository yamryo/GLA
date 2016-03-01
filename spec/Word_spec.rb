#
# GLA/test/Word_spec.rb
#
# Time-stamp: <2016-03-01 11:29:04 (kaigishitsu)>
require('spec_helper')

require('Word.rb')

describe Word do
  #--------------------------------------------------
  describe "when initializing" do
    let(:myword) { Word.new(mystr) }
    #--------------------------------------------------
    context "raises no error" do
      subject { myword }
      #-----
      shared_examples "is eq to the argument" do
        it { is_expected.to eq mystr }
      end
      #-----
      context "with a string of alphabet" do
        %w[a A x aA xaybzc].each do |c|
          let(:mystr) { c }
          it_behaves_like "is eq to the argument"
        end
      end
      #-----
      context "with the empty word '1'" do
        let(:mystr) { '1' }
        it_behaves_like "is eq to the argument"
      end
      #-----
      context "with a String including non-alphabet letters" do
        let(:mystr) { 'Al&p(hab]e$tO8nl0y/' }
        it "excludes non-alphabets" do
          is_expected.to eq 'AlphabetOnly'
        end
      end
      #-----
    end
    #--------------------------------------------------
    context "raises error" do
      subject { lambda { myword } }
      #-----
      context "without arguments" do
        it { expect{ Word.new }.to raise_error(ArgumentError) }
      end
      #-----
      shared_examples "Raise Word::InvalidArgument" do
        it { is_expected.to raise_error(Word::InvalidArgument) }
      end
      #-----
      context "with the null word" do
        let(:mystr) { '' }
        it { is_expected.to raise_error(Word::InvalidArgument) }
      end
      #-----
      context "with a String consisting of non-alphabet letters" do
        data = ['0', '2', '00', '28302370', '&;/:;*+][', '*3]0:[2+8;']
        data.each do |str|
          let(:mystr) { str }
          it_behaves_like "Raise Word::InvalidArgument"
        end
      end
      #-----
      context "with a non-String argument" do
        data = [1, 0.238, [1,1,1], 5..10]
        data.each do |nonstr|
          let(:mystr) { nonstr }
          it_behaves_like "Raise Word::InvalidArgument"
        end
      end
    end
  end
#------------------------

#------------------------
describe "#show" do
  before { @mwd = Word.new('aioStwfmXb')}
  subject { @mwd.show }
  it { is_expected.to include(:value => @mwd, :obj_id => @mwd.object_id) }
end
#------------------------

#------------------------
  describe "#gen_at" do
    before { @mwd = Word.new('aioStwfmXb') }
    #
    context "with an Integer <= self.length" do
      it "starts from 0" do
        #expect{ @mwd[0] }.not_to raise_error
        expect{ @mwd.gen_at(0) }.not_to raise_error
      end
      it { expect(@mwd.gen_at(3)).to be_kind_of Generator }
      it { expect(@mwd.gen_at(3).to_char).to eq @mwd[3] }
    end
    context "with an Integer > self.length" do
      it { expect{ @mwd.gen_at(@mwd.length) }.to raise_error }
    end
    context "with a negative Integer" do
      it { expect( @mwd.gen_at(-3).to_char ).to eq @mwd[@mwd.length-3] }
    end
    #
    context "with the word 1" do
      it{ expect( Word.new('1').gen_at(0) ).to eq Generator.new('1') }
    end
    #
  end
#------------------------

#------------------------
describe "comparisons" do
  before { @mwrd = Word.new('aBAa') }
#
  context "==, comparing as Strings," do
#
    context "comparing a Word to itself" do
      subject { @mwrd == @mwrd}
      it { is_expected.to be true }
    end
#
    context "comparing a Word to itself contracted" do
      subject { @mwrd == @mwrd.dup.contract }
      it { is_expected.to be false}
    end
#
    context "comparing a Word with a String" do
      subject { @mwrd == 'aBAa' }
      it { is_expected.to be true }
    end
#
  end
#
  context "===, comparing with contraction," do
    subject { @mwrd === @mwrd.dup.contract }
    it { is_expected.to be true }
  end
#
end
#------------------------

#------------------------
describe "#replace" do
  before :all do
    @mwrd = Word.new('abC')
    @id = @mwrd.show[:obj_id]
    @mstr = 'xoIeRs'
  end
#
  context "with a String in alphabets" do
    subject { @mwrd.replace(@mstr) }
    it { is_expected.to eq @mstr }
    it "keeps the obj_id" do
      expect(@mwrd.show[:obj_id]).to eq @id
    end
  end
#
  context "with a general Stirng" do
    subject { @mwrd.replace('xo#Ie/9Rs_+:') }
    it { is_expected.to eq @mstr }
    it "should keep the obj_id" do
      expect(@mwrd.show[:obj_id]).to be @id
    end
  end
#
  context "with another Word" do
    subject { @mwrd.replace(Word.new(@mstr)) }
    it { is_expected.to eq @mstr }
    it "should keep the obj_id" do
      expect(@mwrd.show[:obj_id]).to eq @id
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
describe "#contract" do
  before(:all){ }
#
  context "in a normal action" do
#    "makes the same word in the shortest expression"
    it { expect(Word.new('aBAa').contract).to eq 'aB' }
    it { expect(Word.new('aBsAaSkKb').contract).to eq 'a' }
  end
#
  context "for a product of a word with its inverse" do
    before  { @myw = Word.new('aBcdE') }
    subject { (@myw*@myw.invert).contract }
    it { is_expected.to eq Word::Identity }
  end
#
end
#------------------------

#------------------------
describe "#product" do
  before :all do
    @mwd = Word.new('aBc')
  end
 #
  context "with the identity" do
    it "is the original Word 'aBc'" do
      expect(@mwd*Word.new(Word::Identity)).to eq @mwd
      expect(Word.new(Word::Identity)*@mwd).to eq @mwd
    end
  end
 #
  context "with another normal Word 'xYz'" do
    subject { @mwd*Word.new('xYz')}
    it { is_expected.to eq 'aBcxYz'}
  end
 #
  context "with a String" do
    it { expect(@mwd*'UvW').to eq 'aBcUvW'}
    it "is an instance of Word class" do
      expect(@mwd*'UvW').to be_a_kind_of Word
      end
    end
#
  context "with a Generator" do
      subject{ @mwd*Generator.new('g') }
      it { is_expected.to eq 'aBcg' and be_a_kind_of Word }
    end
#
  context "with the inverse" do
    subject { @mwd*@mwd.invert}
    it { is_expected.to eq 'aBcCbA'}
  end
 #
end
#------------------------

#------------------------
describe "#invert" do
  context "of a normal Word 'abCd'" do
    subject { Word.new('abCd').invert }
    it { is_expected.to eq 'DcBA' }
  end
#
  context "of a Word of a single letter 'a'" do
    subject { Word.new('a').invert }
    it { is_expected.to eq 'A' }
  end
#
  context "of the identity" do
    subject { Word.new(Word::Identity).invert }
    it { is_expected.to eq Word::Identity }
  end
#
end
#------------------------

#------------------------
describe "#^ (power)" do
  before { @mwd = Word.new('bWd') }
  context "with a natural number" do
    subject { @mwd^3 }
    it { is_expected.to eq 'bWdbWdbWd' }
  end
#
  context "with zero" do
    it "is the identity" do
     ['a', 'A', '1', 'ab', 'abC'].each do |str|
        expect(@mwd.replace(str)^0).to eq Word::Identity
      end
    end
#
  end
end
#------------------------

#------------------------
describe "#conjugate" do
  before :all do
    @word = Word.new('a')
    @another = Word.new('b')
  end
#
  context "of 'a' with 'b'" do
    subject { @word.conj(@another) }
    it { is_expected.to eq 'Bab' }
  end
#
  context "of @word='aBcde' with @another='dgKy'" do
    subject { (@word.replace('aBcde')).conj(@another.replace('dgKy')) }
    it { is_expected.to eq 'YkGDaBcdedgKy' }
    it "is equal to (@another.invert)*@word*@another" do
      is_expected.to eq (@another.invert)*@word*@another
    end
  end
#
end
#------------------------

#------------------------
describe "generated in a random manner" do
  before do
    @alph = ('a'..'z').to_a + ('A'..'Z').to_a + ['1']
  end
#
  it "raises no error in any method" do
    10.times do |i|
      @mstr = ''
      20.times{ |k| @mstr += @alph[rand(@alph.size)] }
      random_word = Word.new(@mstr)
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

end
#--------------------------------------------------
# End of File
#--------------------------------------------------
