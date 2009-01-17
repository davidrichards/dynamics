require 'rubygems'
require 'rgl/adjacency'

# Useful for Fixnum, Symbol, TrueClass, NilClass, and FalseClass
# Usage: 
# a = 1
# a = a.wrap
# a + 3 # => 4
# a.attach_dynamics # Now works!
class Wrapper
  def initialize(val)
    @item = val
  end

  def inspect
    @item
  end
  
  def method_missing(sym, *args, &block)
    if block_given?
      @item.send(sym, *args, &block)
    else
      @item.send(sym, *args)
    end
  end
end

# Add all the methods that I want here.  This is the DSL.
# Need:
# graph (DirectedAdjacenyGraph)
# 
module DynamicMethods
  
  def graph
    @graph ||= Dynamics::Graph.instance
  end
  
  # A system of equations to be solved
  def matrix
  end
  alias :system_of_equations :matrix
  
  # A multiplication of this flow ? Or an array?
  def flow
  end
  
  def adjacent_vertices
  end
  alias :nearest_neighbors :adjacent_vertices
  alias :neighbors :adjacent_vertices
end

module Dynamics
  class Graph < RGL::DirectedAdjacencyGraph
    def self.instance
      @@inst ||= new
    end
  end
  
  class Operation
  end
  
  # There are three operations that I know so far...
  class X < Operation
  end
end

class Object
  def wrap
    Wrapper.new(self)
  end
  
  def make_dynamic
    self.extend DynamicMethods
  end
end

class Array
  
  def make_all_dynamic
    each { |obj| obj.make_dynamic }
  end
end

@b = 'b'
@b.attach_dynamics
puts @b.graph