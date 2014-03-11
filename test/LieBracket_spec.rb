#
# LieBracket_spec.rb
#
# Time-stamp: <2014-03-11 18:04:17 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('LieBracket')

describe LieBracket do
  before :all do
    @a, @b = FormalSum.new('a'), FormalSum.new('b')
    @a_b = LieBracket.new(@a,@b)
    @a_a = LieBracket.new(@a, @a)
    @a_ab = LieBracket.new(@a, @a_b)
    @ab_a = LieBracket.new(@a_b, @a)
    @ab_ab = LieBracket.new(@a_b,@a_b)
    @b_ab = LieBracket.new(@b, @a_b)
  end
  #
#---------------------------------
describe "#to_s" do
    context "Stardard Liebracket" do
      it { @a_b.to_s.should == '[a,b]' }
    end
    context "Iterated Liebracket" do
      it { @a_ab.to_s.should == '[a,[a,b]]'}
      it { @ab_a.to_s.should == '[[a,b],a]'}
      it { @ab_ab.to_s.should == '[[a,b],[a,b]]'}
      it { LieBracket.new(@a, @b_ab).to_s.should == '[a,[b,[a,b]]]'}
      it { LieBracket.new(@ab_a, @b).to_s.should == '[[[a,b],a],b]'}
    end
    context "Liebracket with integers" do
      it { LieBracket.new(@a,5).to_s.should == '[a,5]'}
      it { LieBracket.new(-2,@a_b).to_s.should == '[-2,[a,b]]'}
    end
end
#---------------------------------

#---------------------------------
describe "#expand" do
    context "[a,b] in the expanded form" do
      it { @a_b.expand.should be_kind_of(FormalSum)}
      it { @a_b.expand.to_s.should == 'ab-ba'}
    end
    context "[a,a] in the expanded form" do
      it { @a_a.expand.to_s.should == 'aa-aa'}
    end
    context "and its simplified form" do
      it { @a_a.expand.simplify.to_s.should == '0'}
    end
    context "some more liebrackets" do
      context "[a,[a,b]]" do
      it { @a_ab.expand.to_s.should == 'aab-aba-aba+baa'}
      end 
      context "[[a,b],a]" do
      it { @ab_a.expand.to_s.should == 'aba-baa-aab+aba'}
      end 
      context "[[a,b], 8]" do
      it { LieBracket.new(@a_b, 8).expand.to_s.should == '8ab-8ba-8ab+8ba'}
      it { LieBracket.new(@a_b, 8).expand.simplify.to_s.should == '0'}
      end 
      context "[-2, [a,b]]" do
      it { LieBracket.new(-2,@a_b).expand.to_s.should == '-2ab+2ba+2ab-2ba'}
      it { LieBracket.new(-2,@a_b).expand.simplify.to_s.should == '0'}
      end
    end
end
#---------------------------------

#---------------------------------
  describe "#*(multiply_by)" do
    context "to be non-destructive" do
      it { expect { @a_b*4 }.not_to change{ @a_b } }
    end
    #
    context "[a,b]*3" do
      it { (@a_b*3).to_s.should == '[3a,b]'}
      it { @a_b.multiply_by(3).to_s.should == '[3a,b]'}
      it { @a_b.multiply_by(3).expand.to_s.should == '3ab-3ba'}
    end
    #
    context "[b,[a,b]]*(-6)" do
      it { (@b_ab*(-6)).to_s.should == '[-6b,[a,b]]'}
      it { @b_ab.multiply_by(-6).to_s.should == '[-6b,[a,b]]'}
      it { @b_ab.multiply_by(-6).expand.to_s.should == '-6bab+6bba+6abb-6bab'} #(-6b)(ab-ba)-(ab-ba)(-6b)
    end
    #
    context "[[a,b],a]*23" do
      it { (@ab_a*(23)).to_s.should == '[[23a,b],a]'}
      it { @ab_a.multiply_by(23).to_s.should == '[[23a,b],a]'}
      it { @ab_a.multiply_by(23).expand.to_s.should == '23aba-23baa-23aab+23aba'} #23(ab-ba)a-a23(ab-ba)
    end
  end
#---------------------------------

# #---------------------------------
# describe "" do
#   context "" do
#     int { }
#   end
# end
# #---------------------------------

end
#End of File
