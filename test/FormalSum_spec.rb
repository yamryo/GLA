#
# GLA/test/FormalSum_spec.rb
#
# Time-stamp: <2014-03-14 18:51:24 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-byebug')

require('FormalSum.rb')

Zero = FormalSum::Zero
One = FormalSum::One

share_examples_for 'Should be Zero' do
  it { should == Zero }
end

describe FormalSum do 

  #------------------------------------
  describe "when initialized" do
    #
    context "with a Term" do
      before do
        @trm = Term.new('-5wojCSisA')
        @fs = FormalSum.new(@trm)
      end
      #
      it "should equip an Array of a single Term" do
        @fs.terms.should be_kind_of(Array)
        @fs.terms.should == [@trm]
      end
      #
      context "with the Zero" do
        it "should equip an Array of a single Zero" do
          zerofs = FormalSum.new(Zero)
          zerofs.terms.should be_kind_of(Array)
          zerofs.terms.should == [Zero]
        end 
      end
      #
    end
    # 
    context "without arguments" do
      subject { @fs = FormalSum.new.terms }
      it { should == [Zero] }
    end
    #
    context "with Terms" do
      before { @t = Term.new('aAB', -2)}
      #
      it "should not ignore the Zero term" do
        FormalSum.new(One, Zero, @t).terms[0].should == One
        FormalSum.new(One, Zero, @t).terms[1].should == Zero
        FormalSum.new(One, Zero, @t).terms[2].should == @t
        FormalSum.new(One, Zero, @t).terms.size.should == 3
      end
    end
    #
    context "with an Array of Terms" do
      before :all do
        @t = Term.new('2xe', -4)
        @zero = Term.new('Wiejr',0)
      end
      #
      it "should be a FormalSum of the given Terms" do
        FormalSum.new([One, @t]).terms.should == [One, @t]
      end
      #
      it "should not ignore the Zero" do
        FormalSum.new([One, Zero]).terms.should == [One, Zero]
        FormalSum.new([@zero, One, @t]).terms.should == [@zero, One, @t]
      end
    end
    #
    context "with a String" do
      before do
        @str = '2+c-B-4s'
        @arr= %w[(2)1 (1)c (-1)B (-4)s]
        @fs = FormalSum.new(@str)
        @tarr = @fs.terms
      end
      #
      it "should equip an Array of Terms" do
        (@tarr.size).times do |k|
          @tarr[k].should be_kind_of(Term)
          (@tarr[k].show).should == @arr[k]
        end
      end
      #
      it "should not ignore zero terms" do
        t = FormalSum.new('-3+6acB-a+0bKde-00+0-50')
        t.terms.join(',').should == '-3,6acB,-a,0,0,0,-50'
        (t.terms[3]) == { word: 'bKde', coeff: 0 }
      end
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#to_s" do
    context "for a FormalSum without zero terms" do
      subject { FormalSum.new('-3+6acB-a-50').to_s}
      it { should == '-3+6acB-a-50'} 
    end
    #
    context "for a FormalSum with zero terms" do
      subject { FormalSum.new('-3+6acB-a+0bKde-0+0-50').to_s}
      it { should == '-3+6acB-a-50'} 
    end
    #
    context "for a FormalSum with zero terms only" do
      subject { FormalSum.new('-0+0acB-0a+0bKde-0+0+0').to_s}
      it { should == '0'} 
    end
    #
    context "for Zero" do
      subject { FormalSum.new.to_s}
      it { should == '0'} 
    end
    #
    context "for One" do
      subject { FormalSum.new(One).to_s}
      it { should == '1'} 
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#show" do
    context "for a FormalSum without zero terms" do
      subject { FormalSum.new('-3+6acB-a-50').show}
      it { should == '(-3)1+(6)acB+(-1)a+(-50)1'} 
    end
    #
    context "for a FormalSum with zero terms" do
      subject { FormalSum.new('-3+6acB-a+0bKde-0+0-50').show}
      it { should == '(-3)1+(6)acB+(-1)a+(0)bKde+(0)1+(0)1+(-50)1'} 
    end
    #
    context "for a FormalSum with zero terms only" do
      subject { FormalSum.new('-0+0acB-0a+0bKde+0').show}
      it { should == '(0)1+(0)acB+(0)a+(0)bKde+(0)1'} 
    end
    #
    context "for Zero" do
      subject { FormalSum.new.show}
      it { should == '(0)1'} 
    end
    #
    context "for One" do
      subject { FormalSum.new(One).show}
      it { should == '(1)1'} 
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "addition" do
    before :all do
      @fs_1 = FormalSum.new('a-b')
      @fs_2 = FormalSum.new('c-3de')
      @zfs = FormalSum.new('0a-0b')
    end
    #
    context "for 'a-b' and 'c-3de'" do
      it { (@fs_1+@fs_2).to_s.should == 'a-b+c-3de' }
    end
    # 
    context "for a FormalSum and Zero" do
      it "should simply connect two Array of Terms" do
        (@fs_1+@zfs).show.should == '(1)a+(-1)b+(0)a+(0)b'
      end
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "subtraction" do
    before :all do
      @fs_1 = FormalSum.new('a-b')
      @fs_2 = FormalSum.new('c-3de')
      @zfs = FormalSum.new('0a-0b')
    end
    #
    context "of 'c-3de' from 'a-b'" do
      it { (@fs_1-@fs_2).to_s.should == 'a-b-c+3de' }
    end
    # 
    context "of a FormalSum 'a-b' from itself" do
      it "should simply connect two Array of Terms '(1)a+(-1)b+(-1)a+(1)b'" do
        (@fs_1-@fs_1).show.should == '(1)a+(-1)b+(-1)a+(1)b'
      end
      #
      context "follwed by simplification" do
        it { (@fs_1-@fs_1).simplify.show.should == '(0)a+(0)b' }
      end
    end
    #
    #
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
          (@fs.opposite.terms.map{ |t| t.sign }).should == ['-','+','-','+'] 
        end
        #
        it "should cause no change to the original" do
          expect { @fs.opposite }.not_to change{ @fs.terms } 
          expect { @fs.opposite }.not_to change{ @fs.terms.map{ |t| t.sign } } 
          expect { @fs.opposite }.not_to change{ @fs.terms.map{ |t| t[:coeff] } } 
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
  describe "#*" do
    before :all do
      @fs_1 = FormalSum.new('a-b')
      @fs_2 = FormalSum.new('c-3de')
      @zfs = FormalSum.new('0a-0b')
    end
    #
    describe "#product" do
      context "to be non-destructive" do
        it { expect { @fs_1*@fs_2 }.not_to change{ @fs_1 } }
      end
      #
      context "for 'a-b' and 'c-3de'" do
        it { (@fs_1*@fs_2).to_s.should == 'ac-3ade-bc+3bde' }
      end
      # 
      context "for a FormalSum and Zero" do
        it "should simply connect two Array of Terms" do
          (@fs_1*@zfs).show.should == '(0)aa+(0)ab+(0)ba+(0)bb'
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
        it { (@fs_1*(-2)).show.should == '(-2)a+(2)b'}
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
      it { (@fs*(-5)).show.should == '(-50)a+(50)1+(-50)bA+(1700)1+(-350)cAkK'}
      it { (@fs*(-5)).to_s.should == '-50a+50-50bA+1700-350cAkK'}
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
      it { should == '7cAkK-34+bA-1+a' }
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
      it { should == '-1+a+bA' }
    end
    #
    context "for a FormalSum 'a-1+bA+0a-0kZ'" do
      subject { (@fs+'0a-0kZ').sort.show }
      it { should == '(0)a+(0)kZ+(-1)1+(1)a+(1)bA' }
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
      it { FormalSum.new('a+bs-bS+M+1-A-0b+bsX').sort.to_s.should == '1+a-A+M+bs-bS+bsX' }
    end
    #
  end
  #------------------------------------

  #------------------------------------
  describe "#degree" do
    context "of a FormalSum '-2bA'" do
      subject { FormalSum.new('-2bA').degree }
      it { should == 2}
    end
    #
    context "of a FormalSum '1-a-2bAc+3DVe-10oLfP+M+29'" do
      subject { FormalSum.new('1-a-2bAc+3DVe-10oLfP+M+29').degree }
      it { should == 4}
    end
    #
    context "of the FormalSum One" do
      subject { FormalSum.new(One).degree }
      it { should == 0}
    end
    #
    context "of the FormalSum Zero" do
      subject { FormalSum.new(Zero).degree }
      it { should == -1.0/0.0}
    end
    #
    context "for a FormalSum '2Bc+1+a-2Bc+a+3aCb-6b+2-5aCb'" do
      subject { FormalSum.new('2Bc+1+a-2Bc+a+3aCb-6b+2-5aCb').degree }
      it { should == 3 }
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
            it { should == @marr[k] }
          end
        end
        #
        context "too big degree part" do
          subject { @mfs.homo_part(5).terms }
          it { should == [Zero] }
        end
        #
        context "negative degree parts" do
          subject { @mfs.homo_part(-1).terms }
          it { should == [Zero] }
        end
        #
      end
      #
      context "for more than one argument" do
        context "degree-(0..2) part" do
          subject { @mfs.homo_part(0..2).to_s }
          it { should == '29-a+M+1' }
        end
        #
        context "(degree-0,2, and 5) part" do
          subject { @mfs.homo_part(1,2,4).to_s }
          it { should == '-a-10oLfP+M'  }
        end
        #
        context "(degree-0 and higher than 3) part" do
          subject { @mfs.homo_part(0,3..@mfs.degree).to_s }
          it { should == '29+3DVe-10oLfP-2bAc+1' }
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
      it { should == '(2)a+(-1)b' }
    end
    #
    context "for a FormalSum '3b+2Bc+1+a-2Bc+a+3aCb-6b-9-5aCb+5b'" do
      subject { FormalSum.new('3b+2Bc+1+a-2Bc+a+3aCb-6b-9-5aCb+5b').simplify.to_s }
      it { should == '-8+2a+2b-2aCb' }
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
