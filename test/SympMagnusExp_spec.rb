#
# SympMagnusExp_spec.rb
#
# Time-stamp: <2012-10-01 10:22:21 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('SympMagnusExp')

 Theta_symp = SympMagnusExp

#---------------------------------
describe SympMagnusExp, "when initialized" do
  it { Theta_symp.class.name.should == 'Module'}
  it { Theta_symp::Modulo.should == 4}
end
#---------------------------------

#---------------------------------
describe SympMagnusExp, "#send" do
  before :all do
    @gen_a = Generator.new('a')
    @gen_1 = Generator.new('1')
  end
  #  
  context "return a FormalSum" do
    subject { Theta_symp.expand(@gen_a) }
    it { should be_kind_of(FormalSum) }
  end
  #
  context "for generators" do
    context "theta_symp('a')" do
      subject { Theta_symp.expand(@gen_a.dup).to_s }
      it { should == '1+a'}
    end
    #
    context "theta_symp('A')" do
      subject { Theta_symp.expand(@gen_a.inverse).to_s }
      it { should == '1-a+aa-aaa'}
    end
    #
    context "theta_symp('1')" do
      subject { Theta_symp.expand(@gen_1).to_s }
      it { should == '1'}
    end
  end
  #
#   context "theta_symp('ab')" do
#     theta_symp('ab') = (1+a)(1+b) = 1+a+b+ab
#     subject { Theta_symp.expand(Word.new('ab')).to_s }
#     it { should == '1+a+b+ab'}
#   end
  
#   context "theta_symp('aA')" do
#     subject { Theta_symp.expand(Word.new('aA')).to_s }
#     it { should == '1'}
#   end
  
#   context "theta_symp('abA')" do
#     theta_symp('aBA') = (1+a)(1+b)(1-a+aa-aaa) = 1+b+ab-ba-aba+baa-aaaa+abaa-baaa-abaaa
#     subject { Theta_symp.expand(Word.new('abA')).to_s }
#     it { should == '1+b+ab-ba-aba+baa'}
#   end
  
#   context "degree 0 to 2 parts of theta_symp('abAB')" do
#     subject do 
#       pdt = Theta_symp.expand(Word.new('abAB'))
#       pdt.homo_part(0..2).sort.to_s 
#     end
#     it { should == '1+ab-ba'}
#   end
  
#   context "theta_symp('Bab')" do
#     theta_symp('Bab') = (1-b+bb-bbb)(1+a)(1+b)
#                      = (1+a-b-ba+bb+bba-bbb-bbba)(1+b) 
#                      = 1+a+ab-ba+bba-bbba-bab+bbab-bbbb-bbbab
#     subject { Theta_symp.expand(Word.new('Bab')).homo_part(0..3).to_s }
#     it { should == '1+a+ab-ba-bab+bba'}
#   end
  
#   context "theta_symp('bAcaBC')" do
#     subject { Theta_symp.expand(Word.new('bAcaBC')).homo_part(1).to_s }
#     it { should == '0'}
#   end
  
#   context "theta_symp('bAcaB')" do
#     subject { Theta_symp.expand(Word.new('bAcaB')).homo_part(2).to_s }
#     it { should == '-ac+bc+ca-cb'}
#   end
  
#   context "theta_symp('cBDdaA')" do
#     subject { Theta_symp.expand(Word.new('cBDdaA')).homo_part(3).to_s }
#     it { should == '-bbb+cbb'}
#   end
  
#   context "theta_symp(a word contractible into '1')" do
#     ['aA', 'ZaAz', 'cBDdaAbC'].each do |str|
#       it { Theta_symp.expand(Word.new(str)).to_s.should == '1' }
#     end
#   end
  
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
