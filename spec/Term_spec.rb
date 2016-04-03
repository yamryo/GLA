#
# GLA/test/Term_spec.rb
#
# Time-stamp: <2016-04-03 21:48:58 (ryosuke)>
require('spec_helper')

require('Term.rb')

#--------------------------------------------
describe Term do
  let(:default) { Term.new }
  let(:mt) { Term.new(str, cof) }
  #--------------------------------------------
  describe "Constants" do
    context "RgxScalar" do
      subject { Term::RgxScalar }
      it{ is_expected.to be_kind_of Regexp }
    end
  end
  #--------------------------------------------
  describe "Errors" do
    context "InvalidArgument" do
      it { expect{Term::InvalidArgument}.not_to raise_error(NameError) }
    end
  end
  #--------------------------------------------
  describe "creating" do
    shared_examples "a Hash with keys :word and :coeff" do
      it { is_expected.to match(:word => be_kind_of(Word),
                                :coeff => be_kind_of(Numeric)) }
    end
    #-----
    context "with no arguments" do
      subject{ default }
      it { is_expected.to include(:word => '1', :coeff => 1) }
      it_behaves_like "a Hash with keys :word and :coeff"
    end
    #-----
    context "with two arguments" do
      subject{ mt }
      #-----
      context "when a String and an Integer are given" do
        [{s: 'aBcdE', n: 3}, {s: 'FGhiJk', n: -201}].each do |h|
          let(:str) { h[:s] }
          let(:cof) { h[:n] }
          it {is_expected.to include(:word => str, :coeff => cof) }
          it_behaves_like "a Hash with keys :word and :coeff"
        end
      end
      context "when a String and a Rational are given" do
        [{s: 'aBcdE', n: 2/5r}, {s: 'FGhiJk', n: -805/13r}].each do |h|
          let(:str) { h[:s] }
          let(:cof) { h[:n] }
          it {is_expected.to include(:word => str, :coeff => cof) }
          it_behaves_like "a Hash with keys :word and :coeff"
        end
      end
      context "when ('1', 8) is given" do
          let(:str) { '1' }
          let(:cof) { 8 }
          it {is_expected.to include(:word => str, :coeff => cof) }
          it_behaves_like "a Hash with keys :word and :coeff"
          #it { expect(Term.new('1',8)).to include(word: '1', coeff: 8) }
      end
    end
    #-----
    context "with a single argument" do
      let(:mt_one) { Term.new(an_arg) }
      subject { mt_one }
      context "when only a String is given" do
        let(:an_arg) { 'aBcdE' }
        it {is_expected.to include(word: an_arg, coeff: 1) }
        it_behaves_like "a Hash with keys :word and :coeff"
      end
      context "when the String '1' is given" do
        let(:an_arg) { '1' }
        it {is_expected.to include(word: an_arg, coeff: 1) }
        it_behaves_like "a Hash with keys :word and :coeff"
      end
      context "when only a Numeric is given" do
        [0, 102, -6, 6/97r, -103/7r].each do |num|
          let(:an_arg) { num }
          it { is_expected.to include(word: '1', coeff: an_arg) }
          it_behaves_like "a Hash with keys :word and :coeff"
        end
      end
      #
      context "when a String of a Numeric is given" do
        [0, 102, -6, 6/97r, -103/7r].each do |num|
          let(:an_arg) { num.to_s }
          it { is_expected.to include(word: '1', coeff: an_arg.to_r) }
          it_behaves_like "a Hash with keys :word and :coeff"
        end
      end
      #
      context "when a String of a Numeric followed by a word is given" do
        context "3a" do
          let(:an_arg) { "3a" }
          it { is_expected.to include(word: 'a', coeff: 3) }
          it_behaves_like "a Hash with keys :word and :coeff"
        end
        context "-27/3KstUL" do
          let(:an_arg) { "-27/3KstUL" }
          it { is_expected.to include(word: 'KstUL', coeff: -27/3r) }
          it_behaves_like "a Hash with keys :word and :coeff"
        end
      end
      #
      context "when '+' or '-' followed by a word is given" do
        it "'+Bc'" do
          expect(Term.new('+Bc')).to include(word: 'Bc', coeff: 1)
        end
        it "'-aKt'" do
          expect(Term.new('-aKt')).to include(word: 'aKt', coeff: -1)
        end
      end
      #
      context "when a word with the coeff 0 is given" do
        it { expect(Term.new('aBE',0)).to include(word: 'aBE', coeff: 0) }
      end
      #
      context "when the contractible String 'aAB1c' is given" do
        let(:an_arg) { 'aAB1c' }
        subject { mt_one}
        it { is_expected.to include(word: an_arg, coeff: 1) }
      end
      #
    end
    #-----
    context "with more than two arguments" do
      subject { lambda { Term.new('kLSt', 10, 'wouocei',  7, nil) } }
      it { is_expected.not_to raise_error }
    end
    #-----
    context "with a wrong second argument" do
      subject { lambda { Term.new('aBc', '4') } }
      it "ignores the second" do
        is_expected.not_to raise_error(Term::InvalidArgument)
      end
    end
    #-----
    xcontext "with a Hash" do
      subject { Term.new(word: 'aBcdE', coeff: -7) }
      it { is_expected.to include(word: 'aBcdE', coeff: -7) }
    end
    #-----
    context "with bad arguments" do
      let(:mt_one) { Term.new( an_arg ) }
      context "Strings, '&',' '(space), /[+-]?\/\d+/" do
        bad_strs = ['&', ' ', '/2', '-9/', '+100', '+/50', '-/23098', '+-3']
        bad_strs.each do |bs|
          let(:an_arg) { bs }
          subject { lambda { mt_one } }
          it { is_expected.to raise_error(Word::InvalidArgument) }
        end
      end
      #-----
      context "with Array, Range and Term arguments" do
        data = [[5,1,4], 1..9, 'a'..'Z', Term.new('a')]
        data.each do |o|
          let(:an_arg) { o }
          subject { lambda { mt_one } }
          it { is_expected.to raise_error(Term::InvalidArgument) }
        end
      end
    end
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#[]=" do
    let(:mt) { Term.new('nbwoaZLJ', 7) }
    it "is a private method" do
      expect { mt[:word] = 'aBC' }.to raise_error(NoMethodError)
    end
    #
    it "forbids to create new keys" do
      expect { mt[:other_key] = 'aBC' }.to raise_error(NoMethodError)
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#word=" do
    let(:mt) { Term.new('tErm') }
    #
    context "with a String" do
      it { expect{ mt.word = 'aBCd' }.to change{ mt[:word] }.from('tErm').to('aBCd') }
      it { mt[:word].kind_of?(Word) }
    end
    #
    context "with wrong arguments" do
      it "raises IvalidArgument Error" do
        [0, %w[1,2,3], 'a'..'Z', 0.58].each do |badarg|
          expect{ mt.word = badarg }.to raise_error{Term::InvalidArgument}
        end
      end
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#coeff=" do
    let(:mt){ mt = Term.new('tErm')}
    #
    context "with an Integer" do
      it { expect{ mt.coeff = 6 }.to change{ mt[:coeff] }.from(1).to(6) }
    end
    #
    context "with wrong arguments" do
      it "raises IvalidArgument Error" do
        ['a', [1,2,3], 1..6].each do |badarg|
          expect{ mt.coeff = badarg }.to raise_error{Term::InvalidArgument}
        end
      end
    end
    #
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#to_s" do
    context "for normal Terms" do
      let(:mt) { Term.new('aBcdE', cf) }
      #-----
      context "with a positive coefficient" do
        let(:cf)  { 3 }
        subject { mt.to_s }
        it { is_expected.to eq '3aBcdE'}
      end
      context "with a negative coefficient" do
        let(:cf)  { -2301 }
        subject { mt.to_s }
        it { is_expected.to eq '-2301aBcdE'}
      end
      context "with coefficient 1" do
        let(:cf)  { 1 }
        subject { mt.to_s }
        it { is_expected.to eq 'aBcdE' }
      end
      context "with coefficient -1" do
        let(:cf)  { -1 }
        subject { mt.to_s }
        it { is_expected.to eq '-aBcdE' }
      end
      context "with coefficient 0" do
        let(:cf)  { 0 }
        subject { mt.to_s }
        it { is_expected.to eq '0'}
      end
    end
    #-----
    context "for Terms of the word '1'" do
      let(:one) { Term.new('1', cf) }
      #-----
      context "with coefficient 1" do
        let(:cf) { 1 }
        subject { one.to_s }
        it { is_expected.to eq '1'}
      end
      context "with coefficient Integer 8" do
        let(:cf) { 8 }
        subject { one.to_s }
        it { is_expected.to eq '8'}
      end
      context "with coefficient Integer -120" do
        let(:cf) { -120 }
        subject { one.to_s }
        it { is_expected.to eq '-120'}
      end
      context "with coefficient Rational 1/3" do
        let(:cf) { 1/3r }
        subject { one.to_s }
        it { is_expected.to eq '1/3'}
      end
      context "with coefficient Rational -131/120" do
        let(:cf) { -131/120r }
        subject { one.to_s }
        it { is_expected.to eq '-131/120'}
      end
    end
    #-----
    context "with the contractible String 'aAB1c'" do
      subject{ Term.new('aAB1c').to_s}
      it { is_expected.to eq 'aAB1c'}
    end
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#show" do
    context "for normal Terms" do
      let(:mt) { Term.new('aBcdE', cf) }
      #-----
      context "with a positive coefficient" do
        let(:cf)  { 3 }
        subject { mt.show }
        it { is_expected.to eq '(3)aBcdE'}
      end
      context "with a negative coefficient" do
        let(:cf)  { -2301 }
        subject { mt.show }
        it { is_expected.to eq '(-2301)aBcdE'}
      end
      context "with coefficient 1" do
        let(:cf)  { 1 }
        subject { mt.show }
        it { is_expected.to eq '(1)aBcdE' }
      end
      context "with coefficient -1" do
        let(:cf)  { -1 }
        subject { mt.show }
        it { is_expected.to eq '(-1)aBcdE' }
      end
      context "with coefficient 0" do
        let(:cf)  { 0 }
        subject { mt.show }
        it { is_expected.to eq '(0)aBcdE' }
      end
    end
    #-----
    context "for Terms of the word '1'" do
      let(:one) { Term.new('1', cf) }
      #-----
      context "with coefficient 1" do
        let(:cf) { 1 }
        subject { one.show }
        it { is_expected.to eq '(1)1'}
      end
      context "with coefficient Integer 8" do
        let(:cf) { 8 }
        subject { one.show }
        it { is_expected.to eq '(8)1'}
      end
      context "with coefficient Integer -120" do
        let(:cf) { -120 }
        subject { one.show }
        it { is_expected.to eq '(-120)1'}
      end
      context "with coefficient Rational 1/3" do
        let(:cf) { 1/3r }
        subject { one.show }
        it { is_expected.to eq '(1/3)1'}
      end
      context "with coefficient Rational -131/120" do
        let(:cf) { -131/120r }
        subject { one.show }
        it { is_expected.to eq '(-131/120)1'}
      end
    end
    #-----
    context "with the contractible String 'aAB1c'" do
      subject{ Term.new('aAB1c').show}
      it { is_expected.to eq '(1)aAB1c'}
    end
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
    let(:mt) { Term.new('yAM', 5) }
    #
    context "with another Term" do
      it "yields a new Term and keep the original clean" do
        expect{ (mt*Term.new('RyO',3))}.not_to change{mt}
      end
    end
    #
    context "with '-2RyO'" do
      subject { (mt*Term.new('RyO',-2)).to_s }
      it { is_expected.to eq "-10yAMRyO" }
    end
    #
    context "with '-maY'" do
      subject { (mt*Term.new('maY',-1)).to_s }
      it { is_expected.to eq "-5yAMmaY" }
    end
    #
    context "with '1'" do
      subject { (mt*Term.new('1')).to_s }
      it { is_expected.to eq "5yAM" }
    end
    #
    context "with '100'" do
      subject { (mt*Term.new('1',100)).to_s }
      it { is_expected.to eq "500yAM" }
    end
    #
    context "with a Term with coeff '0'" do
      subject { mt*Term.new('RyO',0) }
      it "combine words ant change coeff to 0" do
        is_expected.to include(:word => 'yAMRyO') & include(:coeff => 0)
      end
    end
  end

  #--------------------------------------------
  describe "#*(multiplied_by)" do
    let(:mt) { Term.new('Yam', -2) }
    #-----
    context "'-2Yam' by an Integer (i.e. the scaler multiplication)" do
      it "yields a new Term and keep the original clean" do
        expect{ mt*2 }.not_to change{mt[:coeff]}
        expect{ mt*(-34) }.not_to change{mt}
      end
      it "multiplies @coeff" do
        [0, 1, 2, -3, 10, 203].each do |int|
          expect((mt*int)[:coeff]).to eq (mt[:coeff])*int
        end
      end
    end
  end
  #-----
  describe "#multiplied_by!" do
    let(:mt) { Term.new('Yam', -2) }
    #-----
    context "'-2Yam' by an Integer" do
      it "does change self.coeff (destractive method)" do
        expect{ mt.multiplied_by!(2) }.to change{mt[:coeff]}
      end
      it "multiplies @coeff by the Integer" do
        expect(mt.multiplied_by!(5)[:coeff]).to eq mt[:coeff]
      end
    end
  end
  #--------------------------------------------

  #--------------------------------------------
  describe "#sign and related methods" do
    let(:mt) { Term.new('Abc', 7) }
    #
    context "The sign of Term('Abc',7)" do
      subject { mt.sign }
      it { is_expected.to eq '+'}
    end
    #
    context "#positive? or #negative?" do
      subject { mt }
      it { is_expected.to be_positive }
      it { is_expected.not_to be_negative }
    end
    #
    context "#opposite" do
      it { expect { mt.opposite }.to change{ mt.sign } }
      it { expect { mt.opposite }.to change{ mt[:coeff] }.from(7).to(-7) }
    end
    #
    xcontext "The sign of Zero" do
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
