#
# FoxCalc_spec.rb
#
# Time-stamp: <2012-09-13 18:39:30 (ryosuke)>
#
$LOAD_PATH.push File.expand_path(File.dirname(__FILE__)+'/../src')

require('pry')
require('pry-nav')

require('FoxCalc')

#---------------------------------
describe FoxCalculator, "when initializing" do
  context "with no arguments" do
    subject { FoxCalculator.new.methods }
    int { shold == 'a'}
  end
end
#---------------------------------

# #---------------------------------
# describe FoxCalculator, "" do
#   context "" do
#     int { }
#   end
# end
# #---------------------------------

#End of File
