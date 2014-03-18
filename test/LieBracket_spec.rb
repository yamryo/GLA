#
# GLA/test/LieBracket_spec.rb
#
# Time-stamp: <2014-03-18 19:17:11 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-byebug')

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
  describe "#initialize" do
    context "with two Strings 'a' and 'b'" do
      subject{ LieBracket.new('a', 'b') }
      its(:to_s){ should == '[a,b]' }
      its("expand.to_s"){ should == 'ab-ba' }
    end
    #
    context "with Word 'w' and String 's'" do
      subject{ LieBracket.new(Word.new('w'), 's') }
      its(:to_s){ should eq '[w,s]' }
      its("expand.to_s"){ should == 'ws-sw' }
    end
    #
    context "with String 's' and Term 't'" do
      subject{ LieBracket.new('s', Term.new('t')) }
      its(:to_s){ should == '[s,t]' }
      its("expand.to_s"){ should == 'st-ts' }
    end
    #
    context "with Generator 'g' and Term 't'" do
      subject{ LieBracket.new(Generator.new('g'), Term.new('t')) }
      its(:to_s){ should == '[g,t]' }
      its("expand.to_s"){ should == 'gt-tg' }
    end
    #
  end
#---------------------------------
  
#---------------------------------
describe "#to_s" do
    context "for a stardard Liebracket" do
      it { expect(@a_b.to_s).to eq '[a,b]' }
    end
    context "for iterated Liebrackets" do
      it { expect(@a_ab.to_s).to eq '[a,[a,b]]'}
      it { expect(@ab_a.to_s).to eq '[[a,b],a]'}
      it { expect(@ab_ab.to_s).to eq '[[a,b],[a,b]]'}
      it { expect(LieBracket.new(@a, @b_ab).to_s).to eq '[a,[b,[a,b]]]'}
      it { expect(LieBracket.new(@ab_a, @b).to_s).to eq '[[[a,b],a],b]'}
    end
    context "for Liebrackets with Numeric" do
      it { expect(LieBracket.new(@a,5).to_s).to eq '[a,5]'}
      it { expect(LieBracket.new(-2,@a_b).to_s).to eq '[-2,[a,b]]'}
      it { expect(LieBracket.new(-2/3r,@a_b).to_s).to eq '[-2/3,[a,b]]'}
    end
end
#---------------------------------

#---------------------------------
describe "#inspect_couple" do
    before do
      @inspect_regexp = /\[(#<(FormalSum|LieBracket|Term|Word|Generator):([a-z0-9]+)(.*)>[,]*){2}\]/
    end
    #
    it { expect(@a_b.inspect_couple).to match @inspect_regexp }
    it { expect(@a_ab.inspect_couple).to match @inspect_regexp }
    it { expect(LieBracket.new(Generator.new('g'), @a_b).inspect_couple).to match @inspect_regexp }
    #-----
    it { expect(LieBracket.new(Generator.new('g'),'b').inspect_couple).not_to match @inspect_regexp }
    it { expect(LieBracket.new(@a,5).inspect_couple).not_to match @inspect_regexp }
end
#---------------------------------

#---------------------------------
describe "#expand" do
    context "[a,b]" do
      subject{ @a_b.expand }
      it { should be_kind_of(FormalSum) }
      its(:to_s){ should == 'ab-ba' }
    end
    context "[a,a]" do
      subject{ @a_a.expand }
      its(:to_s){ should == 'aa-aa'}
      its("simplify.to_s"){ should == '0'}
    end
    context "some more liebrackets" do
      context "[a,[a,b]]" do
        subject{ @a_ab.expand.to_s }
        it { should == 'aab-aba-aba+baa'}
      end 
      context "[[a,b],a]" do
        subject{ @ab_a.expand.to_s }
        it { should == 'aba-baa-aab+aba'}
      end 
      context "[[a,b], 8]" do
        subject{ LieBracket.new(@a_b, 8).expand }
        its(:to_s){ should == '8ab-8ba-8ab+8ba'}
        its("simplify.to_s"){ should == '0'}
      end 
      context "[2/3r, [a,b]]" do
        subject{ LieBracket.new(2/3r, @a_b).expand }
        its(:to_s){ should == '2/3ab-2/3ba-2/3ab+2/3ba'}
        its("simplify.to_s"){ should == '0'}
      end 
      context "expansion of [lb, num] and [num, lb]" do
        [89, -2, 3/8r, -8/121r].each do |num|
          it { expect( LieBracket.new(num, @a_b).expand.simplify.to_s ).to eq '0'}
          it { expect( LieBracket.new(@a_ab, num).expand.simplify.to_s ).to eq '0'}
        end
      end
    end
end
#---------------------------------

#---------------------------------
  describe "#*(multiply_by):" do
    context "to be non-destructive" do
      it { expect { @a_b*4 }.not_to change{ @a_b } }
    end
    #
    [3, -4, 5/2r, -8/7r].each do |num|
      context "[a,b]*#{num}" do
        subject{ @a_b*num }
        its(:to_s){ should == "[#{num}a,b]"}
        its("expand.to_s"){ should == "#{num}ab-#{num}ba".gsub('--', '+')}
        #
        it { expect((@a_b.multiply_by(num)).to_s).to eq "[#{num}a,b]"}
      end
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
    #
    context "[[a,b],a]*(5/3r)" do
      it { (@ab_a*(5/3r)).to_s.should == '[[5/3a,b],a]'}
      it { @ab_a.multiply_by(5/3r).to_s.should == '[[5/3a,b],a]'}
      it { @ab_a.multiply_by(5/3r).expand.to_s.should == '5/3aba-5/3baa-5/3aab+5/3aba'}
    end
    #
    context "[[a,b],a]*(-4/8r)" do
      it { (@ab_a*(-4/8r)).to_s.should == '[[-1/2a,b],a]'}
      it { @ab_a.multiply_by(-4/8r).to_s.should == '[[-1/2a,b],a]'}
      it { @ab_a.multiply_by(-4/8r).expand.to_s.should == '-1/2aba+1/2baa+1/2aab-1/2aba'}
    end
    #
    context "[[a,b],a]*(5/1r)" do
      it { (@ab_a*(5/1r)).to_s.should == '[[5/1a,b],a]'}
    end
  end
#---------------------------------

  #---------------------------------
  describe "#opposite" do
    context "of [a,b]" do
      subject{ @a_b.opposite }
      its("expand.to_s"){ should == '-ab+ba' }
      pending{ expect(subject.to_s).to eq '-[a,b]' }
    end
    #
  end
  #---------------------------------

  #---------------------------------
  describe "Addition and subtraction:" do
    context "[a,b] + [[a,b],a]" do
      subject{ @a_b+@ab_a }
      its("expand.to_s"){ should == 'ab-ba+aba-baa-aab+aba' }
      pending do
        expect(subject.to_s).to eq '[a,b]+[[a,b],a]'
        expect(subject.class).to eq WHAT?
      end
    end
    #
    context "[a,b] - [[a,b],a]" do
      subject{ @a_b-@ab_a }
      #its("expand.to_s"){ should == 'ab-ba-aba+baa+aab-aba' }
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
