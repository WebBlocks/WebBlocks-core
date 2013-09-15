require 'docile'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative 'Base'

module WebBlocks
  module Core
    module CompilerTask
      class Parse < Base
        
        def run
          
          @compiler.blocks.each do |name, block| 
            block.parse! @compiler
          end
          
        end
        
      end
    end
  end
end