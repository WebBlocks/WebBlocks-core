require 'test/unit'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../../lib/Core/CompilerTask/Base'
require_relative '../../../../lib/Core/Compiler'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
          module CompilerTask
            
            module BaseTest
              class Base < ::WebBlocks::Core::CompilerTask::Base
                def compiler
                  @compiler
                end
              end
              class Compiler < ::WebBlocks::Core::Compiler; end
            end
      
            class Base < ::Test::Unit::TestCase

              def test_compiler_member
                task = BaseTest::Base.new BaseTest::Compiler.new
                assert task.compiler.class.name == 'WebBlocks::Core::Test::Unit::Core::CompilerTask::BaseTest::Compiler'
              end
              
              def test_name
                assert ::WebBlocks::Core::CompilerTask::Base.new(nil).name == 'WebBlocks::Core::CompilerTask::Base'
                assert BaseTest::Base.new(nil).name == 'WebBlocks::Core::Test::Unit::Core::CompilerTask::BaseTest::Base'
              end
              
              def test_run
                assert_raise(RuntimeError) { ::WebBlocks::Core::CompilerTask::Base.new(nil).run }
              end

            end
          
          end
      
        end
      end
    end
  end
end