require 'test/unit'
require 'pathname'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../../lib/Core/CompilerTask/Setup'
require_relative '../../../../lib/Core/Compiler'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
          module CompilerTask
      
            class Setup < ::Test::Unit::TestCase
              
              def setup
                
                @base_directory = Pathname.new(__FILE__).realpath.parent + '.test'
                FileUtils.rm_rf @base_directory
                FileUtils.mkdir @base_directory
                
              end
              
              def teardown
                
                FileUtils.rm_rf @base_directory
                
              end

              def test_run
                
                begin
                
                  compiler = OpenStruct.new
                  compiler.base_directory = @base_directory
                  
                  # monkey-patch and save original version
                  command_method = ::WebBlocks::Core::Support::Bower.method(:command)
                  ::WebBlocks::Core::Support::Bower.class_eval do
                    def self.command str
                      raise str
                    end
                  end
                  
                  ::WebBlocks::Core::CompilerTask::Setup.new(compiler).run
                  
                  # should never get here - but if we do, then need to fail
                  assert false
                  
                rescue RuntimeError => command
                  
                  assert command.to_s == 'install'
                  
                ensure
                  
                  # revert monkey-patch to original version
                  ::WebBlocks::Core::Support::Bower.class_eval do
                    define_method(command_method.name, &command_method)
                  end
                  
                end
                
              end

            end
          
          end
      
        end
      end
    end
  end
end