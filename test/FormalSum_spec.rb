#
# FormalSum_spec.rb
#
# Time-stamp: <2012-09-07 20:57:27 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('rubygems')
require('pry')

require('FormalSum.rb')

   Zero = FormalSum::Zero
   One = FormalSum::One

#------------------------------------
describe FormalSum, "when initialized" do
  before(:all){ @fs = FormalSum.new(Zero) }
#
  context "with the zero Term" do
    it "should include Terms in Array" do
      @fs.terms.kind_of?(Array).should be true
    end 
#
    it { (@fs.terms).should == [Zero]}
#
  end
# #   must "initialize with String" do
# #     %w[1+a-Bc a+B-4s 1+A-6 a+30 3+a 1].each do 
# #       |str| assert_equal str, FormalSum.new(str).to_s
# #     end
# #   end
# # #    
# #   must "initialize with String including zero terms" do
# #     assert_equal "2-3ab-8Cd", FormalSum.new("0+2+00-3ab+0aG-8Cd").to_s
# #   end
# # #    
# #   must "initialize with more complicated strings" do
# #     assert_equal "a,30", FormalSum.new('a+30').terms.join(',')
# #     assert_equal "100,b", FormalSum.new('100+b').terms.join(',')
# #   end
end
#------------------------------------

#------------------------------------
describe FormalSum, "#to_s" do
  context "" do
    it { FormalSum.new(One).to_s.should == '1' }
    it { FormalSum.new(Zero, One).to_s.should == '1' }
    it { FormalSum.new([One, Zero]).to_s.should == '1' }
    it { FormalSum.new([One, Zero, Term.new('a')]).to_s.should == '1+a' }
    it { FormalSum.new(One, Zero, Term.new('aAB', -2)).to_s.should == '1-2aAB'}
    it { FormalSum.new([One, Term.new('2xe', -4)]).to_s.should == '1-4xe'}
  end
end
#------------------------------------

# #------------------------------------
# describe FormalSum, "" do
#   context "" do
#     it { }
#   end
# end
# #------------------------------------
#
# # #    
# #   must "perform addition of formal sums as simply connecting them with '+'" do
# #     fs_1 = FormalSum.new(Term.new('a'),Term.new('b', -1))
# #     fs_2 = FormalSum.new(Term.new('c'), Term.new('de', -3))
# #     fs_3 = FormalSum.new(Term.new('a'),Term.new('b'))

# #     assert_equal "a-b+c-3de", (fs_1 + fs_2).to_s
# #     assert_equal "a-b", fs_1.to_s
# #     assert_equal "a-b+a+b", (fs_1+fs_3).to_s
# #   end
# # #    
# #   must "not be changed by addition with zero" do
# #     mstr = "ac-5Ab"
# #     assert_equal mstr, (@fs + FormalSum.new(mstr)).to_s
# #   end
# # #    
# #   must "sort terms by degree, then by word, last by coefficient" do
# #     @fs += FormalSum.new('a+1+bA')
# # # non-destructive sort 
# #     assert_equal ["1","a","bA"], @fs.sort.terms.map{ |t| t.to_s }
# #     assert_equal ["a","1","bA"], @fs.terms.map{ |t| t.to_s }

# # # destructive sort 
# #     assert_equal ["1","a","bA"], @fs.sort!.terms.map{ |t| t.to_s }
# #     assert_equal ["1","a","bA"], @fs.terms.map{ |t| t.to_s }

# #     @fs += FormalSum.new('+2a+3cVe-6+10oLfP-2bc-v-4cVe') 
# #     assert_equal ["-6","1","a","2a","-v","bA","-2bc","-4cVe","3cVe","10oLfP"], 
# #     @fs.sort.terms.map{ |t| t.to_s }

# #     assert_equal ["M","a"], FormalSum.new('a+M').sort.terms.map{ |t| t.to_s }
# #     assert_equal ["M","-a"], FormalSum.new('-a+M').sort.terms.map{ |t| t.to_s }
# #   end
# # #    
# #   must "extract a homogeneous part" do
# #     myfs = FormalSum.new('1-a-2bAc+3DVe-10oLfP+M+29') 
# #     myhash = { 0 => "1+29", 1 => "M-a", 2 => "0", 3 => "3DVe-2bAc", 4 => "-10oLfP"}

# #     hParts = Hash.new
# #     (0..4).each{ |k| hParts.store(k, myfs.homo_part(k).to_s)}
# #     # hParts = Hash.new{ |hash, key| hash[key]=myfs.homo_part(key).to_s}
# #     # (0..4).each{ |k| hParts[k] }

# #     assert_equal myhash, hParts
# #   end
# # #    
# #   must "simplify formal sums" do
# #     assert_equal "2a-b", FormalSum.new('a-b+a').simplify.to_s
# #     assert_equal "3+2a-2aCb", 
# #     FormalSum.new('2Bc+1+a-2Bc+a+3aCb+2-5aCb').simplify.to_s
# #   end
# # # #    
# # end

#End of File
