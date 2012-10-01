#
# Generator_spec.rb
#
# Time-stamp: <2012-10-01 11:14:35 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('Generator')

describe Generator do

#---------------------------------------
describe "when initialized" do
  context "with a single letter 'g'" do
    it "should be a Generator 'g'" do
      (Generator.new('g').to_c).should == 'g'
    end
  end
#
  context "with bad letters '&','2' and ' '(space)" do
    ['&','2',' '].each do |c|
      it { expect{ Generator.new(c) }.to raise_error(Generator::InvalidLetter) }
    end
  end
#
  context "with no argument" do
    it { Generator.new.to_c.should == '1'}
  end
#
end
#---------------------------------------

#---------------------------------------
describe "#set" do
  before { @gen = Generator.new('g') }
#
  context "with another letter" do
    it "should change the original letter" do
      expect{ @gen.set('x') }.to change{@gen.to_c}.from('g').to('x')
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
    @gen_1 = Generator.new('g') 
    @gen_2 = @gen_1.dup
    @gen_3 = @gen_2.dup.inverse
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
  before(:all){ @letter = 'g'}
#
  it "should be false for a downcase letter" do
    Generator.new(@letter).should_not be_inverse
  end
#
  it "should be true for an uppercase letter" do
    Generator.new(@letter.upcase).should be_inverse
  end
#
  it "should be nil for the generator '1'" do
    (Generator.new.inverse?).should be_nil
  end
#
end  
#---------------------------------------

#---------------------------------------
describe "#inverse" do
  before(:all){ @gen = Generator.new('g') }
#
  context "with no arguments" do
    it "should change inverseness of a normal Generator" do 
      expect { @gen.inverse }.to change{@gen.inverse?}.from(false).to(true)
    end
#
    it { (@gen.to_c =~ /[A-Z]/).should be_true }
#
    it "should change inverseness of '1'" do 
      @gen.set('1')
      expect { @gen.inverse }.not_to change{@gen.inverse?}
    end
#
  end
# 
  context "with an integer" do
    before(:all){ @gen.set('g') }
#
    it { expect { @gen.inverse(0) }.not_to change{@gen.inverse?} }
    it { expect { @gen.inverse(3) }.to change{@gen.inverse?} }
    it { expect { @gen.inverse(4) }.not_to change{@gen.inverse?} }
  end
#
end
#---------------------------------------

#---------------------------------------
describe "#* (multiplication)" do
  before do
    @gen = Generator.new('g')
    @another = Generator.new('S')
    @one = Generator.new
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
  context "of a genarator with '1'" do
    it { (@gen*@one).should == @gen }
  end
#
  context "of '1' with a genarator" do
    it "should be the same object to the former '1'" do
      expect{ @one*@gen }.not_to change{@one.object_id} 
    end
#
    it { (@one*@gen == @gen ).should be_true }
  end
#
end  
#---------------------------------------

end
#End of File
