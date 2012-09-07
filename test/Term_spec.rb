#
# Term_spec.rb
#
# Time-stamp: <2012-09-07 18:29:31 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('Term.rb')

#--------------------------------------------
describe Term, "when initialized in the right manner" do
  context "with a String 'aBcdE' and an Integer 3" do
    before { @mt = Term.new('aBcdE',3) }
    it "should have two var's, a Word @word and an Fixnum @coeff" do
      [@mt.word, @mt.coeff].should == ['aBcdE',3]
      [@mt.word.kind_of?(Word), @mt.coeff.kind_of?(Fixnum)].should == [true, true]
    end
  end
#
  context "with a String 'aBcdE' only" do
    before { @mt = Term.new('aBcdE')}
    it { [@mt.word, @mt.coeff].should == ['aBcdE',1] }
  end
#
  context "with a negative Integer -6" do
    before { @mt = Term.new('aBcdE', -6)}
    it { [@mt.word, @mt.coeff].should == ['aBcdE',-6] }
  end
#
  context "with the String '1'" do
    before { @mt = Term.new('1')}
    it { [@mt.word, @mt.coeff].should == ['1',1]}
  end
#
  context "with the String '1' and the Integer 8" do
    before { @mt = Term.new('1',8)}
    it { [@mt.word, @mt.coeff].should == ['1',8]}
  end
#
  context "with the String 'aBc' and the zero" do
    before { @mt = Term.new('aBc',0)}
    it { [@mt.word, @mt.coeff].should == ['aBc',0]}
  end
#    
  context "with the contractible String 'aAB1c'" do
    before { @mt = Term.new('aAB1c')}
    it { [@mt.word, @mt.coeff].should == ['aAB1c',1]}
  end
#    
  context "with leading two valid arguments and the rest, which will be omitted" do
    it { expect{ Term.new('kLSt', 10, 'wouocei',  7, nil) }.not_to raise_error}
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "when initialized in the wrong manner" do
  context "with no arguments" do
    it { expect{ Term.new }.to raise_error{Term::InvalidArgument} }
  end
#
  context "with bad String arguments, '&','0' and ' '(space)," do
    ['&','0',' '].each do |c| 
      it { expect{ Term.new(c) }.to raise_error{Term::InvalidArgument} }
    end
  end
#
  context "with non-String arguments, 5 and a Term," do
    [5, Term.new('a')].each do |o| 
      it { expect{ Term.new(o) }.to raise_error{Term::InvalidArgument} }
    end
  end
#
  context "with a wrong secound argument" do
    it { expect{ Term.new('aBc', '4') }.to raise_error{Term::InvalidArgument} }
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#coeff=" do
  before(:all){ @t = Term.new('tErm')}
#
  context "with an Integer" do
    it { expect{ @t.coeff = 6 }.to change{ @t.coeff }.from(1).to(6) }
  end
#
  context "with wrong arguments" do
    it "should raise IvalidArgument Error" do
      ['a', [1,2,3], 1..6, 0.58].each do |badarg|
        expect{ @t.coeff = badarg }.to raise_error{Term::InvalidArgument}
      end
    end
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#to_s" do
  context "for normal Terms" do
    it { Term.new('aBcdE',3).to_s.should == '3aBcdE'}
    it { Term.new('aBcdE',2301).to_s.should == '2301aBcdE'}
  end
#
  context "for the Term 'aBcdE'" do
    subject{ Term.new('aBcdE').to_s}
    it { should == 'aBcdE' }
  end
#
  context "for the Term '-6aBcdE'" do
    subject{ Term.new('aBcdE',-6).to_s}
    it { should == '-6aBcdE' }
  end
#
  context "for the Term '1'" do
    subject{ Term.new('1').to_s}
    it { should == '1'}
  end
#
  context "with the String '1' and the Integer 8" do
    subject{ Term.new('1',8).to_s}
    it { should == '8'}
  end
#
  context "with the String '1' and the Integer -120" do
    subject{ Term.new('1',-120).to_s}
    it { should == '-120'}
  end
#
  context "with the String 'aBc' and the zero" do
    subject{ Term.new('aBc',0).to_s}
    it { should == '0'}
  end
#    
  context "with the contractible String 'aAB1c'" do
    subject{ Term.new('aAB1c').to_s}
    it { should == 'aAB1c'}
  end
#    
end

#--------------------------------------------
describe Term, "comparisons" do
  before :all do
    @term_1 = Term.new('aBc')
    @term_2 = @term_1.dup
    @term_3 = Term.new(@term_1.word, 9)
    @term_4 = Term.new('1')
  end
#
  context "==" do
    it "should compare both @word and @coeff" do
      (@term_1 == @term_2).should be_true
      (@term_1 == @term_3).should_not be_true
      (@term_1 == @term_4).should_not be_true
    end
  end
#
  context "=~" do
    it "should compare @word only" do
      (@term_1 =~ @term_2).should be_true
      (@term_1 =~ @term_3).should be_true
      (@term_1 =~ @term_4).should_not be_true
    end
  end
#
  context "when the argument is not of Term class" do
    it { expect { @term_1 == 'aBc' }.to raise_error(Term::InvalidArgument) }
  end
#
end

#--------------------------------------------
describe Term, "product of '5yAM'" do
  before(:all){ @term = Term.new('yAM', 5) }
#
  context "and another Term" do
    it "should yield a new Term and keep the original clean" do
      expect{ (@term*Term.new('RyO',3))}.not_to change{@term}
    end
  end
#
  context "and '-2RyO'" do
    subject { (@term*Term.new('RyO',-2)).to_s }
    it { should == "-10yAMRyO" }
  end
#
  context "and '-maY'" do
    subject { (@term*Term.new('maY',-1)).to_s }
    it { should == "-5yAMmaY" }
  end
#
  context "and '1'" do
    subject { (@term*Term.new('1')).to_s }
    it { should == "5yAM" }
  end
#
  context "and '100'" do
    subject { (@term*Term.new('1',100)).to_s }
    it { should == "500yAM" }
  end
#
  context "and a Term with coeff '0'" do
    before { @zero_term = @term*Term.new('RyO',0)}
#
    it { @zero_term.to_s.should == "0" }
#
    it "should keep @word information" do
      @zero_term.word.should == "yAMRyO"
    end
  end
#
  context "and an Integer (i.e. the scaler multiplication)" do
    it "should yield a new Term and keep the original clean" do
      expect{ @term*2 }.not_to change{@term.coeff}
    end
#
    it "should multiply @coeff by the Integer" do
      [0, 1, 2, -3, 10].each do |int|
        (@term*int).coeff.should == (@term.coeff)*int
      end
    end
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#sign and related methods" do
  before(:all){ @t = Term.new('Abc', 7) }
#
  context "The sign of Term('Abc',7)" do
    subject { @t.sign }
    it { should == '+'}
  end
#
  context "The sign of Term('Abc',7)*Term('1',-1)" do
    subject { (@t*Term.new('1',-1)).sign }
    it { should == '-'}
  end
#
  context "#positive?" do
    subject { @t.positive? }
    it { should be_true }
  end
#
  context "#negative?" do
    subject { @t.negative? }
    it { should_not be_true }
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#contract" do
  context "for '-3abBc'" do
    subject{ Term.new('abBc', -3).contract.to_s }
    it { should == '-3ac' }
  end
#
  context "for '20abBA'" do
    subject{ Term.new('abBA', 20).contract.to_s }
    it { should == '20' }
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#degree" do
  context "of '-4Abc'" do
    subject { Term.new('Abc', -4).degree }
    it { should == 3 }
  end
#
  context "of '10AbcCB'" do
    subject { Term.new('AbcCB', 10).degree }
    it { should == 1 }
  end
#
  context "of '-4bcCB'" do
    subject { Term.new('bcCB', -4).degree }
    it { should == 0 }
  end
#
end
#--------------------------------------------

# #--------------------------------------------
# describe Term, "" do
#   context "" do
#     it { }
#   end
# end
# #--------------------------------------------

#----------
#End of File
