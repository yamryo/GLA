#
# GLA/spec/FormalSum_spec.rb
#
# Time-stamp: <2014-08-05 22:41:28 (ryosuke)>
require('spec_helper')

require('FormalSum.rb')

Zero = FormalSum::Zero
One = FormalSum::One

# share_examples_for 'Should be Zero' do
#   it {expect.to eq Zero }
# end

describe FormalSum do 

  #------------------------------------
  describe "#initialize:" do
    before do
      @t = Term.new('aAB', -2)
      @zt = Term.new('Wiejr',0)
      @fs = FormalSum.new(@t)
    end
    #
    context "with the Zero" do
      subject{ FormalSum.new(Zero).terms }
      it{ is_expected.to be_kind_of Array }
      it{ is_expected.to eq [Zero] }
    end
    #
    context "with a single Term" do
      subject{ @fs.terms }
      it{ is_expected.to be_kind_of(Array) }
      it{ is_expected.to eq [@t] }
    end
    #
    context "with Terms" do
      context "including the Zero" do
        let(:fst){ FormalSum.new(Zero, One, @t).terms }
        it{ expect(fst.size).to be 3}
        it{ expect(fst.first).to be Zero}
      end
      #
      context "in an Array" do
        it "should be a FormalSum of the given Terms" do
          expect(FormalSum.new([One, @t]).terms).to eq [One, @t]
        end
        #
        it "should not ignore the Zero" do
          expect(FormalSum.new([One, Zero]).terms).to eq [One, Zero]
          expect(FormalSum.new([@zt, One, @t]).terms).to eq [@zt, One, @t]
        end
      end
      #
    end
    # 
    context "with a String" do
      before do
        @str = '2+c-B-4s'
        @arr = %w[(2)1 (1)c (-1)B (-4)s]
        @tarr = FormalSum.new(@str).terms
      end
      #
      it "equips an Array of Terms" do
        (@tarr.size).times do |k|
          expect(@tarr[k]).to be_a_kind_of Term
          expect(@tarr[k].show).to eq @arr[k]
        end
      end
      #
      it "does not ignore zero terms" do
        ts = FormalSum.new('-3+6acB-a+0bKde-00+0-50').terms
        expect(ts.join(',')).to eq '-3,6acB,-a,0,0,0,-50'
        expect(ts[3]).to include(:word => 'bKde', :coeff => 0)
        #expect(ts[3]).to eq {word: 'bKde', coeff: 0}
      end
    end
    #
    context "without arguments" do
      it { expect(FormalSum.new.terms).to eq [Zero] }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#to_s" do
    context "for a FormalSum without zero terms" do
      subject { FormalSum.new('-3+6acB-a-50').to_s }
      it { is_expected.to eq '-3+6acB-a-50'} 
    end
    #
    context "for a FormalSum with zero terms" do
      subject { FormalSum.new('-3+6acB-a+0bKde-0+0-50').to_s}
      it { is_expected.to eq '-3+6acB-a-50'} 
    end
    #
    context "for a FormalSum with zero terms only" do
      subject { FormalSum.new('-0+0acB-0a+0bKde-0+0+0').to_s}
      it { is_expected.to eq '0'} 
    end
    #
    context "for Zero" do
      subject { FormalSum.new.to_s}
      it { is_expected.to eq '0'} 
    end
    #
    context "for One" do
      subject { FormalSum.new(One).to_s}
      it { is_expected.to eq '1'} 
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#show" do
    context "for a FormalSum without zero terms" do
      subject { FormalSum.new('-3+6acB-a-50').show}
      it { is_expected.to eq '(-3)1+(6)acB+(-1)a+(-50)1'} 
    end
    #
    context "for a FormalSum with zero terms" do
      subject { FormalSum.new('-3+6acB-a+0bKde-0+0-50').show}
      it { is_expected.to eq '(-3)1+(6)acB+(-1)a+(0)bKde+(0)1+(0)1+(-50)1'} 
    end
    #
    context "for a FormalSum with zero terms only" do
      subject { FormalSum.new('-0+0acB-0a+0bKde+0').show}
      it { is_expected.to eq '(0)1+(0)acB+(0)a+(0)bKde+(0)1'} 
    end
    #
    context "for Zero" do
      subject { FormalSum.new.show}
      it { is_expected.to eq '(0)1'} 
    end
    #
    context "for One" do
      subject { FormalSum.new(One).show}
      it { is_expected.to eq '(1)1'} 
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "Arithmetic operations" do
    before :all do
      @fs_1 = FormalSum.new('a-b')
      @fs_2 = FormalSum.new('c-3de')
      @zfs = FormalSum.new('0a-0b')
    end
    #
    #------------------------------------
    describe "#+ [addition]" do
      context "of 'a-b' and 'c-3de'" do
        let(:add12){ @fs_1+@fs_2 }
        it{ expect(add12.class).to eq FormalSum }
        it{ expect(add12.to_s).to eq 'a-b+c-3de' }
        it{ expect(add12.show).to eq '(1)a+(-1)b+(1)c+(-3)de' }
      end
      # 
      context "of 'a-b' and Zero" do
        let(:add10){ @fs_1+@zfs }
        it{ expect(add10.class).to eq FormalSum }
        it{ expect(add10.to_s).to eq 'a-b' }
        it{ expect(add10.show).to eq '(1)a+(-1)b+(0)a+(0)b' }
      end
      #
    end
    #------------------------------------

    #------------------------------------
    describe "#- [subtraction]" do
      context "of 'c-3de' from 'a-b'" do
        let(:sbt21){ @fs_1-@fs_2 }
        it{ expect(sbt21.class).to eq FormalSum }
        it{ expect(sbt21.to_s).to eq 'a-b-c+3de' }
        it{ expect(sbt21.show).to eq '(1)a+(-1)b+(-1)c+(3)de' }
      end
      # 
      context "of 'a-b' from itself" do
        let(:sbt11){ @fs_1-@fs_1 }
        it{ expect(sbt11.class).to eq FormalSum }
        it{ expect(sbt11.to_s).to eq 'a-b-a+b' }
        it{ expect(sbt11.show).to eq '(1)a+(-1)b+(-1)a+(1)b' }
      end
      #
      context "of 'a-b' from itself followed by simplification" do
        let(:sbt11s){ (@fs_1-@fs_1).simplify }
        it{ expect(sbt11s.class).to eq FormalSum }
        it{ expect(sbt11s.to_s).to eq '0' }
        it{ expect(sbt11s.show).to eq '(0)a+(0)b' }
      end
      #
    end
    #------------------------------------

    #------------------------------------
    describe "#*" do
      describe "#product" do
        context "to be non-destructive" do
          it { expect{ @fs_1*@fs_2 }.not_to change{ @fs_1 } }
        end
        #
        context "for 'a-b' and 'c-3de'" do
          it { expect((@fs_1*@fs_2).to_s).to eq 'ac-3ade-bc+3bde' }
        end
        # 
        context "for a FormalSum and Zero" do
          it "should simply connect two Array of Terms" do
            expect((@fs_1*@zfs).show).to eq '(0)aa+(0)ab+(0)ba+(0)bb'
          end
        end
      end
      #
      describe "#multiply_by" do
        #
        context "to be non-destructive" do
          it { expect { @fs_1*10 }.not_to change{ @fs_1 } }
        end
        #
        context "to be scaler multiplication by an Integer" do
          it { expect((@fs_1*(-2)).show).to eq '(-2)a+(2)b'}
        end
        #
      end
    end
    #
    describe "#multiply_by!" do
      before(:all){ @fs = FormalSum.new('a-1+bA-34+7cAkK') }
      #
      context "to be destructive" do
        it { expect { @fs.multiply_by!(10) }.to change{ @fs.terms[1][:coeff] }.from(-1).to(-10) }
      end
      #
      context "to be scaler multiplication by an Integer" do
        it { expect((@fs*(-5)).show).to eq '(-50)a+(50)1+(-50)bA+(1700)1+(-350)cAkK'}
        it { expect((@fs*(-5)).to_s).to eq '-50a+50-50bA+1700-350cAkK'}
      end
      #
    end
    #------------------------------------
  end
  #------------------------------------

  #------------------------------------
  describe "#opposite, #opposite!" do
    before :each do
      @fs = FormalSum.new('a-b+c-3de')
      @zfs = FormalSum.new('0-0aBCD+00')
    end
    #
    context "#opposite" do
      context "for a normal FormalSum" do
        #
        it "should return a FormalSum of terms with opposite signs to the original" do
      expect((@fs.opposite.terms.map{ |t| t.sign })).to eq ['-','+','-','+'] 
        end
        #
        it "should cause no change to the original" do
          expect{ @fs.opposite }.not_to change{ @fs.terms } 
          expect{ @fs.opposite }.not_to change{ @fs.terms.map{ |t| t.sign } } 
          expect{ @fs.opposite }.not_to change{ @fs.terms.map{ |t| t[:coeff] } } 
        end
      end
      #
      context "for a FormalSum with zero terms" do
        it "should cause no change" do
          expect { @fs.opposite }.not_to change{ @fs.terms } 
          expect { @zfs.opposite }.not_to change{ @zfs.terms.map{ |t| t.sign } } 
          expect { @zfs.opposite }.not_to change{ @zfs.terms.map{ |t| t[:coeff] } } 
        end
      end
      #
    end
    #
    context "#opposite!" do
      context "for a normal FormalSum" do
        it "should cause change to the original" do
          expect { @fs.opposite! }.not_to change{ @fs.terms } 
          expect { @fs.opposite! }.to change{ @fs.terms.map{ |t| t.sign } } 
          expect { @fs.opposite! }.to change{ @fs.terms.map{ |t| t[:coeff] } } 
        end
      end
      #
      context "for a FormalSum with zero terms" do
        it "should cause no change" do
          expect { @fs.opposite! }.not_to change{ @fs.terms } 
          expect { @zfs.opposite! }.not_to change{ @zfs.terms.map{ |t| t.sign } } 
          expect { @zfs.opposite! }.not_to change{ @zfs.terms.map{ |t| t[:coeff] } } 
        end
      end
      #
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#reverse(!)" do
    before(:all){ @fs = FormalSum.new('a-1+bA-34+7cAkK') }
    #
    context "for a FormalSum 'a+1+bA-34+7cAkK'" do
      subject { @fs.reverse.to_s }
      it { is_expected.to eq '7cAkK-34+bA-1+a' }
    end
    #
    context "of non-destructive type" do
      it { expect { @fs.reverse }.not_to change{ @fs.terms } }
    end
    #
    context "of destructive type" do
      it { expect { @fs.reverse! }.to change{ @fs.terms } }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#sort" do
    before(:all){ @fs = FormalSum.new('a-1+bA') }
    #
    context "for a FormalSum 'a+1+bA'" do
      #binding.pry
      subject { @fs.sort.to_s }
      it { is_expected.to eq '-1+a+bA' }
    end
    #
    context "for a FormalSum 'a-1+bA+0a-0kZ'" do
      subject { (@fs+'0a-0kZ').sort.show }
      it { is_expected.to eq '(0)a+(0)kZ+(-1)1+(1)a+(1)bA' }
    end
    #
    context "of non-destructive type" do
      it { expect { @fs.sort }.not_to change{ @fs.terms } }
    end
    #
    context "of destructive type" do
      it { expect { @fs.sort! }.to change{ @fs.terms } }
    end
    #
    context "about uppercases and lowercases" do
      subject{ FormalSum.new('a+bs-bS+M+1-A-0b+bsX') }
      it { expect(subject.sort.to_s).to eq '1+a-A+M+bs-bS+bsX' }
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
      subject { FormalSum.new(One).degree }
      it { is_expected.to eq 0}
    end
    #
    context "of the FormalSum Zero" do
      subject { FormalSum.new(Zero).degree }
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
      before :all do 
        @mfs = FormalSum.new('29-a+3DVe-10oLfP+M-2bAc+1')
        @marr = ["29+1", "-a+M", "0", "3DVe-2bAc", "-10oLfP"]
      end
      #
      context "for a single argument" do
        5.times do |k|
          context "degree-#{k} part" do
            subject { @mfs.homo_part(k).to_s }
            it { is_expected.to eq @marr[k] }
          end
        end
        #
        context "too big degree part" do
          subject { @mfs.homo_part(5).terms }
          it { is_expected.to eq [Zero] }
        end
        #
        context "negative degree parts" do
          subject { @mfs.homo_part(-1).terms }
          it { is_expected.to eq [Zero] }
        end
        #
      end
      #
      context "for more than one argument" do
        context "degree-(0..2) part" do
          subject { @mfs.homo_part(0..2).to_s }
          it { is_expected.to eq '29-a+M+1' }
        end
        #
        context "(degree-0,2, and 5) part" do
          subject { @mfs.homo_part(1,2,4).to_s }
          it { is_expected.to eq '-a-10oLfP+M'  }
        end
        #
        context "(degree-0 and higher than 3) part" do
          subject { @mfs.homo_part(0,3..@mfs.degree).to_s }
          it { is_expected.to eq '29+3DVe-10oLfP-2bAc+1' }
        end
        #
      end
    end
  end
  #------------------------------------

  #------------------------------------
  describe "#simplify, #simplify!" do
    context "#simplify for a FormalSum" do
      before { @fs = FormalSum.new('a-b+a') }
      it "should not change the original" do
        expect { @fs.simplify }.not_to change{@fs.terms }
      end
    end
    #
    context "for a FormalSum 'a-b+a'" do
      subject { FormalSum.new('a-b+a').simplify.show }
      it { is_expected.to eq '(2)a+(-1)b' }
    end
    #
    context "for a FormalSum '3b+2Bc+1+a-2Bc+a+3aCb-6b-9-5aCb+5b'" do
      subject { FormalSum.new('3b+2Bc+1+a-2Bc+a+3aCb-6b-9-5aCb+5b').simplify.to_s }
      it { is_expected.to eq '-8+2a+2b-2aCb' }
    end
    #
    context "#simplify! for a FormalSum" do
      before { @fs = FormalSum.new('a-b+a') }
      it "should change the original" do
        expect { @fs.simplify! }.to change{ @fs.terms }
      end
    end
  end
  #------------------------------------

  #------------------------------------
  describe "private and protected methods" do
    before(:all){ @fs = FormalSum.new('1+a+ab-2Abc')}
    #
    context "#<<" do
      it { expect{ @fs << Term.new('b') }.to raise_error(NoMethodError) }
    end
    #
    context "#str2terms" do
      it { expect{ @fs.str2terms('-8+2a+2b-2aCb') }.to raise_error(NoMethodError) }
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
