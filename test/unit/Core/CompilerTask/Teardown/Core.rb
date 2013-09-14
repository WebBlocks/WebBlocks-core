require 'test/unit'
require 'pathname'
require 'fileutils'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../../../lib/Core/CompilerTask/Teardown/All'
require_relative '../../../../../lib/Core/Compiler'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
          module CompilerTask
            module Teardown
      
              class Core < ::Test::Unit::TestCase
                
                def setup
                  
                  @base_directory = Pathname.new(__FILE__).realpath.parent + '.test'
                  @components_directory = 'bower_components'
                  FileUtils.rm_rf @base_directory
                  FileUtils.mkdir @base_directory
                  FileUtils.mkdir @base_directory + @components_directory
                  FileUtils.mkdir @base_directory + @components_directory + 'WebBlocks-core'
                  
                end
                
                def teardown
                  
                  FileUtils.rm_rf @base_directory
                    
                end

                def test_run
                  
                  begin

                    compiler = OpenStruct.new
                    compiler.base_directory = @base_directory
                    compiler.components_directory = @base_directory + @components_directory

                    # monkey-patch and save original version
                    command_method = ::WebBlocks::Core::Support::Bower.method(:command)
                    ::WebBlocks::Core::Support::Bower.class_eval do
                      def self.command str
                        raise str
                      end
                    end

                    ::WebBlocks::Core::CompilerTask::Teardown::Core.new(compiler).run

                    # should never get here - but if we do, then need to fail
                    assert false

                  rescue RuntimeError => command

                    assert File.exists?(@base_directory) == true
                    assert File.exists?(@base_directory + @components_directory) == true
                    assert File.exists?(@base_directory + @components_directory + 'WebBlocks-core') == false
                    assert command.to_s == 'cache clean'

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
end