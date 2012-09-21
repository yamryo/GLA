#
# LieBracket_spec.rb
#
# Time-stamp: <2012-09-20 12:22:02 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('LieBracket')

#---------------------------------
describe LieBracket, "#to_s" do
  before :all do
    @a, @b = FormalSum.new('a'), FormalSum.new('b')
    @lb = LieBracket.new(@a,@b)
  end
  #
  it { @lb.to_s.should == '[a,b]' }
  it { LieBracket.new(@a,@lb).to_s.should == '[a,[a,b]]'}
  it { LieBracket.new(@lb,@a).to_s.should == '[[a,b],a]'}
  it { LieBracket.new(@lb,@lb).to_s.should == '[[a,b],[a,b]]'}
  it { LieBracket.new(@a,5).to_s.should == '[a,5]'}
  it { LieBracket.new(-2,@lb).to_s.should == '[-2,[a,b]]'}
  it { LieBracket.new(@a, LieBracket.new(@b, @lb)).to_s.should == '[a,[b,[a,b]]]'}
end
#---------------------------------

#---------------------------------
describe LieBracket, "#expand" do
  before :all do
    a, b = FormalSum.new('a'), FormalSum.new('b')
    @a_b = LieBracket.new(a,b)
    @a_a = LieBracket.new(a,a)
    @a_ab = LieBracket.new(a,@a_b)
    @ab_a = LieBracket.new(@a_b,a)
  end
  #
  it { @a_b.expand.class.should == FormalSum}
  it { @a_b.expand.to_s.should == 'ab-ba'}
  it { @a_a.expand.to_s.should == 'aa-aa'}
  it { @a_a.expand.simplify.to_s.should == '0'}
  it { @a_ab.expand.to_s.should == 'aab-aba-aba+baa'}
  it { @ab_a.expand.to_s.should == 'aba-baa-aab+aba'}
  it { LieBracket.new(@a_b,5).expand.simplify.to_s.should == '0'}
  it { LieBracket.new(-2,@a_b).expand.simplify.to_s.should == '0'}
end
#---------------------------------

# #---------------------------------
# describe SympMagnusExp, "" do
#   context "" do
#     int { }
#   end
# end
# #---------------------------------

#End of File
