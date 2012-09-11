#
# FormalSum_spec.rb
#
# Time-stamp: <2012-09-11 20:46:05 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('FormalSum.rb')

Zero = FormalSum::Zero
One = FormalSum::One

#------------------------------------
describe FormalSum, "when initialized" do
  #
  context "with a Term" do
    before do
      @trm = Term.new('-5wojCSisA')
      @fs = FormalSum.new(@trm)
    end
    #
    it "should equip an Array of a single Term" do
      @fs.terms.kind_of?(Array).should be_true
      @fs.terms.should == [@trm]
    end
    #
    context "with the Zero" do
      it "should equip an Array of a single Zero" do
        zerofs = FormalSum.new(Zero)
        zerofs.terms.kind_of?(Array).should be_true
        zerofs.terms.should == [Zero]
      end 
    end
    #
  end
  # 
  context "without arguments" do
    subject { @fs = FormalSum.new.terms }
    it { should == [Zero] }
  end
  #
  context "with Terms" do
    before { @t = Term.new('aAB', -2)}
    #
    it "should not ignore the Zero term" do
      FormalSum.new(One, Zero, @t).terms[0].should == One
      FormalSum.new(One, Zero, @t).terms[1].should == Zero
      FormalSum.new(One, Zero, @t).terms[2].should == @t
      FormalSum.new(One, Zero, @t).terms.size.should == 3
    end
  end
#
  context "with an Array of Terms" do
    before :all do
      @t = Term.new('2xe', -4)
      @zero = Term.new('Wiejr',0)
    end
#
    it "should be a FormalSum of the given Terms" do
      FormalSum.new([One, @t]).terms.should == [One, @t]
    end
#
    it "should not ignore the Zero" do
      FormalSum.new([One, Zero]).terms.should == [One, Zero]
      FormalSum.new([@zero, One, @t]).terms.should == [@zero, One, @t]
    end
  end
#
  context "with a String" do
    before do
      @str = '2+c-B-4s'
      @arr= %w[(2)1 (1)c (-1)B (-4)s]
      @fs = FormalSum.new(@str)
      @tarr = @fs.terms
    end
#
    it "should equip an Array of Terms" do
      (@tarr.size).times do |k|
        @tarr[k].kind_of?(Term).should be_true
        (@tarr[k].show).should == @arr[k]
      end
    end
#
    it "should not ignore zero terms" do
      t = FormalSum.new('-3+6acB-a+0bKde-00+0-50')
      t.terms.join(',').should == '-3,6acB,-a,0,0,0,-50'
      (t.terms[3]) == { word: 'bKde', coeff: 0 }
    end
  end
#
end
#------------------------------------

#------------------------------------
describe FormalSum, "#to_s" do
  context "for a FormalSum without zero terms" do
    subject { FormalSum.new('-3+6acB-a-50').to_s}
    it { should == '-3+6acB-a-50'} 
  end
#
  context "for a FormalSum with zero terms" do
    subject { FormalSum.new('-3+6acB-a+0bKde-0+0-50').to_s}
    it { should == '-3+6acB-a-50'} 
  end
#
  context "for a FormalSum with zero terms only" do
    subject { FormalSum.new('-0+0acB-0a+0bKde-0+0+0').to_s}
    it { should == '0'} 
  end
#
  context "for Zero" do
    subject { FormalSum.new.to_s}
    it { should == '0'} 
  end
#
  context "for One" do
    subject { FormalSum.new(One).to_s}
    it { should == '1'} 
  end
#
end
#------------------------------------

#------------------------------------
describe FormalSum, "#show" do
  context "for a FormalSum without zero terms" do
    subject { FormalSum.new('-3+6acB-a-50').show}
    it { should == '(-3)1+(6)acB+(-1)a+(-50)1'} 
  end
#
  context "for a FormalSum with zero terms" do
    subject { FormalSum.new('-3+6acB-a+0bKde-0+0-50').show}
    it { should == '(-3)1+(6)acB+(-1)a+(0)bKde+(0)1+(0)1+(-50)1'} 
  end
#
  context "for a FormalSum with zero terms only" do
    subject { FormalSum.new('-0+0acB-0a+0bKde+0').show}
    it { should == '(0)1+(0)acB+(0)a+(0)bKde+(0)1'} 
  end
#
  context "for Zero" do
    subject { FormalSum.new.show}
    it { should == '(0)1'} 
  end
#
  context "for One" do
    subject { FormalSum.new(One).show}
    it { should == '(1)1'} 
  end
#
end
#------------------------------------

#------------------------------------
describe FormalSum, "addition" do
  before :all do
    @fs_1 = FormalSum.new('a-b')
    @fs_2 = FormalSum.new('c-3de')
    @zfs = FormalSum.new('0a-0b')
  end
#
  context "for 'a-b' and 'c-3de'" do
    it { (@fs_1+@fs_2).to_s.should == 'a-b+c-3de' }
  end
# 
  context "for a FormalSum and Zero" do
    it "should simply connect two Array of Terms" do
      (@fs_1+@zfs).show.should == '(1)a+(-1)b+(0)a+(0)b'
    end
  end
#
end
#------------------------------------

#------------------------------------
describe FormalSum, "#opposite" do
  context "for a FormalSum with zero terms" do
    before { @zfs = FormalSum.new('0-0aBCD+00') }
    #
    it "should cause to no change" do
      expect { @zfs.opposite }.not_to change{ @zfs } 
    end
  end
#
  context "for a normal FormalSum" do
    before { @fs = FormalSum.new('a-b+c-3de') }
    #
    it "should change the sign of each Term" do
      (@fs.opposite.terms.map{ |t| t.sign }).should == ['-','+','-','+'] 
    end
  end
#
end
#------------------------------------

#------------------------------------
describe FormalSum, "#sort" do
  before(:all){ @fs = FormalSum.new('a-1+bA') }
  #
  context "for a FormalSum 'a+1+bA'" do
    subject { @fs.sort.to_s }
    it { should == '-1+a+bA' }
  end
  #
  context "for a FormalSum 'a-1+bA+0a-0k'" do
    subject { (@fs+'0a-0k').sort.show }
    it { should == '(-1)1+(0)a+(1)a+(0)k+(1)bA' }
  end
  #
  context "of non-destructive type" do
    it { expect { @fs.sort }.not_to change{ @fs.terms } }
  end
  #
  context "of destructive type" do
    it { expect { @fs.sort! }.to change{ @fs.terms } }
  end
  #
  context "about uppercases and lowercases" do
    it { FormalSum.new('a+bs-bS+M+1-A-0b+bsX').sort.to_s.should == '1+a-A+M+bs-bS+bsX' }
  end
  #
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
# #   must "sort terms by degree, then by word, last by coefficient" do
# #     
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
