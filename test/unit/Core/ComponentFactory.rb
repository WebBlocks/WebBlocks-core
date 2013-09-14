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
      
          class ComponentFactory < ::Test::Unit::TestCase

            def setup
              
              @components_directory = Pathname.new(__FILE__).realpath.parent + '.test'
              FileUtils.rm_rf @components_directory
              FileUtils.mkdir @components_directory
              FileUtils.mkdir @components_directory + 'component'
              FileUtils.touch @components_directory + 'component' + 'Blocksfile.rb'
              FileUtils.mkdir @components_directory + 'component2'
              FileUtils.touch @components_directory + 'component2' + 'Blocksfile.rb'
              FileUtils.mkdir @components_directory + 'component3'
              
              @components = [
                @components_directory + 'component',
                @components_directory + 'component2',
                @components_directory + 'component3'
              ]
              
              @factory = ::WebBlocks::Core::ComponentFactory.new @components_directory
              
            end
            
            def teardown
              
              FileUtils.rm_rf @components_directory
              
            end
            
            def test_initialize
              
              factory = ::WebBlocks::Core::ComponentFactory.new @components_directory.to_s
              assert factory.components_directory == @components_directory
              assert factory.components_directory.to_s == @components_directory.to_s
              
            end
            
            def test_names
              
              names = @factory.names
              ['component','component2','component3'].each { |name| assert names.include? name }
              
            end
            
            def test_block_factory
              
              block_factory = @factory.block_factory ::WebBlocks::Core::BlockFactory
              assert block_factory.class.name == 'WebBlocks::Core::BlockFactory'
              assert block_factory.names.length == 2
              
            end
            
            def test_components
              
              ['component','component2','component3'].each do |component|
                components = @factory.components
                assert components.include? component
                component_object = components[component]
                assert component_object.class.name == 'WebBlocks::Core::Component'
                assert component_object.directory == @components_directory + component
                assert component_object.name == component
              end
              
            end
            
          end
      
        end
      end
    end
  end
end