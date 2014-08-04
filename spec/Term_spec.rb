#
# GLA/test/Term_spec.rb
#
# Time-stamp: <2014-08-04 16:38:37 (ryosuke)>
require('spec_helper')

require('Term.rb')

#--------------------------------------------
describe Term do
  
  #--------------------------------------------
  describe "initialized in the right manner" do
    before :all do
      @mt_pi = Term.new('aBcdE', 3)
      @mt_ni = Term.new('aBcdE', -201)
      @mt_pr = Term.new('aBcdE', 2/5r)
      @mt_nr = Term.new('aBcdE', -8/13r)
    end
    #
    context "with no arguments" do
      let(:default){ Term.new }
      it { is_expected.to include(:word => '1', :coeff => 0) }
    end
    #
    context "is a Hash with keys, :word and :coeff" do
      it "" do
        [@mt_pi, @mt_ni, @mt_pr, @mt_nr].each do |mt|
          expect(mt).to have_key :word and have_key :coeff
          expect(mt[:word]).to be_kind_of(Word)
          expect(mt[:coeff]).to be_kind_of(Numeric)
        end
      end
    end
      #
    context "in the case of a String and an Integer" do
      it { expect(@mt_pi).to include(:word => 'aBcdE', :coeff => 3) }
      it { expect(@mt_ni).to include(:word => 'aBcdE', :coeff => -201) }
    end
      #
    context "in the case of a String and a Rational" do
      it { expect(@mt_pr).to include(:word => 'aBcdE', :coeff => 2/5r) }
      it { expect(@mt_nr).to include(:word => 'aBcdE', :coeff => -8/13r) }
    end
    #
    context "with a String only" do
      it { expect(Term.new('aBcdE')).to include(word: 'aBcdE', coeff: 1) }
    end
    #
    context "with the String '1'" do
      it { expect(Term.new('1')).to include(word: '1', coeff: 1) }
    end
      #
    context "with ('1', 8)" do
      it { expect(Term.new('1',8)).to include(word: '1', coeff: 8) }
    end
    #
    context "with a Numeric only" do
      it { expect(Term.new(0)).to include(word: '1', coeff: 0) }
      it { expect(Term.new(102)).to include(word: '1', coeff: 102) }
      it { expect(Term.new(-6)).to include(word: '1', coeff: -6) }
      it { expect(Term.new(6/97r)).to include(word: '1', coeff: 6/97r) }
      it { expect(Term.new(-103/7r)).to include(word: '1', coeff: -103/7r) }
    end
    #
    context "with a String of a Numeric" do
      it { expect(Term.new('0')).to include(word: '1', coeff: 0) }
      it { expect(Term.new('3')).to include(word: '1', coeff: 3) }
      it { expect(Term.new('-7')).to include(word: '1', coeff: -7) }
      
      it { expect(Term.new('20/51')).to include(word: '1', coeff: 20/51r) }
      it { expect(Term.new('-2/5')).to include(word: '1', coeff: -2/5r) }
    end
    #
    context "with a String of a Numeric followed by a word" do
      it { expect(Term.new('3a')).to include(word: 'a', coeff: 3) }
      it { expect(Term.new('-7KstUL')).to include(word: 'KstUL', coeff: -7) }
      it { expect(Term.new('-27/3KstUL')).to include(word: 'KstUL', coeff: -27/3r) }
    end
    #
    context "with '+' or '-' followed by a word" do
      it { expect(Term.new('+B')).to include(word: 'B', coeff: 1) }
      it { expect(Term.new('-a')).to include(word: 'a', coeff: -1) }
    end
    #
    context "with the coeff 0" do
      it { expect(Term.new('aBE',0)).to include(word: 'aBE', coeff: 0) }
    end
    #    
    context "with the contractible String 'aAB1c'" do
      subject { Term.new('aAB1c')}
      it { is_expected.to include(word: 'aAB1c', coeff: 1) }
    end
    #    
    context "with leading two valid arguments and the rest, which will be ignored" do
      it { expect{ Term.new('kLSt', 10, 'wouocei',  7, nil) }.not_to raise_error}
    end
    #
    # context "with a Hash" do
    #   subject { Term.new(word: 'aBcdE', coeff: -7) }
    #   it { is_expected.to include(word: 'aBcdE', coeff: -7) }
    # end
    #
  end
  #
  #--------------------------------------------

  #--------------------------------------------
  describe "when initialized in the wrong manner" do
    context "with bad Strings, '&',' '(space), /[+-]?\/\d+/" do
        it { expect{ Term.new('&') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('/2') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('-9/') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('+100/') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('+/50') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('-/23098') }.to raise_error{Term::InvalidArgument} }
        it { expect{ Term.new('+-3') }.to raise_error{Term::InvalidArgument} }
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
  describe "#[]=" do
    before { @t = Term.new('nbwoaZLJ', 7) }
    it "is a private method" do
      expect { @t[:word] = 'aBC' }.to raise_error
    end
    #
    it "does forbid to create new keys" do
      expect { @t[:other_key] = 'aBC' }.to raise_error
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#word=" do
    before(:all){ @t = Term.new('tErm')}
    #
    context "with a String" do
      it { expect{ @t.word = 'aBCd' }.to change{ @t[:word] }.from('tErm').to('aBCd') }
      it { @t[:word].kind_of?(Word) }
    end
    #
    context "with wrong arguments" do
      it "raises IvalidArgument Error" do
        [0, %w[1,2,3], 'a'..'Z', 0.58].each do |badarg|
          expect{ @t.word = badarg }.to raise_error{Term::InvalidArgument}
        end
      end
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#coeff=" do
    before(:all){ @t = Term.new('tErm')}
    #
    context "with an Integer" do
      it { expect{ @t.coeff = 6 }.to change{ @t[:coeff] }.from(1).to(6) }
    end
    #
    context "with wrong arguments" do
      it "raises IvalidArgument Error" do
        ['a', [1,2,3], 1..6].each do |badarg|
          expect{ @t.coeff = badarg }.to raise_error{Term::InvalidArgument}
        end
      end
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#to_s" do
    context "for normal Terms" do
      it { expect(Term.new('aBcdE',3).to_s).to eq '3aBcdE'}
      it { expect(Term.new('aBcdE',-2301).to_s).to eq '-2301aBcdE'}
    end
    #
    context "for the Term 'aBcdE'" do
      subject{ Term.new('aBcdE').to_s}
      it { is_expected.to eq 'aBcdE' }
    end
    #
    context "for the Term '-6aBcdE'" do
      subject{ Term.new('aBcdE',-6).to_s}
      it { is_expected.to eq '-6aBcdE' }
    end
    #
    context "for the Term '1'" do
      subject{ Term.new('1').to_s}
      it { is_expected.to eq '1'}
    end
    #
    context "with the String '1' and the Integer 8" do
      subject{ Term.new('1',8).to_s}
      it { is_expected.to eq '8'}
    end
    #
    context "with the String '1' and the Integer -120" do
      subject{ Term.new('1',-120).to_s}
      it { is_expected.to eq '-120'}
    end
    #
    context "with the String 'aBc' and the zero" do
      subject{ Term.new('aBc',0).to_s}
      it { is_expected.to eq '0'}
    end
    #    
    context "with the contractible String 'aAB1c'" do
      subject{ Term.new('aAB1c').to_s}
      it { is_expected.to eq 'aAB1c'}
    end
    #    
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#show" do
    context "for normal Terms" do
      it { expect(Term.new('aBcdE',3).show).to eq '(3)aBcdE'}
      it { expect(Term.new('aBcdE',-2301).show).to eq '(-2301)aBcdE'}
    end
    #
    context "for the Term 'aBcdE'" do
      subject{ Term.new('aBcdE').show}
      it { is_expected.to eq '(1)aBcdE' }
    end
    #
    context "for the Term '-6aBcdE'" do
      subject{ Term.new('aBcdE',-6).show}
      it { is_expected.to eq '(-6)aBcdE' }
    end
    #
    context "for the Term '1'" do
      subject{ Term.new('1').show}
      it { is_expected.to eq '(1)1'}
    end
    #
    context "with the String '1' and the Integer 8" do
      subject{ Term.new('1',8).show}
      it { is_expected.to eq '(8)1'}
    end
    #
    context "with the String '1' and the Integer -120" do
      subject{ Term.new('1',-120).show}
      it { is_expected.to eq '(-120)1'}
    end
    #
    context "with the String 'aBc' and the zero" do
      subject{ Term.new('aBc',0).show}
      it { is_expected.to eq '(0)aBc'}
    end
    #    
    context "with the contractible String 'aAB1c'" do
      subject{ Term.new('aAB1c').show}
      it { is_expected.to eq '(1)aAB1c'}
    end
    #    
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "comparisons" do
    before :all do
      @term_1 = Term.new('aBc')
      @term_2 = @term_1.dup
      @term_3 = Term.new(@term_1[:word], 9)
      @term_4 = Term.new('1')
    end
    #
    context "==" do
      it "examins equality as Hash" do
        expect( @term_1 == @term_2 ).to be true
        expect( @term_1 == @term_3 ).to be false
        expect( @term_1 == @term_4 ).to be false
      end
    end
    #
    context "=~" do
      it "examins equality between values of :word" do
        expect( @term_1 =~ @term_2 ).to be true
        expect( @term_1 =~ @term_3 ).to be true
        expect( @term_1 =~ @term_4 ).to be false
      end
    end
    #
    context "when the argument is not of Term class" do
      it { expect( @term_1 == 'aBc' ).to be false }
    end
    #
    context "<=>, comparing two Terms," do
      it "first in lexicographic order of :word" do
        expect(Term.new('a') <=> Term.new('a')).to be 0
        expect(Term.new('a') <=> Term.new('b')).to be -1
        expect(Term.new('b') <=> Term.new('a')).to be 1
        expect(Term.new('a') <=> Term.new('A')).to be -1
        expect(Term.new('a') <=> Term.new('B')).to be -1
        expect(Term.new('A') <=> Term.new('B')).to be -1
        expect(Term.new('ak') <=> Term.new('am')).to be -1
        expect(Term.new('aK') <=> Term.new('aM')).to be -1
        expect(Term.new('Ak') <=> Term.new('aK')).to be 1
        expect(Term.new('aK') <=> Term.new('aM',-1)).to be -1
        expect(Term.new('5aK') <=> Term.new('aKt')).to be -1
      end
      #
      it "second in the usualal order of :coeff" do
        expect(Term.new('a') <=> Term.new('a',2)).to be -1
        expect(Term.new('a',-7) <=> Term.new('a',-7)).to be 0
        expect(Term.new('a',-1) <=> Term.new('a')).to be -1
        expect(Term.new('a') <=> Term.new('a',-1)).to be 1
        expect(Term.new('-3') <=> Term.new('1')).to be -1
        expect(Term.new('0') <=> Term.new('1')).to be -1
      end
      #
    end
    #
  end

  #--------------------------------------------
  describe "#*(product) of '5yAM'" do
    before(:all){ @term = Term.new('yAM', 5) }
    #
    context "with another Term" do
      it "yields a new Term and keep the original clean" do
        expect{ (@term*Term.new('RyO',3))}.not_to change{@term}
      end
    end
    #
    context "with '-2RyO'" do
      subject { (@term*Term.new('RyO',-2)).to_s }
      it { is_expected.to eq "-10yAMRyO" }
    end
    #
    context "with '-maY'" do
      subject { (@term*Term.new('maY',-1)).to_s }
      it { is_expected.to eq "-5yAMmaY" }
    end
    #
    context "with '1'" do
      subject { (@term*Term.new('1')).to_s }
      it { is_expected.to eq "5yAM" }
    end
    #
    context "with '100'" do
      subject { (@term*Term.new('1',100)).to_s }
      it { is_expected.to eq "500yAM" }
    end
    #
    context "with a Term with coeff '0'" do
      before { @zero_term = @term*Term.new('RyO',0)}
      #
      it { expect(@zero_term.to_s).to eq "0" }
      #
      it "keeps :word information" do
        expect(@zero_term[:word]).to eq "yAMRyO"
      end
    end
  end
    #
  describe "#*(multiplied_by)" do
    before(:all){ @term = Term.new('Yam', -2) }
    #
    context "'-2Yam' by an Integer (i.e. the scaler multiplication)" do
      it "yields a new Term and keep the original clean" do
        expect{ @term*2 }.not_to change{@term[:coeff]}
        expect{ @term*(-34) }.not_to change{@term}
      end
      #
      it "multiplies @coeff" do
        [0, 1, 2, -3, 10, 203].each do |int|
          expect((@term*int)[:coeff]).to eq (@term[:coeff])*int
        end
      end
    end
    #
  end
  describe "#multiplied_by!" do
    before(:all){ @tm = Term.new('Yam', -2) }
    #
    context "'-2Yam' by an Integer" do
      it "does change self.coeff (destractive method)" do
        expect{ @tm.multiplied_by!(2) }.to change{@tm[:coeff]}
      end
      #
      it "multiplies @coeff by the Integer" do
        expect(@tm.multiplied_by!(5)[:coeff]).to eq @tm[:coeff]
      end
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#sign and related methods" do
    before(:each){ @t = Term.new('Abc', 7) }
    #
    context "The sign of Term('Abc',7)" do
      subject { @t.sign }
      it { is_expected.to eq '+'}
    end
    #
    context "#positive? or #negative?" do
      subject { @t }
      it { is_expected.to be_positive }
      it { is_expected.not_to be_negative }
    end
    #
    context "#opposite" do
      it { expect { @t.opposite }.to change{ @t.sign } }
      it { expect { @t.opposite }.to change{ @t[:coeff] }.from(7).to(-7) }
    end
    #
    context "The sign of Zero" do
      subject { Term.new.sign }
      it { is_expected.to be_nil }
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#contract" do
    context "for the Term '-3abBc'" do
      subject{ Term.new('abBc', -3).contract }
      it { is_expected.to include(word: 'ac', coeff: -3) }
    end
    #
    # context "for the Term '20abBA'" do
    #   subject{ Term.new('abBA', 20).contract }
    #   it { is_expected.to include(word: '1', coeff: 20) }
    # end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#degree" do
    context "of the Term '-4Abc'" do
      subject { Term.new('Abc', -4).degree }
      it { is_expected.to eq 3 }
    end
    #
    context "of the Term '10AbcCB'" do
      subject { Term.new('AbcCB', 10).degree }
      it { is_expected.to eq 1 }
    end
    #
    context "of the Term '-4bcCB'" do
      subject { Term.new('bcCB', -4).degree }
      it { is_expected.to eq 0 }
    end
    #
    context "of the Term '5'" do
      subject { Term.new('1', 5).degree }
      it { is_expected.to eq 0 }
    end
    #
    context "of the Term '0'" do
      subject { Term.new('1', 0).degree }
      it { is_expected.to eq -1/0.0 }
    end
    #
  end
  #--------------------------------------------

  # #--------------------------------------------
  # describe "" do
  #   context "" do
  #     it { }
  #   end
  # end
  # #--------------------------------------------

end
#----------
#End of File
