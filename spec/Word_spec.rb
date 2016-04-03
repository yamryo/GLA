#
# GLA/test/Word_spec.rb
#
# Time-stamp: <2016-04-03 21:48:24 (ryosuke)>
require('spec_helper')

require('Word.rb')

describe Word do
  #--------------------------------------------------
  describe "Constants" do
    context "Identity" do
      subject { Word::Identity }
      it { is_expected.to eq Word.new('1') }
      it { is_expected.to be_kind_of Word }
    end
  end
  #--------------------------------------------------
  describe "Errors" do
    context "InvalidArgument" do
      subject { Word::InvalidArgument.to_s }
      it { is_expected.to eq 'Word::InvalidArgument' }
    end
  end
  #------------------------
  let(:myword) { Word.new(mystr) }
  #------------------------
  describe "when initializing" do
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
      context "with the letter '1'" do
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
    #------------------------
    context "raises error" do
      shared_examples "Raise Word::InvalidArgument" do |ms|
        let(:mystr) { ms }
        it { is_expected.to raise_error(Word::InvalidArgument) }
      end
      subject { lambda { myword } }
      #-----
      xcontext "without arguments" do
        subject { Word.new }
        it_behaves_like "Raise Word::InvalidArgument"
      end
      context "with nil" do
        it_behaves_like "Raise Word::InvalidArgument", nil
      end
      context "with the empty string" do
        it_behaves_like "Raise Word::InvalidArgument", ''
      end
      context "with a String consisting of non-alphabet letters" do
        data = ['0', '2', '00', '28302370', '&;/:;*+][', '*3]0:[2+8;']
        data.each do |wrong_str|
          it_behaves_like "Raise Word::InvalidArgument", wrong_str
        end
      end
      context "with a non-String argument" do
        data = [1, 0.238, [1,1,1], 5..10]
        data.each do |nonstr|
          it_behaves_like "Raise Word::InvalidArgument", nonstr
        end
      end
    end
  end
  #------------------------

  #------------------------
  describe "#show" do
    let(:mystr) { 'aioStwfmXb' }
    subject { myword.show }
    it { is_expected.to include(:value => myword, :obj_id => myword.object_id) }
  end
  #------------------------

  #------------------------
  describe "#gen_at" do
    let(:mystr) { 'aioStwfmXb' }
    #
    context "an Integer less than self.length" do
      it "does'nt raise any Exception" do
        expect{ myword.gen_at(0) }.not_to raise_error
        expect{ myword.gen_at(myword.length-1) }.not_to raise_error
      end
      it "return the Generator corresponding with the index in the given word" do
        expect( myword.gen_at(3) ).to be_kind_of Generator
        expect( myword.gen_at(3).to_char ).to eq mystr[3]
      end
    end
    context "an Integer greater than or equal to self.length" do
      it do
        expect{ myword.gen_at(myword.length) }.to raise_error(Word::InvalidArgument)
        expect{ myword.gen_at(myword.length+1) }.to raise_error(Word::InvalidArgument)
      end
    end
    context "a negative Integer" do
      subject { myword.gen_at(-3) }
      it "does not raise any exception" do
        expect{ lambda{ subject } }.not_to raise_error
        is_expected.to eq Generator.new(myword[myword.length-3])
      end
    end
    context "0 of the word 1" do
      subject { Word.new('1').gen_at(0) }
      it{ is_expected.to eq Generator.new('1') }
    end
    #
  end
  #------------------------

  #------------------------
  describe "comparisons" do
    let(:mystr) { 'aBAa' }
    #------------------------
    context "==, comparing as Strings," do
      #
      context "comparing a Word to itself" do
        subject { myword == myword}
        it { is_expected.to be true }
      end
      context "comparing a Word to itself contracted" do
        subject { myword == myword.dup.contract }
        it { is_expected.to be false}
      end
      context "comparing a Word with a String" do
        subject { myword == 'aBAa' }
        it { is_expected.to be true }
      end
    end
    #------------------------
    context "===, comparing with contraction," do
      subject { myword === myword.dup.contract }
      it { is_expected.to be true }
    end
  end
  #------------------------

  #------------------------
  describe "#replace" do
    let(:mystr) {'abC'}
    let(:repstr) {'xoIeRs'}
    shared_examples "replace its content while keeping its obj_id" do
      it { is_expected.to eq repstr }
      it { expect{ lambda { subject } }.not_to change{ subject.show[:obj_id] } }
    end
    #-----
    context "with a String in alphabets" do
       subject { myword.replace(repstr) }
       it_behaves_like "replace its content while keeping its obj_id"
    end
    context "with a Stirng in ascii" do
      subject { myword.replace('xo#Ie/9Rs_+:') }
      it_behaves_like "replace its content while keeping its obj_id"
    end
    context "with another Word" do
      subject { myword.replace(Word.new(repstr)) }
      it_behaves_like "replace its content while keeping its obj_id"
    end
    #-----
    context "with neither a Word nor a String" do
      subject { lambda { myword.replace(1) } }
      it { is_expected.to raise_error(Word::InvalidArgument) }
    end
  end
#------------------------

#------------------------
describe "#contract" do
  context "in a normal action" do
    context "makes the given word to be the shortest expression" do
      %w[aBAa akTcCtKB kTcCtKaBsAaSkKbB].each do |empty|
        let(:mystr) { empty }
        subject { myword.contract }
        it { is_expected.to eq 'aB' }
      end
    end
  end
#
  context "for a product of a word with its inverse" do
    let(:mystr) { 'aBcdE' }
    subject { (myword*myword.invert).contract }
    it { is_expected.to eq Word::Identity }
  end
#
end
#------------------------

#------------------------
describe "#product" do
  let(:mystr) { 'aBc' }
 #
  context "with the identity" do
    it "is the original Word 'aBc'" do
      expect(myword*Word::Identity).to eq myword
      expect(Word::Identity*myword).to eq myword
    end
  end
 #
  context "with another normal Word 'xYz'" do
    subject { myword*Word.new('xYz')}
    it { is_expected.to eq 'aBcxYz'}
  end
 #
  context "with a String" do
    it { expect(myword*'UvW').to eq 'aBcUvW'}
    it "is an instance of Word class" do
      expect(myword*'UvW').to be_a_kind_of Word
      end
    end
#
  context "with a Generator" do
      subject{ myword*Generator.new('g') }
      it { is_expected.to eq 'aBcg' and be_a_kind_of Word }
    end
#
  context "with the inverse" do
    subject { myword*myword.invert}
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
    subject { Word::Identity.invert }
    it { is_expected.to eq Word::Identity }
  end
#
end
#------------------------

#------------------------
describe "#^ (power)" do
  let(:mystr) { 'bWd' }
  context "with a natural number" do
    subject { myword^3 }
    it { is_expected.to eq 'bWdbWdbWd' }
  end
#
  context "with zero" do
    it "is the identity" do
     ['a', 'A', '1', 'ab', 'abC'].each do |str|
        expect(myword.replace(str)^0).to eq Word::Identity
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
