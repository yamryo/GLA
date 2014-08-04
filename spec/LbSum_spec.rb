#
# GLA/test/LbSum_spec.rb
#
# Time-stamp: <2014-08-04 15:09:45 (ryosuke)>
require('spec_helper')

require('LbSum')

describe LbSum do
  before :all do
    @a_b = LieBracket.new('a', 'b')
    @a_ab = LieBracket.new('a', @a_b)
    @lbs = LbSum.new(@a_b)
  end
  #
#---------------------------------
  describe "#initialize" do
    it "should accept a(n Array of) LieBrackets" do
      expect{ LbSum.new(@a_b) }.not_to raise_error
      expect{ LbSum.new(@a_b, @a_b) }.not_to raise_error
      expect{ LbSum.new(@a_b, @a_ab, @a_b) }.not_to raise_error
    end
    #
    context "with a Hash" do
      subject{ LbSum.new({lb: @a_b, coeff: 1}) }
      it{ expect(subject.terms).to be_a_kind_of Array }
      it "which has the key :lb with a LieBracket value" do
        expect(subject.terms.first).to include(:lb)
        expect(subject.terms.first[:lb]).to be_a_kind_of LieBracket
      end
      #
      xit "and the key :coeff with a Numeric value" do
      end
    end
    #
    context "with an Array of Hashes" do
      subject{ LbSum.new({lb: @a_b, coeff: 1},{lb: @a_ab, coeff: -1/2r}) }
      it{ expect(subject.terms).to be_a_kind_of Array }
    end
  end
#---------------------------------
  
  #---------------------------------
  describe "#opposite" do
    pending "of [a,b]" do
      subject{ @lbs.opposite.to_s }
      it{ should == '-[a,b]' }
    end
    #
  end
  #---------------------------------

  #---------------------------------
  describe "Addition and subtraction:" do
    context "[a,b] + [[a,b],a]" do
      subject{ @a_b+@ab_a }
      pending do
        expect(subject.to_s).to eq '[a,b]+[[a,b],a]'
        expect(subject.class).to eq WHAT?
      end
    end
    #
    context "[a,b] - [[a,b],a]" do
      subject{ @a_b-@ab_a }
      pending "" do
        expect(subject.to_s).to eq '[a,b]-[[a,b],a]'
        expect(subject.class).to eq WHAT?
      end
    end
    #
  end
  #---------------------------------

# #---------------------------------
# describe "" do
#   context "" do
#     it { }
#   end
# end
# #---------------------------------

end
#End of File
