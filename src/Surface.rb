#
# Surface.rb
#
# Time-stamp: <2012-09-13 20:06:01 (ryosuke)>
#

class OneHandle
  def initialize(generator)
    @generator = generator
  end
end

class Surface
  def initialize(genus, punctures)
    raise('The genus must be less than 10') if genus > 10
    raise('The number of punctures must be less than 10') if punctures > 10
    
    @genus = genus
    @punctures = punctures
    
    
    str = 'abcdefghijklmnopqrst'[0, @genus * 2 + @punctures - 1]
    @fundermental_group = FreeGroup.new(str)
    
    @one_handles = Array.new(@genus * 2 + @punctures) do |k|
      OneHandle.new(@fundermental_group.generators[str[k].to_sym])
    end
  end
end

#-- End of file --
