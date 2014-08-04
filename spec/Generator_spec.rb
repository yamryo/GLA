#
# GLA/test/Generator_spec.rb
#
# Time-stamp: <2014-08-04 15:56:28 (ryosuke)>
require('spec_helper')

require('Generator')

describe Generator do
  #
  before :all do
    @gen = Generator.new('g')
    @identity = Generator.new
  end
  #---------------------------------------
  describe "#initialize" do
    context "with a single letter 'g'" do
      it{ expect(@gen.letter).to eq 'g' }
      it{ expect(@gen.inverse?).to be false }
    end
    #
    context "with bad letters '&','2' and ' '(space)" do
      ['&','2',' '].each do |c|
        it { expect{ Generator.new(c) }.to raise_error(Generator::InvalidLetter) }
      end
    end
    #
    context "with no argument" do
      it{ expect(@identity.to_char).to eq '1' }
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "comparisons" do
    before :all do
      @gen_1 = @gen
      @gen_2 = @gen_1.dup
      @gen_3 = @gen_2.dup.invert!
      @gen_4 = Generator.new('s')
    end
    #
    context "=~, the lax conparing," do
      it "should return true iff the letters coinside" do
        expect(@gen_1 =~ @gen_2).to be true
        expect(@gen_1 =~ @gen_3).to be true
        expect(@gen_1 =~ @gen_4).not_to be true
      end
    end
    #
    context "==, the normal comparing," do
      it "should return true iff the letters and inverseness coinside" do
        expect(@gen_1 == @gen_2).to be true
        expect(@gen_1 == @gen_3).not_to be true
        expect(@gen_1 == @gen_4).not_to be true
      end
    end
    #
    context "===, the strict comparing," do
      it "should return true iff the two objects exactly coinside" do
        expect(@gen_1 === @gen_2).to be false
        expect(@gen_1 === @gen_3).to be false
        expect(@gen_1 === @gen_4).to be false
      end
    end
    #
  end  
  #---------------------------------------

  #---------------------------------------
  describe "#inverse?" do
    it "should be false for a downcase letter" do
      expect(Generator.new('a')).not_to be_inverse
    end
    #
    it "should be true for an uppercase letter" do
      expect(Generator.new('A')).to be_inverse
    end
    #
    it "should be nil for the generator '1'" do
      expect(@identity.inverse?).to be_nil
    end
    #
  end  
  #---------------------------------------

  #---------------------------------------
  describe "#invert!" do
    context "with no arguments" do
      it "should change inverseness of a normal Generator" do 
        expect{ @gen.invert! }.to change{@gen.inverse?}.from(false).to(true)
      end
      #
      it { expect(@gen.to_char).to match /[A-Z]/ }
      #
      it "should not change inverseness of '1'" do
        expect{ @identity.invert! }.not_to change{ @identity }
      end
      #
    end
    # 
    context "with a odd integer" do
      subject{ Generator.new('x') }
      it "should change inverseness" do
        odd_num = 2*[*1..20].sample-1
        expect{ subject.invert!(odd_num) }.to change{ subject.inverse? }
      end
    end
    # 
    context "with a ever integer" do
      subject{ Generator.new('x') }
      it "should not change inverseness" do
        even_num = 2*[*1..20].sample
        expect{ subject.invert!(even_num) }.not_to change{ subject.inverse? }
      end
    end
    #
  end
  #---------------------------------------

  #---------------------------------------
  describe "#* (product!)" do
    before do
      @another = Generator.new('S')
    end
    #
    context "of two normal Generators" do
      it { expect(@gen*@another).to eq [@gen, @another]}
    end
    #
    context "of a Genarator 'g' and the identity '1'" do
      it { expect(@gen*@identity).to eq @gen }
      it { expect(@identity*@gen).to eq @gen }
    end
    #
  end  
  #---------------------------------------

end
#End of File
