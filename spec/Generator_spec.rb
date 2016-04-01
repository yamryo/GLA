#
# GLA/test/Generator_spec.rb
#
# Time-stamp: <2016-04-01 17:28:02 (ryosuke)>
require('spec_helper')

require('Generator')

describe Generator do
  let(:gen) { Generator.new(letter) }
  let(:identity) { Generator.new() }
  #---------------------------------------
  describe "#initialize" do
    let(:letter) { 'g' }
    context "with a single letter" do
      it{ expect(gen.letter).to eq letter }
      it{ expect(gen.inverse?).to be_falsy }
    end
    #
    context "with bad letters '&','2' and ' '(space)" do
      ['&','2',' '].each do |c|
        it { expect{ Generator.new(c) }.to raise_error(Generator::InvalidLetter) }
      end
    end
    #
    context "with no argument" do
      subject { identity.to_char }
      it{ is_expected.to eq '1' }
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "comparisons" do
    let(:gen_1) { gen.dup }
    let(:gen_2) { gen.dup.invert! }
    let(:gen_3) { Generator.new(letter2) }
    #
    context "=~, the lax conparing," do
      let(:letter) { 'g' }
      let(:letter2) { 's' }
      it "should return true iff the letters coinside" do
        expect(gen =~ gen_1).to be_truthy
        expect(gen =~ gen_2).to be_truthy
        expect(gen =~ gen_3).to be_falsy
      end
    end
    #
    context "==, the normal comparing," do
      let(:letter) { 'g' }
      let(:letter2) { 's' }
      it "should return true iff the letters and inverseness coinside" do
        expect(gen == gen_1).to be_truthy
        expect(gen == gen_2).to be_falsy
        expect(gen == gen_3).to be_falsy
      end
    end
    #
    context "===, the strict comparing," do
      let(:letter) { 'g' }
      let(:letter2) { 's' }
      it "should return true iff the two objects exactly the same instance" do
        expect(gen === gen_1).to be_falsy
        expect(gen === gen_2).to be_falsy
        expect(gen === gen_3).to be_falsy
      end
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "#inverse?" do
    context 'for a downcase letter' do
      let(:letter) { 'a' }
      subject{ gen }
      it{ is_expected.not_to be_inverse }
    end
    #
    context 'for a downcase letter' do
      let(:letter) { 'A' }
      subject{ gen }
      it{ is_expected.to be_inverse }
    end
    #
    context 'for a downcase letter' do
      subject{ identity }
      it{ is_expected.not_to be_inverse }
    end
  end
  #---------------------------------------

  #---------------------------------------
  describe "#invert!" do
    let(:letter) { 'g' }
    context "with no arguments" do
      it "should change inverseness of a normal Generator" do
        expect{ gen.invert! }.to change{ gen.inverse? }.from(false).to(true)
      end
      #
      it { expect(gen.invert!.to_char).to match /[A-Z]/ }
      #
      it "should not change inverseness of '1'" do
        expect{ identity.invert! }.not_to change{ identity }
      end
    end
    #
    context "with an even integer" do
      it "should not change inverseness" do
        expect{ gen.invert!( 2*[*1..20].sample ) }.not_to change{ gen.inverse? }
      end
    end
    #
    context "with an odd integer" do
      it "should change inverseness" do
        expect{ gen.invert!( 2*[*1..20].sample - 1 ) }.to change{ gen.inverse? }
      end
    end
  end
  #---------------------------------------

  #---------------------------------------
  describe "#* (product!)" do
    let(:letter) { 'g' }
    #---
    context "of two normal Generators" do
      let(:another) { Generator.new('S')}
      it { expect(gen*another).to eq [gen, another]}
    end
    #
    context "of a Genarator 'g' and the identity '1'" do
      it { expect(gen*identity).to eq gen }
      it { expect(identity*gen).to eq gen }
    end
    #
  end
  #---------------------------------------

end
#End of File
