#
# Loop.rb
#
# Time-stamp: <2010-05-20 13:32:42>
#

require('Word')
require('Surface')
#require('mathn')

class Loop < Word

  def initialize(sty)
    super(sty)
    
    @gate_numbers = [a[k],,'A','b']
  end
  
  def twist_along(loop)
#    matrix = Matrix.zero(self.size)
#    (1..self.size).each do |i|
    (1..self.size).each do |i|
      x = self.segment(i)
      (1..loop.size).each do |j|
        y = loop.segment(j)
#        matrix[i][j] = 1
        p [x, y, intersection_of_segments(x,y)]
      end
      print "\n" 
#      p matrix.inspect
    end
  end
  
  def intersection_of_segments(x,y)
#    [x[0] < y[0], x[0] < y[1], x[1] < y[0], x[1] < y[1]].inspect 
#    (x+y).split('').sort
    gates = []
    xy = x+y
    (0..3).each do |k|
      gates << gate_number(xy[k].to_sym)
    end
    return gates
  end

  def cyclic(int)
    r = int.to_i % self.size
    w = self[0,r].dup

    return self.conjugate_by(w).contract
  end

  def segment(int)
    r = int.to_i % self.size
    if r == 0 then 
      self[self.size-1,1]*self[0,1]
    else
      self[r-1,2]
    end
  end
#
end

#End of File
