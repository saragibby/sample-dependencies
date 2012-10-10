require 'spec_helper'
require 'ruby-debug'

describe Dependency do
  
  describe 'initialize' do
    it 'should initialize with no input value passed' do
      dep = Dependency.new()
      dep.input_lines.should be_nil
      dep.class_names.should eql({})
    end
    
    it 'should initialize with input lines passed, and then process those lines' do
      dep = Dependency.new("A B\r\nB C")
      dep.input_lines.should eql("A B\r\nB C")
      dep.class_names.should eql({"A" => ["B"], "B" => ["C"]})
    end
  end
  
  describe 'add direct dependencies' do
    let(:dep) { Dependency.new }
    
    it 'should create a simple dependency' do
      dep.add_direct('A', %w{ B C } )
      dep.dependencies_for('A').should eql(%w{ B C })
    end
    
    it 'should return dependencies of dependent class' do
      dep.add_direct('A', %w{ B C } )
      dep.add_direct('B', %w{ C E } )
      dep.dependencies_for('A').should eql(%w{ B C E })
      dep.dependencies_for('B').should eql(%w{ C E })
    end
    
    it 'should not include a dependency on itself' do
      dep.add_direct('A', %w{ B } )
      dep.add_direct('B', %w{ C } )
      dep.add_direct('C', %w{ A } )
      dep.dependencies_for('A').should eql(%w{ B C })
      dep.dependencies_for('B').should eql(%w{ A C })
      dep.dependencies_for('C').should eql(%w{ A B })
    end
    
    it 'should handle complex dependencies' do
      dep.add_direct('A', %w{ B C } )
      dep.add_direct('B', %w{ C E } )
      dep.add_direct('C', %w{ G   } )
      dep.add_direct('D', %w{ A F } )
      dep.add_direct('E', %w{ F   } )
      dep.add_direct('F', %w{ H   } )
      
      dep.dependencies_for('A').should eql(%w{ B C E F G H })
      dep.dependencies_for('B').should eql(%w{ C E F G H })
      dep.dependencies_for('C').should eql(%w{ G })
      dep.dependencies_for('D').should eql(%w{ A B C E F G H })
      dep.dependencies_for('E').should eql(%w{ F H })
      dep.dependencies_for('F').should eql(%w{ H })
    end
  end
  
end