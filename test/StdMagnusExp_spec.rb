#
# StdMagnusExp_spec.rb
#
# Time-stamp: <2012-09-14 10:50:19 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('StdMagnusExp')

#---------------------------------
describe StdMagnusExp, "when initializing" do
  before { @theta_std =  StdMagnusExp }
  it { @theta_std.class.name.should == 'Module'}
end
#---------------------------------

#---------------------------------
describe StdMagnusExp, "#send" do
  before :all do
    @theta_std = StdMagnusExp
    @gen_a = Generator.new('a')
    @gen_1 = Generator.new('1')
  end
  #  
  context "return a FormalSum" do
    subject { @theta_std.expand(@gen_a).kind_of?(FormalSum) }
    it { should be_true }
  end
  #
  context "for generators" do
    context "theta_std('a')" do
      subject { @theta_std.expand(@gen_a.dup).to_s }
      it { should == '1+a'}
    end
    #
    context "theta_std('A')" do
      subject { @theta_std.expand(@gen_a.inverse).to_s }
      it { should == '1-a+aa-aaa'}
    end
    #
    context "theta_std('1')" do
      subject { @theta_std.expand(@gen_1).to_s }
      it { should == '1'}
    end
  end
  #
  context "theta_std('ab')" do
    # theta_std('ab') = (1+a)(1+b) = 1+a+b+ab
    subject { @theta_std.expand(Word.new('ab')).to_s }
    it { should == '1+a+b+ab'}
  end
  #
  context "theta_std('aA')" do
    subject { @theta_std.expand(Word.new('aA')).to_s }
    it { should == '1'}
  end
  #
  context "theta_std('abA')" do
    # theta_std('aBA') = (1+a)(1+b)(1-a+aa-aaa) = 1+b+ab-ba-aba+baa-aaaa+abaa-baaa-abaaa
    subject { @theta_std.expand(Word.new('abA')).to_s }
    it { should == '1+b+ab-ba-aba+baa-aaaa+abaa-baaa-abaaa'}
  end
  #
  context "degree 0 to 2 parts of theta_std('abAB')" do
    # theta_std('abAB') = 1+a(0+b(-A+A(0))) = 1+a0+ab(-A)+abA0 = 1-abA
    subject do 
      pdt = @theta_std.expand(Word.new('abAB'))
      pdt.homo_part(0..2).sort.to_s 
    end
    it { should == '1+ab-ba'}
  end
  # #
  # context "theta_std('Bab')" do
  #   # theta_std('Bab') = B(1+a(0)) = B
  #   subject { @theta_std.expand(Word.new('Bab')).to_s }
  #   it { should == 'B'}
  # end
  # #
  # context "theta_std('Aba')" do
  #   # theta_std('Aba') = -A+A(0+b(1)) = -A+b
  #   subject { @theta_std.expand(Word.new('Aba')).to_s }
  #   it { should == '-A+Ab'}
  # end
  # #
  # context "theta_std('bAcaBACBa')" do
  #   # theta_std('bAcaBACBa') = 0+b(-A+A(0+c(1+a(0+B(-A+A(0+C(0+B(1)..) 
  #   #                             = b(-A)+bAc1+bAcaB(-A)+bAcaBACB 
  #   #                             = -bA+bAc-bAcaBA+bAcaBACB
  #   subject { @theta_std.expand(Word.new('bAcaBACBa')).to_s }
  #   it { should == '-bA+bAc-bAcaBA+bAcaBACB'}
  # end
  # #
  # context "theta_std('bAcaBAcCaBa')" do
  #   # theta_std('bAcaBACBa') = 0+b(-A+A(0+c(1+a(0+B(0+B(1)..) = -bA+bAc+bAcaBB
  #   subject { @theta_std.expand(Word.new('bAcaBAcCaBa')).to_s }
  #   it { should == '-bA+bAc+bAcaBB'}
  # end
  # #
  # context "theta_std(a word contractible into '1')" do
  #   ['aA', 'ZaAz', 'cBDdaAbC', 'cBDdaA-3(b+C)'].each do |str|
  #     it { @theta_std.expand(Word.new(str)).should == '0' }
  #   end
  # end
  # #
end
#---------------------------------

# #---------------------------------
# describe StdMagnusExp, "" do
#   context "" do
#     int { }
#   end
# end
# #---------------------------------

#End of File
