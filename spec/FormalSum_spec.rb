#
# GLA/spec/FormalSum_spec.rb
#
# Time-stamp: <2016-04-03 22:24:52 (ryosuke)>
require('spec_helper')

require('FormalSum.rb')

TmZero = Term.new('1',0)
TmOne = Term.new('1',1)

describe FormalSum do
  #------------------------------------
  describe "Constants" do
    context "Zero" do
      subject { FormalSum::Zero }
      it{ is_expected.to be_kind_of FormalSum }
      it{ expect(subject.methods).to include(:terms) }
      it{ expect(subject.to_s).to eq '0' }
    end
    context "One" do
      subject { FormalSum::One }
      it{ is_expected.to be_kind_of FormalSum }
      it{ expect(subject.methods).to include(:terms) }
      it{ expect(subject.to_s).to eq '1' }
    end
  end
  #------------------------------------
  describe "Errors" do
    context "InvalidArgument" do
      it { expect{ FormalSum::InvalidArgument }.not_to raise_error(NameError) }
    end
  end
  #------------------------------------
  let(:fs) { FormalSum.new(arg) }
  let(:fs_terms) { fs.terms }
  let(:tm) { Term.new('aAB', -2) }
  #------------------------------------
  describe "#initialize:" do
    context "without arguments" do
      subject { FormalSum.new.to_s }
      it{ is_expected.to eq '0' }
    end
    #
    context "with the Term '0'" do
      let(:arg) { TmZero }
      subject{ fs.to_s }
      it{ is_expected.to eq '0' }
    end
    #
    context "with a single Term" do
      let(:arg) { tm }
      subject{ fs_terms }
      it{ is_expected.to be_kind_of(Array) }
      it{ is_expected.to eq [arg] }
    end
    #
    context "with Terms" do
      context "including the Zero" do
        let(:arg) { [TmZero, TmOne, tm] }
        subject { fs_terms }
        it{ expect(subject.size).to be 3}
        it{ expect(subject.first.to_s).to eq '0' }
      end
      #
      context "in an Array" do
        let(:arg) { [TmOne, tm] }
        subject { fs_terms }
        it "should be a FormalSum of the given Terms" do
          is_expected.to eq arg
        end
        #
        let(:arg) { [TmOne, TmZero] }
        subject { fs_terms }
        it "should not ignore the Zero" do
          is_expected.to eq arg
        end
      end
      #
    end
    #
    context "with a String" do
      context "including no zeros" do
        let(:arg) { '2+c-B-4s' }
        it "equips an Array of Terms" do
          (fs_terms.size).times do |k|
            expect(fs_terms[k]).to be_a_kind_of Term
            expect(fs_terms[k].show).to eq %w[(2)1 (1)c (-1)B (-4)s][k]
          end
        end
      end
      #
      context "including zeros" do
        let(:arg) { '-3+6acB-a+0bKde-00+0-50' }
        subject{ fs_terms }
        it "does not ignore zero terms" do
          expect(subject.join(',')).to eq '-3,6acB,-a,0,0,0,-50'
          expect(subject.fetch(3)).to include(:word => 'bKde', :coeff => 0)
        end
      end
    end
  end
  #------------------------------------

  #------------------------------------
  describe "#to_s" do
    before { @str = '-3+6acB-a-50' }
    context "for a FormalSum without zero terms" do
      let(:arg) { @str }
      subject { fs.to_s }
      it { is_expected.to eq @str }
    end
    #
    context "for a FormalSum with zero terms" do
      let(:arg) { '-3+6acB-a+0bKde-0+0-50' }
      subject { fs.to_s }
      it { is_expected.to eq @str }
    end
    #
    context "for a FormalSum with zero terms only" do
      let(:arg) { '-0+0acB-0a+0bKde-0+0+0' }
      subject { fs.to_s }
      it { is_expected.to eq '0' }
    end
    #
    context "for Zero" do
      subject { FormalSum.new().to_s }
      it { is_expected.to eq '0' }
    end
    #
    context "for One" do
      subject { FormalSum.new(TmOne).to_s}
      it { is_expected.to eq '1' }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#show" do
    context "for a FormalSum without zero terms" do
      let(:arg) { '-3+6acB-a-50' }
      subject { fs.show }
      it { is_expected.to eq '(-3)1+(6)acB+(-1)a+(-50)1'}
    end
    #
    context "for a FormalSum with zero terms" do
      let(:arg) { '-3+6acB-a+0bKde-0+0-50' }
      subject { fs.show }
      it { is_expected.to eq '(-3)1+(6)acB+(-1)a+(0)bKde+(0)1+(0)1+(-50)1'}
    end
    #
    context "for a FormalSum with zero terms only" do
      let(:arg) { '-0+0acB-0a+0bKde+0' }
      subject { fs.show }
      it { is_expected.to eq '(0)1+(0)acB+(0)a+(0)bKde+(0)1'}
    end
    #
    context "for Zero" do
      subject { FormalSum.new.show }
      it { is_expected.to eq '(0)1'}
    end
    #
    context "for One" do
      subject { FormalSum.new(TmOne).show }
      it { is_expected.to eq '(1)1'}
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "Arithmetic operations" do
    let(:fs_2) { FormalSum.new('c-3de') }
    let(:zerofs) { FormalSum.new('0a-0b') }
    #------------------------------------
    describe "#+ [addition]" do
      let(:arg) { 'a-b' }
      context "of 'a-b' and 'c-3de'" do
        subject { fs+fs_2 }
        it{ expect( subject.class ).to eq FormalSum }
        it{ expect( subject.to_s ).to eq 'a-b+c-3de' }
        it{ expect( subject.show ).to eq '(1)a+(-1)b+(1)c+(-3)de' }
      end
      #
      context "of 'a-b' and Zero" do
        subject { fs+zerofs }
        it{ expect( subject.class).to eq FormalSum }
        it{ expect( subject.to_s).to eq 'a-b' }
        it{ expect( subject.show).to eq '(1)a+(-1)b+(0)a+(0)b' }
      end
      #
    end
    #------------------------------------

    #------------------------------------
    describe "#- [subtraction]" do
      let(:arg) { 'a-b' }
      context "of 'c-3de' from 'a-b'" do
        subject { fs-fs_2 }
        it{ expect( subject.class ).to eq FormalSum }
        it{ expect( subject.to_s ).to eq 'a-b-c+3de' }
        it{ expect( subject.show ).to eq '(1)a+(-1)b+(-1)c+(3)de' }
      end
      #
      context "of 'a-b' from itself" do
        subject { fs-fs }
        it{ expect( subject.class ).to eq FormalSum }
        it{ expect( subject.to_s ).to eq 'a-b-a+b' }
        it{ expect( subject.show ).to eq '(1)a+(-1)b+(-1)a+(1)b' }
      end
      #
      context "of 'a-b' from itself followed by simplification" do
        subject { (fs-fs).simplify }
        it{ expect( subject.class ).to eq FormalSum }
        it{ expect( subject.to_s ).to eq '0' }
        it{ expect( subject.show ).to eq '(0)a+(0)b' }
      end
    end
    #------------------------------------

    #------------------------------------
    describe "#*" do
      let(:arg) { 'a-b' }
      describe "#product" do
        context "to be non-destructive" do
          it { expect{ fs*fs_2 }.not_to change{ fs } }
        end
        #
        context "for 'a-b' and 'c-3de'" do
          it { expect((fs*fs_2).to_s).to eq 'ac-3ade-bc+3bde' }
        end
        #
        context "for a FormalSum and Zero" do
          it "should simply connect two Array of Terms" do
            expect((fs*zerofs).show).to eq '(0)aa+(0)ab+(0)ba+(0)bb'
          end
        end
      end
      #
      describe "#multiply_by" do
        context "to be non-destructive" do
          it { expect { fs*10 }.not_to change{ fs } }
        end
        #
        context "to be scaler multiplication by an Integer" do
          it { expect((fs*(-2)).show).to eq '(-2)a+(2)b'}
        end
        #
      end
    end
    #
    describe "#multiply_by!" do
      let(:arg) { 'a-1+bA-34+7cAkK' }
      context "to be destructive" do
        it { expect { fs.multiply_by!(10) }.to change{ fs.terms[1][:coeff] }.from(-1).to(-10) }
      end
      #
      context "to be scaler multiplication by an Integer" do
        it { expect( (fs*(-5)).show ).to eq '(-5)a+(5)1+(-5)bA+(170)1+(-35)cAkK'}
        it { expect((fs*(-5)).to_s).to eq '-5a+5-5bA+170-35cAkK'}
      end
      #
    end
    #------------------------------------
  end
  #------------------------------------

  #------------------------------------
  describe "#opposite, #opposite!" do
    # before :each do
    #   @fs = FormalSum.new('a-b+c-3de')
    #   @zfs = FormalSum.new('0-0aBCD+00')
    # end
    let(:arg) { 'a-b+c-3de' }
    let(:zerofs) { FormalSum.new('0a-0b') }
    #
    context "#opposite" do
      context "for a normal FormalSum" do
        it "should return a FormalSum of terms with opposite signs to the original" do
          expect((fs.opposite.terms.map{ |t| t.sign })).to eq ['-','+','-','+']
        end
        #
        it "should cause no change to the original" do
          expect{ fs.opposite }.not_to change{ fs.terms }
          expect{ fs.opposite }.not_to change{ fs.terms.map{ |t| t.sign } }
          expect{ fs.opposite }.not_to change{ fs.terms.map{ |t| t[:coeff] } }
        end
      end
      #
      context "for a FormalSum with zero terms" do
        it "should cause no change" do
          expect { zerofs.opposite }.not_to change{ zerofs.terms }
          expect { zerofs.opposite }.not_to change{ zerofs.terms.map{ |t| t.sign } }
          expect { zerofs.opposite }.not_to change{ zerofs.terms.map{ |t| t[:coeff] } }
        end
      end
      #
    end
    #
    context "#opposite!" do
      context "for a normal FormalSum" do
        it "should cause change to the original" do
          expect { fs.opposite! }.not_to change{ fs.terms }
          expect { fs.opposite! }.to change{ fs.terms.map{ |t| t.sign } }
          expect { fs.opposite! }.to change{ fs.terms.map{ |t| t[:coeff] } }
        end
      end
      #
      context "for a FormalSum with zero terms" do
        it "should cause no change" do
          expect { zerofs.opposite! }.not_to change{ zerofs.terms }
          expect { zerofs.opposite! }.not_to change{ zerofs.terms.map{ |t| t.sign } }
          expect { zerofs.opposite! }.not_to change{ zerofs.terms.map{ |t| t[:coeff] } }
        end
      end
      #
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#reverse(!)" do
    let(:arg) { 'a-1+bA-34+7cAkK' }
    #
    context "for a FormalSum 'a+1+bA-34+7cAkK'" do
      subject { fs.reverse.to_s }
      it { is_expected.to eq '7cAkK-34+bA-1+a' }
    end
    #
    context "of non-destructive type" do
      it { expect { fs.reverse }.not_to change{ fs.terms } }
    end
    #
    context "of destructive type" do
      it { expect { fs.reverse! }.to change{ fs.terms } }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#sort" do
    let(:arg) { 'a-1+bA' }
    #
    context "for a FormalSum 'a+1+bA'" do
      subject { fs.sort.to_s }
      it { is_expected.to eq '-1+a+bA' }
    end
    #
    context "for a FormalSum 'a-1+bA+0a-0kZ'" do
      subject { (fs+'0a-0kZ').sort.show }
      it { is_expected.to eq '(0)a+(0)kZ+(-1)1+(1)a+(1)bA' }
    end
    #
    context "of non-destructive type" do
      it { expect{ fs.sort }.not_to change{ fs.terms } }
    end
    #
    context "of destructive type" do
      it { expect{ fs.sort! }.to change{ fs.terms } }
    end
    #
    context "about uppercases and lowercases" do
      subject{ FormalSum.new('a+bs-bS+M+1-A-0b+bsX').sort.to_s }
      it { is_expected.to eq '1+a-A+M+bs-bS+bsX' }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#degree" do
    context "of a FormalSum '-2bA'" do
      subject { FormalSum.new('-2bA').degree }
      it { is_expected.to eq 2}
    end
    #
    context "of a FormalSum '1-a-2bAc+3DVe-10oLfP+M+29'" do
      subject { FormalSum.new('1-a-2bAc+3DVe-10oLfP+M+29').degree }
      it { is_expected.to eq 4}
    end
    #
    context "of the FormalSum One" do
      subject { FormalSum.new(TmOne).degree }
      it { is_expected.to eq 0}
    end
    #
    context "of the FormalSum Zero" do
      subject { FormalSum.new(TmZero).degree }
      it { is_expected.to eq -1.0/0.0}
    end
    #
    context "for a FormalSum '2Bc+1+a-2Bc+a+3aCb-6b+2-5aCb'" do
      subject { FormalSum.new('2Bc+1+a-2Bc+a+3aCb-6b+2-5aCb').degree }
      it { is_expected.to eq 3 }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#homo_part" do
    context "for a FormalSum '29-a+3DVe-10oLfP+M-2bAc+1'" do
      let(:arg) { '29-a+3DVe-10oLfP+M-2bAc+1' }
      let(:marr) { ["29+1", "-a+M", "0", "3DVe-2bAc", "-10oLfP"] }
      #---
      context "for a single argument" do
        5.times do |k|
          context "degree-#{k} part" do
            subject { fs.homo_part(k).to_s }
            it { is_expected.to eq marr[k] }
          end
        end
        #---
        context "too big degree part" do
          subject { fs.homo_part(5).terms }
          it { is_expected.to eq [TmZero] }
        end
        #---
        context "negative degree parts" do
          subject { fs.homo_part(-1).terms }
          it { is_expected.to eq [TmZero] }
        end
      end
      #---
      context "for more than one argument" do
        context "degree-(0..2) part" do
          subject { fs.homo_part(0..2).to_s }
          it { is_expected.to eq '29-a+M+1' }
        end
        #---
        context "(degree-0,2, and 5) part" do
          subject { fs.homo_part(1,2,4).to_s }
          it { is_expected.to eq '-a-10oLfP+M'  }
        end
        #---
        context "(degree-0 and higher than 3) part" do
          subject { fs.homo_part(0,3..fs.degree).to_s }
          it { is_expected.to eq '29+3DVe-10oLfP-2bAc+1' }
        end
      end
    end
  end
  #------------------------------------

  #------------------------------------
  describe "#simplify, #simplify!" do
    context "#simplify for a FormalSum" do
      let(:arg) { 'a-b+a' }
      it "should not change the original" do
        expect { fs.simplify }.not_to change{fs.terms }
      end
    end
    #
    context "for a FormalSum 'a-b+a'" do
      let(:arg) { 'a-b+a' }
      subject { fs.simplify.show }
      it { is_expected.to eq '(2)a+(-1)b' }
    end
    #
    context "for a FormalSum '3b+2Bc+1+a-2Bc+a+3aCb-6b-9-5aCb+5b'" do
      let(:arg) { '3b+2Bc+1+a-2Bc+a+3aCb-6b-9-5aCb+5b' }
      subject { fs.simplify.to_s }
      it { is_expected.to eq '-8+2a+2b-2aCb' }
    end
    #
    context "#simplify! for a FormalSum" do
      let(:arg) { 'a-b+a' }
      it "should change the original" do
        expect { fs.simplify! }.to change{ fs.terms }
      end
    end
  end
  #------------------------------------

  #------------------------------------
  describe "private and protected methods" do
    let(:arg) { '1+a+ab-2Abc' }
    context "#<<" do
      it { expect{ fs << Term.new('b') }.to raise_error(NoMethodError) }
    end
    #
    context "#str2terms" do
      it { expect{ fs.str2terms('-8+2a+2b-2aCb') }.to raise_error(NoMethodError) }
    end
    #
  end
  #------------------------------------

  # #------------------------------------
  # describe "" do
  #   context "" do
  #     it { }
  #   end
  # end
  # #------------------------------------

end
#-------------
# End of File
#-------------
