require 'test/unit'
require 'pathname'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../lib/Core/Block'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
      
          class Block < ::Test::Unit::TestCase

            def test_initialize
              
              path = Pathname.new(__FILE__).parent
              block = ::WebBlocks::Core::Block.new path.to_s
              assert block.directory == path
              
            end
            
            def test_attributes
              
              path = Pathname.new(__FILE__).parent
              block = ::WebBlocks::Core::Block.new path
              assert block.directory.to_s == path.to_s
              assert block.name == 'Core'
              assert block.blocksfile == path + 'Blocksfile.rb'
              
            end
            
          end
      
        end
      end
    end
  end
end