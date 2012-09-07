#
# test_Generator.rb
#
# Time-stamp: <2012-09-07 13:26:24 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('Generator')

#---------------------------------------
describe Generator, "when initialized" do
  context "with a single letter 'g'" do
    it "should be a Generator 'g'" do
      (Generator.new('g').to_c).should == 'g'
    end
  end
#
  context "with bad letters '&','2' and ' '(space)" do
    it { expect{ Generator.new('&') }.to raise_error(Generator::InvalidLetter) }
    it { expect{ Generator.new('2') }.to raise_error(Generator::InvalidLetter) }
    it { expect{ Generator.new(' ') }.to raise_error(Generator::InvalidLetter) }
  end
#
  context "with no argument" do
    it { Generator.new.to_c.should == '1'}
  end
#
end
#---------------------------------------

#---------------------------------------
describe Generator, "#set" do
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
    it { expect{ @gen.set('@') }.to raise_error(Generator::InvalidLetter) }
  end
#
end  
#---------------------------------------

#---------------------------------------
describe Generator, "comparisons" do
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
      (@gen_1 =~ @gen_4).should be_false
    end
  end
#
  context "==, the normal comparing," do
    it "should return true iff the letters and inverseness coinside" do
      (@gen_1 == @gen_2).should be_true
      (@gen_1 == @gen_3).should be_false
      (@gen_1 == @gen_4).should be_false
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
describe Generator, "#inverse?" do
  before(:all){ @letter = 'g'}
#
  it "should be false for a downcase letter" do
    (Generator.new(@letter).inverse?).should be_false
  end
#
  it "should be true for an uppercase letter" do
    (Generator.new(@letter.upcase).inverse?).should be_true
  end
#
  it "should be false for the generator '1'" do
    (Generator.new.inverse?).should be_false
  end
#
end  
#---------------------------------------

#---------------------------------------
describe Generator, "#inverse" do
  before :all do 
    @gen = Generator.new('g')
    @initial = @gen.inverse?
  end
#
  context "with no arguments" do
    it { (@gen.inverse.to_c =~ /[A-Z]/).should be_true }
    it "should change inverseness of itself" do 
      @gen.inverse?.should_not == @initial
    end
  end
# 
  context "with a given integer" do
    it { (@gen.dup.inverse(3).inverse?).should_not ==  @gen.inverse? }
    it { (@gen.dup.inverse(4).inverse?).should ==  @gen.inverse? }
  end
#
end
#---------------------------------------

#---------------------------------------
describe Generator, "#* (multiplication)" do
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

#End of File
