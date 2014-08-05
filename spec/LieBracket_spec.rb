#
# GLA/spec/LieBracket_spec.rb
#
# Time-stamp: <2014-08-05 23:27:14 (ryosuke)>
require('spec_helper')

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
    context "with two Strings" do
      subject{ LieBracket.new('a', 'b') }
      it "goes well" do
        expect(subject.terms[0]).to be_a_kind_of Term
        expect(subject.couple).to be_a_kind_of Array
        expect(subject.coeff).to eq 1
        expect(subject.to_s).to eq '[a,b]'
        expect(subject.expand.to_s).to eq 'ab-ba'
      end
    end
    #
    context "with Word 'w' and String 's'" do
      subject{ LieBracket.new(Word.new('w'), 's') }
      it "goes well" do
        expect(subject.terms[0]).to be_a_kind_of Term
        expect(subject.couple).to be_a_kind_of Array
        expect(subject.coeff).to eq 1
        expect(subject.to_s).to eq '[w,s]'
        expect(subject.expand.to_s).to eq 'ws-sw'
      end
    end
    #
    context "with String 's' and Term 't'" do
      subject{ LieBracket.new('s', Term.new('t')) }
      it "goes well" do
        expect(subject.terms[0]).to be_a_kind_of Term
        expect(subject.couple).to be_a_kind_of Array
        expect(subject.coeff).to eq 1
        expect(subject.to_s).to eq '[s,t]'
        expect(subject.expand.to_s).to eq 'st-ts'
      end
    end
    #
    context "with Generator 'g' and Term 't'" do
      subject{ LieBracket.new(Generator.new('g'), Term.new('t')) }
      it "goes well" do
        expect(subject.terms[0]).to be_a_kind_of Term
        expect(subject.couple).to be_a_kind_of Array
        expect(subject.coeff).to eq 1
        expect(subject.to_s).to eq '[g,t]'
        expect(subject.expand.to_s).to eq 'gt-tg'
      end
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
      it{ expect(subject.to_s).to eq 'ab-ba' }
    end
    context "[a,a]" do
      subject{ @a_a.expand }
      it{ expect(subject.to_s).to eq 'aa-aa'}
      it{ expect(subject.simplify.to_s).to eq '0'}
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
        it{ expect(subject.to_s).to eq '8ab-8ba-8ab+8ba'}
        it{ expect(subject.simplify.to_s).to eq '0'}
      end 
      context "[2/3r, [a,b]]" do
        subject{ LieBracket.new(2/3r, @a_b).expand }
        it{ expect(subject.to_s).to eq '2/3ab-2/3ba-2/3ab+2/3ba'}
        it{ expect(subject.simplify.to_s).to eq '0'}
      end 
      context "expansion of [lb, num] and [num, lb]" do
        it "are equal to zero" do
          [89, -2, 3/8r, -8/121r].each do |num|
            expect( LieBracket.new(num, @a_b).expand.simplify.to_s ).to eq '0'
            expect( LieBracket.new(@a_ab, num).expand.simplify.to_s ).to eq '0'
          end
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
    context "[a,b]*(-1)" do
      subject{ @a_b*(-1) }
      it "includes an array of Terms" do
        expect(subject.terms[0]).to be_a_kind_of Term
      end
      it{ expect(subject.to_s).to eq "-[a,b]" }
      it{ expect(subject.expand.to_s).to eq "-ab+ba" }
    end
    [3, -4, 5/2r, -8/7r].each do |num|
      context "[a,b]*#{num}" do
        subject{ @a_b*num }
        it "includes an array of Terms" do
          expect(subject.terms[0]).to be_a_kind_of Term
        end
        it{ expect(subject.to_s).to eq "#{num}[a,b]" }
        it{ expect(subject.expand.to_s).to eq "#{num}ab-#{num}ba".gsub('--', '+') }
        #
        #it { expect((@a_b.multiply_by(num)).to_s).to eq "[#{num}a,b]"}
      end
    end
    #
    context "of a 2-degree lb with an integer" do
      it "goes well" do
        ex_list = []
        ex_list << {obj: @b_ab, num: -6,
          str: '-6[b,[a,b]]', exp: '-6bab+6bba+6abb-6bab'}
        ex_list << {obj: @ab_a, num: 23,
          str: '23[[a,b],a]', exp: '23aba-23baa-23aab+23aba'}
        ex_list << {obj: LieBracket.new(LieBracket.new('a','b')*5,@b), num: 3,
          str: '3[5[a,b],b]', exp: '15abb-15bab-15bab+15bba'}
      #binding.pry
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
        ex_list << {obj: @ab_a, num: 5/3r,
          str: '5/3[[a,b],a]', exp: '5/3aba-5/3baa-5/3aab+5/3aba'}
        ex_list << {obj: @ab_a, num: -4/8r,
          str: '-1/2[[a,b],a]', exp: '-1/2aba+1/2baa+1/2aab-1/2aba'}
        ex_list << {obj: @ab_a, num: 5/1r,
          str: '5/1[[a,b],a]', exp: '5/1aba-5/1baa-5/1aab+5/1aba'}
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

# #---------------------------------
# describe "" do
#   context "" do
#     it { }
#   end
# end
# #---------------------------------

end
#End of File
