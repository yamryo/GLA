#
# GLA/test/Generator_spec.rb
#
# Time-stamp: <2014-03-17 09:21:06 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-byebug')

require('Generator')

describe Generator do
  #
  before :all do
    @gen = Generator.new('g')
    @identity = Generator.new
  end
  
#---------------------------------------
describe "#initialize" do
    context "with a single letter 'g'" do
      it { (@gen.to_char).should == 'g' }
  end
#
  context "with bad letters '&','2' and ' '(space)" do
    ['&','2',' '].each do |c|
      it { expect{ Generator.new(c) }.to raise_error(Generator::InvalidLetter) }
    end
  end
#
  context "with no argument" do
    it { @identity.to_char.should == '1'}
  end
#
end
#---------------------------------------

#---------------------------------------
describe "#set" do
  context "with another letter" do
    it "should change the original letter" do
      expect{ @gen.set('x') }.to change{@gen.to_char}.from('g').to('x')
    end
#
    it "should not change the object id" do
      expect{ @gen.set('x') }.not_to change{ @gen.object_id }
    end
  end
#
  context "with bad letter" do
    subject{ expect{ @gen.set('@') }.to }
    it { raise_error(Generator::InvalidLetter) }
  end
#
end  
#---------------------------------------

#---------------------------------------
describe "comparisons" do
  before :all do
    @gen_1 = @gen
    @gen_2 = @gen_1.dup
    @gen_3 = @gen_2.dup.invert!
    @gen_4 = Generator.new('s')
  end
#
  context "=~, the lax conparing," do
    it "should return true iff the letters coinside" do
      (@gen_1 =~ @gen_2).should be_true
      (@gen_1 =~ @gen_3).should be_true
      (@gen_1 =~ @gen_4).should_not be_true
    end
  end
#
  context "==, the normal comparing," do
    it "should return true iff the letters and inverseness coinside" do
      (@gen_1 == @gen_2).should be_true
      (@gen_1 == @gen_3).should_not be_true
      (@gen_1 == @gen_4).should_not be_true
    end
  end
#
  context "===, the strict comparing," do
    it "should return true iff the two objects exactly coinside" do
      (@gen_1 === @gen_2).should be_false
      (@gen_1 === @gen_3).should be_false
      (@gen_1 === @gen_4).should be_false
    end
  end
#
end  
#---------------------------------------

#---------------------------------------
describe "#inverse?" do
  it "should be false for a downcase letter" do
    Generator.new('a').should_not be_inverse
  end
#
  it "should be true for an uppercase letter" do
    Generator.new('A').should be_inverse
  end
#
  it "should be nil for the generator '1'" do
    (@identity.inverse?).should be_nil
  end
#
end  
#---------------------------------------

#---------------------------------------
describe "#invert!" do
  context "with no arguments" do
    it "should change inverseness of a normal Generator" do 
      expect { @gen.invert! }.to change{@gen.inverse?}.from(false).to(true)
    end
#
    it { (@gen.to_char =~ /[A-Z]/).should be_true }
#
    it "should not change inverseness of '1'" do
      expect { @identity.invert! }.not_to change{ @identity.inverse? }
    end
#
  end
# 
  context "with an integer" do
    before(:all){ @gen.set('g') }
#
    it { expect { @gen.invert!(0) }.not_to change{@gen.inverse?} }
    it { expect { @gen.invert!(3) }.to change{@gen.inverse?} }
    it { expect { @gen.invert!(4) }.not_to change{@gen.inverse?} }
  end
#
end
#---------------------------------------

#---------------------------------------
describe "#* (product!)" do
  before do
    @another = Generator.new('S')
  end
#
  context "of two normal generators" do
    subject { @gen*@another }
#
    it "should be an array of the generators" do
      should == [@gen, @another]
    end
  end
#
  context "of a genarator 'g' and '1'" do
      it { (@gen*@identity).should == @gen }
      it { (@identity*@gen).should == @gen }
  end
#
end  
#---------------------------------------

end
#End of File
