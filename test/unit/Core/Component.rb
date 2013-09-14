require 'test/unit'
require 'pathname'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../lib/Core/Component'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
      
          class Component < ::Test::Unit::TestCase

            def test_initialize
              
              path = Pathname.new(__FILE__).parent
              component = ::WebBlocks::Core::Component.new path.to_s
              assert component.directory == path
              
            end
            
            def test_attributes
              
              path = Pathname.new(__FILE__).parent
              component = ::WebBlocks::Core::Component.new path
              assert component.directory.to_s == path.to_s
              assert component.name == 'Core'
              
            end
            
          end
      
        end
      end
    end
  end
end