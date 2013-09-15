require 'ostruct'

module WebBlocks
  module Core
    module BlockFile
      
      class Scss
        
        attr_reader :name, :dependencies, :loose_dependencies, :reverse_dependencies, :loose_reverse_dependencies
        
        def initialize name, block
          
          @name = name
          @block = block
          @dependencies = []
          @loose_dependencies = []
          @reverse_dependencies = []
          @loose_reverse_dependencies = []
          
        end
        
        def block_facade file = false
          
          file = self unless file
          facade = OpenStruct.new
          facade.last = OpenStruct.new
          facade.last.scss = [file]
          facade
          
        end
        
        def after block
          
          @dependencies |= block.last.scss
          self
          
        end
        
        def after_if_exists block
          
          @loose_dependencies |= block.last.scss
          self
          
        end
        
        def before block
          
          @reverse_dependencies |= block.last.scss
          self
          
        end
        
        def before_if_exists block
          
           @loose_reverse_dependencies |= block.last.scss
          self
          
        end
        
        def scss_file name
          
          block_facade @block.scss_files[name]
          
        end
        
        def block name = false, &block
          
          return @block unless name
          
          @block.compiler.blocks[name].parse! @block.compiler
          @block.compiler.blocks[name].reset_last!
          Docile.dsl_eval(@block.compiler.blocks[name], &block)
          @block.compiler.blocks[name]
          
        end
        
      end
      
    end
  end
end