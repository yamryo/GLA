#
# Term_spec.rb
#
# Time-stamp: <2012-09-18 02:16:02 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('Term.rb')

#--------------------------------------------
describe Term, "when initialized in the right manner" do
  #
  context "with no arguments" do
    it { Term.new.should == {word: '1', coeff: 0} }
  end
  #
  context "with a pair of a String and an Integer" do
    before(:all) { @mt = Term.new('aBcdE',3) }
    #
    it "should have be a Hash with keys, :word and :coeff" do
      @mt.keys.should == [:word, :coeff]
      @mt.should == { :word => 'aBcdE', :coeff => 3 }
    end
    #
    it "should have a value of Word class for the key :word" do
      @mt[:word].kind_of?(Word).should be_true
    end
    #
    it "should have a value of Integer class for the key :coeff" do
      @mt[:coeff].kind_of?(Integer).should be_true
    end
  end
  #
  context "with a String only" do
    subject { Term.new('aBcdE')}
    it { should == {word: 'aBcdE', coeff: 1} }
  end
  #
  context "with the String '1'" do
    context "('1',1)" do
      subject { Term.new('1') }
      it { should == {word: '1', coeff: 1} }
    end
    #
    context "('1',1)" do
      subject { Term.new('1',8) }
      it { should == {word: '1', coeff: 8} }
    end
    #
  end
  #
  context "with an Integer -6 only" do
    subject { Term.new(-6) }
    it { should == {word: '1', coeff: -6} }
  end
  #
  context "with a String of an integer" do
    it { Term.new('3').should == {word: '1', coeff: 3} }
    it { Term.new('-7').should == {word: '1', coeff: -7} }
  end
  #
  context "with a String of an integer followed by a word" do
    it { Term.new('3a').should == {word: 'a', coeff: 3} }
    it { Term.new('-7KstUL').should == {word: 'KstUL', coeff: -7} }
  end
  #
  context "with the Integer 0" do
    context "('aBE',0)" do
      subject { Term.new('aBE',0) }
      it { should == {word: 'aBE', coeff: 0} }
    end
    #
  end
  #    
  context "with the contractible String 'aAB1c'" do
    subject { Term.new('aAB1c')}
    it { should == {word: 'aAB1c', coeff: 1} }
  end
  #    
  context "with leading two valid arguments and the rest, which will be omitted" do
    it { expect{ Term.new('kLSt', 10, 'wouocei',  7, nil) }.not_to raise_error}
  end
  #
  # context "with a Hash" do
  #   subject { Term.new(word: 'aBcdE', coeff: -7) }
  #   it { should == {word: 'aBcdE', coeff: -7} }
  # end
  #
end
#
#--------------------------------------------

#--------------------------------------------
describe Term, "when initialized in the wrong manner" do
  context "with bad String arguments, '&','0' and ' '(space)," do
    ['&',' '].each do |c| 
      it { expect{ Term.new(c) }.to raise_error{Term::InvalidArgument} }
    end
  end
#
  context "with Array, Range and Term arguments" do
    [[5,1,4], 1..9, 'a'..'Z', Term.new('a')].each do |o| 
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
describe Term, "#[]=" do
  before { @t = Term.new('nbwoaZLJ', 7) }
  it "should be a private method" do
    expect { @t[:word] = 'aBC' }.to raise_error
  end
#
  it "should forbid to create new keys" do
    expect { @t[:other_key] = 'aBC' }.to raise_error
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#word=" do
  before(:all){ @t = Term.new('tErm')}
#
  context "with a String" do
    it { expect{ @t.word = 'aBCd' }.to change{ @t[:word] }.from('tErm').to('aBCd') }
    it { @t[:word].kind_of?(Word) }
  end
#
  context "with wrong arguments" do
    it "should raise IvalidArgument Error" do
      [0, %w[1,2,3], 'a'..'Z', 0.58].each do |badarg|
        expect{ @t.word = badarg }.to raise_error{Term::InvalidArgument}
      end
    end
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#coeff=" do
  before(:all){ @t = Term.new('tErm')}
#
  context "with an Integer" do
    it { expect{ @t.coeff = 6 }.to change{ @t[:coeff] }.from(1).to(6) }
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
    it { Term.new('aBcdE',-2301).to_s.should == '-2301aBcdE'}
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

#--------------------------------------------
describe Term, "#show" do
  context "for normal Terms" do
    it { Term.new('aBcdE',3).show.should == '(3)aBcdE'}
    it { Term.new('aBcdE',-2301).show.should == '(-2301)aBcdE'}
  end
#
  context "for the Term 'aBcdE'" do
    subject{ Term.new('aBcdE').show}
    it { should == '(1)aBcdE' }
  end
#
  context "for the Term '-6aBcdE'" do
    subject{ Term.new('aBcdE',-6).show}
    it { should == '(-6)aBcdE' }
  end
#
  context "for the Term '1'" do
    subject{ Term.new('1').show}
    it { should == '(1)1'}
  end
#
  context "with the String '1' and the Integer 8" do
    subject{ Term.new('1',8).show}
    it { should == '(8)1'}
  end
#
  context "with the String '1' and the Integer -120" do
    subject{ Term.new('1',-120).show}
    it { should == '(-120)1'}
  end
#
  context "with the String 'aBc' and the zero" do
    subject{ Term.new('aBc',0).show}
    it { should == '(0)aBc'}
  end
#    
  context "with the contractible String 'aAB1c'" do
    subject{ Term.new('aAB1c').show}
    it { should == '(1)aAB1c'}
  end
#    
end
#--------------------------------------------

#--------------------------------------------
describe Term, "comparisons" do
  before :all do
    @term_1 = Term.new('aBc')
    @term_2 = @term_1.dup
    @term_3 = Term.new(@term_1[:word], 9)
    @term_4 = Term.new('1')
  end
#
  context "==" do
    it "should examin equality as Hash" do
      (@term_1 == @term_2).should be_true
      (@term_1 == @term_3).should_not be_true
      (@term_1 == @term_4).should_not be_true
    end
  end
#
  context "=~" do
    it "should examin equality between values of :word" do
      (@term_1 =~ @term_2).should be_true
      (@term_1 =~ @term_3).should be_true
      (@term_1 =~ @term_4).should_not be_true
    end
  end
#
  context "when the argument is not of Term class" do
    it { (@term_1 == 'aBc').should be_false }
  end
#
  context "<=>, comparing two Terms," do
    it "first in lexicographic order of :word" do
      (Term.new('a') <=> Term.new('a')).should == 0
      (Term.new('a') <=> Term.new('b')).should == -1
      (Term.new('b') <=> Term.new('a')).should == 1
      (Term.new('a') <=> Term.new('A')).should == -1
      (Term.new('a') <=> Term.new('B')).should == -1
      (Term.new('A') <=> Term.new('B')).should == -1
      (Term.new('ak') <=> Term.new('am')).should == -1
      (Term.new('aK') <=> Term.new('aM')).should == -1
      (Term.new('Ak') <=> Term.new('aK')).should == 1
      (Term.new('aK') <=> Term.new('aM',-1)).should == -1
      (Term.new('5aK') <=> Term.new('aKt')).should == -1
    end
    #
    it "second in the usualal order of :coeff" do
      (Term.new('a') <=> Term.new('a',2)).should == -1
      (Term.new('a',-7) <=> Term.new('a',-7)).should == 0
      (Term.new('a',-1) <=> Term.new('a')).should == -1
      (Term.new('a') <=> Term.new('a',-1)).should == 1
      (Term.new('-3') <=> Term.new('1')).should == -1
      (Term.new('0') <=> Term.new('1')).should == -1
    end
    #
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
    it "should keep :word information" do
      @zero_term[:word].should == "yAMRyO"
    end
  end
#
  context "and an Integer (i.e. the scaler multiplication)" do
    it "should yield a new Term and keep the original clean" do
      expect{ @term*2 }.not_to change{@term[:coeff]}
    end
#
    it "should multiply @coeff by the Integer" do
      [0, 1, 2, -3, 10].each do |int|
        (@term*int)[:coeff].should == (@term[:coeff])*int
      end
    end
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#sign and related methods" do
  before(:each){ @t = Term.new('Abc', 7) }
#
  context "The sign of Term('Abc',7)" do
    subject { @t.sign }
    it { should == '+'}
  end
#
  context "The sign of Zero" do
    subject { Term.new.sign }
    it { should be_nil }
  end
#
  context "#positive?" do
    subject { @t.positive? }
    it { should be_true }
  end
#
  context "#negative?" do
    subject { @t.negative? }
    it { should be_false }
  end
#
  context "#opposite" do
    it { expect { @t.opposite }.to change{ @t.sign } }
    it { expect { @t.opposite }.to change{ @t[:coeff] }.from(7).to(-7) }
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#contract" do
  context "for the Term '-3abBc'" do
    subject{ Term.new('abBc', -3).contract }
    it { should == {word: 'ac', coeff: -3 } }
  end
#
  context "for the Term '20abBA'" do
    subject{ Term.new('abBA', 20).contract }
    it { should == {word: '1', coeff: 20} }
  end
#
end
#--------------------------------------------

#--------------------------------------------
describe Term, "#degree" do
  context "of the Term '-4Abc'" do
    subject { Term.new('Abc', -4).degree }
    it { should == 3 }
  end
#
  context "of the Term '10AbcCB'" do
    subject { Term.new('AbcCB', 10).degree }
    it { should == 1 }
  end
#
  context "of the Term '-4bcCB'" do
    subject { Term.new('bcCB', -4).degree }
    it { should == 0 }
  end
#
  context "of the Term '5'" do
    subject { Term.new('1', 5).degree }
    it { should == 0 }
  end
#
  context "of the Term '0'" do
    subject { Term.new('1', 0).degree }
    it { should == -1.0/0.0 }
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
