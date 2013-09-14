require 'test/unit'
require 'pathname'
require 'fileutils'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../lib/Core/BlockFactory'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
      
          class BlockFactory < ::Test::Unit::TestCase

            def setup
              
              @components_directory = Pathname.new(__FILE__).realpath.parent + '.test'
              FileUtils.rm_rf @components_directory
              FileUtils.mkdir @components_directory
              FileUtils.mkdir @components_directory + 'component'
              FileUtils.mkdir @components_directory + 'component2'
              FileUtils.mkdir @components_directory + 'block-component'
              FileUtils.touch @components_directory + 'block-component' + 'Blocksfile.rb'
              FileUtils.mkdir @components_directory + 'block-component2'
              FileUtils.touch @components_directory + 'block-component2' + 'Blocksfile.rb'
              
              @components = [
                @components_directory + 'component',
                @components_directory + 'component2',
                @components_directory + 'block-component',
                @components_directory + 'block-component2',
                @components_directory + 'nonexistent-component'
              ]
              
              @factory = ::WebBlocks::Core::BlockFactory.new @components
              
            end
            
            def teardown
              
              FileUtils.rm_rf @components_directory
              
            end
            
            def test_initialize
              
              assert @factory.directories.length == 2
              
            end
            
            def test_blocksfiles
              
              @factory.blocksfiles.each { |f| assert f.to_s.match /Blocksfile\.rb$/ }
              
            end
            
            def test_names
              
              ['block-component', 'block-component2'].each { |component| assert @factory.names.include? component }
              
            end
            
            def test_blocks
              
              ['block-component', 'block-component2'].each do |component|
                blocks = @factory.blocks
                assert blocks.include? component
                block = blocks[component]
                assert block.class.name == 'WebBlocks::Core::Block'
                assert block.directory == @components_directory + component
                assert block.name == component
                assert block.blocksfile == @components_directory + component + 'Blocksfile.rb'
              end
              
            end
            
          end
      
        end
      end
    end
  end
end