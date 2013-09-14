require 'test/unit'
require 'pathname'
require 'fileutils'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../lib/Core/Compiler'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
          
          module CompilerTest
            class ComponentFactory < ::WebBlocks::Core::ComponentFactory
              
            end
            class BlockFactory < ::WebBlocks::Core::BlockFactory
              
            end
          end
      
          class Compiler < ::Test::Unit::TestCase
            
            def setup 
              
              @options = [
                :base_directory, 
                :components_directory, 
                :component_factory,
                :block_factory
              ]
              @base_directory = Pathname.new(__FILE__).realpath.parent + '.test'
              @components_directory = 'bower_test_components'
              
              FileUtils.rm_rf @base_directory
              FileUtils.mkdir @base_directory
              FileUtils.mkdir @base_directory + @components_directory
              FileUtils.mkdir @base_directory + @components_directory + 'component'
              FileUtils.mkdir @base_directory + @components_directory + 'block-component'
              FileUtils.touch @base_directory + @components_directory + 'block-component' + 'Blocksfile.rb'
              
            end
            
            def teardown
              FileUtils.rm_rf @base_directory
            end

            def test_default_options
              
              compiler = ::WebBlocks::Core::Compiler.new
              @options.each { |key| assert compiler.options.include? key }
              
            end
            
            def test_nondefault_options
              
              
              compiler_options = {
                :base_directory => @base_directory,
                :components_directory => @components_directory,
                :component_factory => CompilerTest::ComponentFactory,
                :block_factory => CompilerTest::BlockFactory
              }
              
              compiler = ::WebBlocks::Core::Compiler.new compiler_options
              
              compiler_options.each { |key,value| assert compiler.options[key] == value }
              
            end
            
            def test_component_factory
              
              compiler = ::WebBlocks::Core::Compiler.new :component_factory => CompilerTest::ComponentFactory
              assert compiler.component_factory.class.name == 'WebBlocks::Core::Test::Unit::Core::CompilerTest::ComponentFactory'
              
            end
            
            def test_block_factory
              
              compiler = ::WebBlocks::Core::Compiler.new :block_factory => CompilerTest::BlockFactory
              assert compiler.component_factory.class.name == 'WebBlocks::Core::ComponentFactory'
              assert compiler.block_factory.class.name == 'WebBlocks::Core::Test::Unit::Core::CompilerTest::BlockFactory'
              
              compiler = ::WebBlocks::Core::Compiler.new :component_factory => CompilerTest::ComponentFactory, :block_factory => CompilerTest::BlockFactory
              assert compiler.component_factory.class.name == 'WebBlocks::Core::Test::Unit::Core::CompilerTest::ComponentFactory'
              assert compiler.block_factory.class.name == 'WebBlocks::Core::Test::Unit::Core::CompilerTest::BlockFactory'
              
            end
            
            def test_base_directory
              compiler = ::WebBlocks::Core::Compiler.new :base_directory => @base_directory
              assert compiler.base_directory == Pathname.new(@base_directory).realpath
            end
            
            def test_components_directory
              compiler = ::WebBlocks::Core::Compiler.new :base_directory => @base_directory, :components_directory => @components_directory
              assert compiler.components_directory == Pathname.new(@base_directory).realpath + @components_directory
            end
            
            def test_components
              compiler = ::WebBlocks::Core::Compiler.new :base_directory => @base_directory, :components_directory => @components_directory
              assert compiler.components.length == 2
            end
            
            def test_blocks
              compiler = ::WebBlocks::Core::Compiler.new :base_directory => @base_directory, :components_directory => @components_directory
              assert compiler.blocks.length == 1
            end

          end
      
        end
      end
    end
  end
end