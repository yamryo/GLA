#
# StdMagnusExp_spec.rb
#
# Time-stamp: <2012-09-14 20:08:52 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('StdMagnusExp')

 Theta_std = StdMagnusExp

#---------------------------------
describe StdMagnusExp, "when initialized" do
  it { Theta_std.class.name.should == 'Module'}
  it { Theta_std::Modulo.should == 4}
end
#---------------------------------

#---------------------------------
describe StdMagnusExp, "#send" do
  before :all do
    @gen_a = Generator.new('a')
    @gen_1 = Generator.new('1')
  end
  #  
  context "return a FormalSum" do
    subject { Theta_std.expand(@gen_a).kind_of?(FormalSum) }
    it { should be_true }
  end
  #
  context "for generators" do
    context "theta_std('a')" do
      subject { Theta_std.expand(@gen_a.dup).to_s }
      it { should == '1+a'}
    end
    #
    context "theta_std('A')" do
      subject { Theta_std.expand(@gen_a.inverse).to_s }
      it { should == '1-a+aa-aaa'}
    end
    #
    context "theta_std('1')" do
      subject { Theta_std.expand(@gen_1).to_s }
      it { should == '1'}
    end
  end
  #
  context "theta_std('ab')" do
    # theta_std('ab') = (1+a)(1+b) = 1+a+b+ab
    subject { Theta_std.expand(Word.new('ab')).to_s }
    it { should == '1+a+b+ab'}
  end
  #
  context "theta_std('aA')" do
    subject { Theta_std.expand(Word.new('aA')).to_s }
    it { should == '1'}
  end
  #
  context "theta_std('abA')" do
    # theta_std('aBA') = (1+a)(1+b)(1-a+aa-aaa) = 1+b+ab-ba-aba+baa-aaaa+abaa-baaa-abaaa
    subject { Theta_std.expand(Word.new('abA')).to_s }
    it { should == '1+b+ab-ba-aba+baa'}
  end
  #
  context "degree 0 to 2 parts of theta_std('abAB')" do
    subject do 
      pdt = Theta_std.expand(Word.new('abAB'))
      pdt.homo_part(0..2).sort.to_s 
    end
    it { should == '1+ab-ba'}
  end
  #
  context "theta_std('Bab')" do
    # theta_std('Bab') = (1-b+bb-bbb)(1+a)(1+b)
    #                  = (1+a-b-ba+bb+bba-bbb-bbba)(1+b) 
    #                  = 1+a+ab-ba+bba-bbba-bab+bbab-bbbb-bbbab
    subject { Theta_std.expand(Word.new('Bab')).homo_part(0..3).to_s }
    it { should == '1+a+ab-ba-bab+bba'}
  end
  #
  context "theta_std('bAcaBC')" do
    subject { Theta_std.expand(Word.new('bAcaBC')).homo_part(1).to_s }
    it { should == '0'}
  end
  #
  context "theta_std('bAcaB')" do
    subject { Theta_std.expand(Word.new('bAcaB')).homo_part(2).to_s }
    it { should == '-ac+bc+ca-cb'}
  end
  #
  context "theta_std('cBDdaA')" do
    subject { Theta_std.expand(Word.new('cBDdaA')).homo_part(3).to_s }
    it { should == '-bbb+cbb'}
  end
  #
  context "theta_std(a word contractible into '1')" do
    ['aA', 'ZaAz', 'cBDdaAbC'].each do |str|
      it { Theta_std.expand(Word.new(str)).to_s.should == '1' }
    end
  end
  #
end
#---------------------------------

#---------------------------------
describe StdMagnusExp, "when initialized" do
  context "" do
    it { }
  end
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
