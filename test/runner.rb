#
# runner.rb
#
# testing of all test files in test/ by Test::Unit::AutoRunner
#
# Time-stamp: <2010-10-27 20:49:15 (ryosuke)>
#

require 'rubygems'
require 'test/unit/full'
Test::Unit::AutoRunner.run(true, './')

#End of File
