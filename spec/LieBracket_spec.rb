#
# GLA/spec/LieBracket_spec.rb
#
# Time-stamp: <2016-04-03 22:49:40 (ryosuke)>
require('spec_helper')

require('LieBracket')

describe LieBracket do
  let(:lab) { LieBracket.new(fa, fb) }
  let(:laa) { LieBracket.new(fa, fa) }
  let(:la_ab) { LieBracket.new(fa, lab) }
  let(:lab_a) { LieBracket.new(lab, fa) }
  let(:lb_ab) { LieBracket.new(fb, lab) }
  #---------------------------------
  describe "#initialize" do
    #---
    shared_examples "an orginal LieBracket" do
      it do
        expect(subject.terms[0]).to be_a_kind_of Term
        expect(subject.couple).to be_a_kind_of Array
        expect(subject.coeff).to eq 1
        expect(subject.expand.to_s).to eq "#{fa}#{fb}-#{fb}#{fa}"
        expect(subject.to_s).to eq "[#{fa},#{fb}]"
      end
    end
    #---
    context "with two Strings" do
      let(:fa) { 'a' }
      let(:fb) { 'b' }
      subject{ lab }
      it_behaves_like "an orginal LieBracket"
    end
    #
    context "with Word 'w' and String 's'" do
      let(:fa) { FormalSum.new('w') }
      let(:fb) { 's' }
      subject{ lab }
      it_behaves_like "an orginal LieBracket"
    end
    #
    context "with String 's' and Term 't'" do
      let(:fa) { 's' }
      let(:fb) { Term.new('t') }
      subject{ lab }
      it_behaves_like "an orginal LieBracket"
    end
    #
    context "with Generator 'g' and Term 't'" do
      let(:fa) { Generator.new('g') }
      let(:fb) { Term.new('t') }
      subject{ lab }
      it_behaves_like "an orginal LieBracket"
    end
    #
  end
#---------------------------------

#---------------------------------
describe "#to_s" do
  let(:fa) { 'a' }
  let(:fb) { 'b' }
  context "for a stardard Liebracket" do
    it { expect(lab.to_s).to eq '[a,b]' }
  end
  context "for iterated Liebrackets" do
    it { expect(la_ab.to_s).to eq '[a,[a,b]]'}
    it { expect(lab_a.to_s).to eq '[[a,b],a]'}
    it { expect(LieBracket.new(lab, lab).to_s).to eq '[[a,b],[a,b]]'}
    it { expect(LieBracket.new(fa, lb_ab).to_s).to eq '[a,[b,[a,b]]]'}
    it { expect(LieBracket.new(lab_a, fb).to_s).to eq '[[[a,b],a],b]'}
  end
  context "for Liebrackets with Numeric" do
    it { expect(LieBracket.new(fa,5).to_s).to eq '[a,5]'}
    it { expect(LieBracket.new(-2,lab).to_s).to eq '[-2,[a,b]]'}
    it { expect(LieBracket.new(-2/3r,lab).to_s).to eq '[-2/3,[a,b]]'}
  end
end
#---------------------------------

#---------------------------------
describe "#inspect_couple" do
  let(:fa) { FormalSum.new('a') }
  let(:fb) { FormalSum.new('b') }
  before do
    @inspect_regexp = /\[(#<(FormalSum|LieBracket|Term|Word|Generator):([a-z0-9]+)(.*)>[,]*){2}\]/
  end
  #
  it { expect(lab.inspect_couple).to match @inspect_regexp }
  it { expect(la_ab.inspect_couple).to match @inspect_regexp }
  it { expect(LieBracket.new(Generator.new('g'), lab).inspect_couple).to match @inspect_regexp }
  #-----
  it { expect(LieBracket.new(Generator.new('g'),'b').inspect_couple).not_to match @inspect_regexp }
  it { expect(LieBracket.new(fa,5).inspect_couple).not_to match @inspect_regexp }
end
#---------------------------------

#---------------------------------
describe "#expand" do
  let(:fa) { 'a' }
  let(:fb) { 'b' }
    context "[a,b]" do
      subject{ lab.expand }
      it { is_expected.to be_kind_of(FormalSum) }
      it{ expect(subject.to_s).to eq 'ab-ba' }
    end
    context "[a,a]" do
      subject{ laa.expand }
      it{ expect(subject.to_s).to eq 'aa-aa'}
      it{ expect(subject.simplify.to_s).to eq '0'}
    end
    context "some more liebrackets" do
      context "[a,[a,b]]" do
        subject{ la_ab.expand.to_s }
        it { is_expected.to eq 'aab-aba-aba+baa'}
      end
      context "[[a,b],a]" do
        subject{ lab_a.expand.to_s }
        it { is_expected.to eq 'aba-baa-aab+aba'}
      end
      context "[[a,b], 8]" do
        subject{ LieBracket.new(lab, 8).expand }
        it{ expect(subject.to_s).to eq '8ab-8ba-8ab+8ba'}
        it{ expect(subject.simplify.to_s).to eq '0'}
      end
      context "[2/3r, [a,b]]" do
        subject{ LieBracket.new(2/3r, lab).expand }
        it{ expect(subject.to_s).to eq '2/3ab-2/3ba-2/3ab+2/3ba'}
        it{ expect(subject.simplify.to_s).to eq '0'}
      end
      context "expansion of [lb, num] and [num, lb]" do
        it "are equal to zero" do
          [89, -2, 3/8r, -8/121r].each do |num|
            expect( LieBracket.new(num, lab).expand.simplify.to_s ).to eq '0'
            expect( LieBracket.new(la_ab, num).expand.simplify.to_s ).to eq '0'
          end
        end
      end
    end
end
#---------------------------------

#---------------------------------
  describe "#* (multiply_by):" do
  let(:fa) { 'a' }
  let(:fb) { 'b' }
    context "to be non-destructive" do
      it { expect { lab*4 }.not_to change{ lab } }
    end
    #
    context "[a,b]*(-1)" do
      subject{ lab*(-1) }
      it "includes an array of Terms" do
        expect(subject.terms[0]).to be_a_kind_of Term
      end
      it{ expect(subject.to_s).to eq "-[a,b]" }
      it{ expect(subject.expand.to_s).to eq "-ab+ba" }
    end
    [3, -4, 5/2r, -8/7r].each do |num|
      context "[a,b]*#{num}" do
        subject{ lab*num }
        it "includes an array of Terms" do
          expect(subject.terms[0]).to be_a_kind_of Term
        end
        it{ expect(subject.to_s).to eq "#{num}[a,b]" }
        it{ expect(subject.expand.to_s).to eq "#{num}ab-#{num}ba".gsub('--', '+') }
      end
    end
    #
    context "of a 2-degree lb with an integer" do
      it "goes well" do
        ex_list = []
        ex_list << {obj: lb_ab, num: -6,
          str: '-6[b,[a,b]]', exp: '-6bab+6bba+6abb-6bab'}
        ex_list << {obj: lab_a, num: 23,
          str: '23[[a,b],a]', exp: '23aba-23baa-23aab+23aba'}
        ex_list << {obj: LieBracket.new(LieBracket.new('a','b')*5, fb), num: 3,
          str: '3[5[a,b],b]', exp: '15abb-15bab-15bab+15bba'}
        ex_list.each do |ex|
          sbj = ex[:obj]*ex[:num]
          expect(sbj.to_s).to eq ex[:str]
          expect(sbj.expand.to_s).to eq ex[:exp]
        end
      end
    end
    #
    context "of a 2-degree lb with a rational number" do
      it "goes well" do
        ex_list = []
        ex_list << {obj: lab_a, num: 5/3r,
          str: '5/3[[a,b],a]', exp: '5/3aba-5/3baa-5/3aab+5/3aba'}
        ex_list << {obj: lab_a, num: -4/8r,
          str: '-1/2[[a,b],a]', exp: '-1/2aba+1/2baa+1/2aab-1/2aba'}
        ex_list << {obj: lab_a, num: 5/1r,
          str: '5[[a,b],a]', exp: '5/1aba-5/1baa-5/1aab+5/1aba'}
        ex_list.each do |ex|
          sbj = ex[:obj]*ex[:num]
          expect(sbj.to_s).to eq ex[:str]
          expect(sbj.expand.to_s).to eq ex[:exp]
        end
      end
    end
    #
  end
#---------------------------------

#---------------------------------
describe "#flip, #flip!" do
  let(:fa) { 'a' }
  let(:fb) { 'b' }
  subject { (lab*(2/3r)).flip }
    it { expect( subject.couple ).to eq lab.couple.reverse }
    it { expect( subject.coeff ).to eq (-2/3r) }
    it { expect( subject.expand.to_s ).to eq '-2/3ba+2/3ab' }
    #---
    it { expect { lab.flip }.not_to change{ lab } }
    it { expect { subject.flip! }.to change{ subject.couple } }
    it { expect { subject.flip! }.to change{ subject.coeff }.from(-2/3r).to(2/3r) }
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
