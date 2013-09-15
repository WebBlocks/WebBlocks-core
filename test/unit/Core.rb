require 'test/unit'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../lib/Core'

module WebBlocks
  module Core
    module Test
      module Unit
      
        class CoreNamespace < ::Test::Unit::TestCase

          def test_namespace
            assert defined? ::WebBlocks::Core::Block
            assert defined? ::WebBlocks::Core::BlockFactory
            assert defined? ::WebBlocks::Core::BlockFile::Scss
            assert defined? ::WebBlocks::Core::Compiler
            assert defined? ::WebBlocks::Core::CompilerTask::Base
            assert defined? ::WebBlocks::Core::CompilerTask::Parse
            assert defined? ::WebBlocks::Core::CompilerTask::Setup
            assert defined? ::WebBlocks::Core::CompilerTask::Teardown::All
            assert defined? ::WebBlocks::Core::CompilerTask::Teardown::Core
            assert defined? ::WebBlocks::Core::Component
            assert defined? ::WebBlocks::Core::ComponentFactory
            assert defined? ::WebBlocks::Core::Support::Bower
            assert defined? ::WebBlocks::Core::Support::TSort::CyclicComponent
            assert defined? ::WebBlocks::Core::Support::TSort::Hash
          end

        end
      
      end
    end
  end
end