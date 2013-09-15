require 'test/unit'
require 'pathname'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../../lib/Core/BlockFile/Scss'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
          module BlockFile
      
            class Scss < ::Test::Unit::TestCase
              
              def setup
                
                @base_directory = Pathname.new(__FILE__).realpath.parent + '.test'
                @components_directory = 'bower_components'

                FileUtils.rm_rf @base_directory
                FileUtils.mkdir @base_directory
                FileUtils.mkdir @base_directory + @components_directory
                
                @block_name = 'block'
                @source_directory = 'src'
                
                FileUtils.mkdir @base_directory + @components_directory + @block_name
                FileUtils.mkdir @base_directory + @components_directory + @block_name + @source_directory
                FileUtils.touch @base_directory + @components_directory + @block_name + @source_directory + "file.scss"
                
                @block = ::WebBlocks::Core::Block.new @base_directory + @components_directory + @block_name
                @block.source_directory = @source_directory
                
                @file = ::WebBlocks::Core::BlockFile::Scss.new 'file', @block
                @file2 = ::WebBlocks::Core::BlockFile::Scss.new 'file2', @block
                
              end
              
              def test_initialize_attributes
                
                assert @file.name == 'file'
                assert @file.block === @block
                
                assert @file.dependencies.is_a?(Array)
                assert @file.dependencies.length == 0
                
                assert @file.loose_dependencies.is_a?(Array)
                assert @file.loose_dependencies.length == 0
                
                assert @file.reverse_dependencies.is_a?(Array)
                assert @file.reverse_dependencies.length == 0
                
                assert @file.loose_reverse_dependencies.is_a?(Array)
                assert @file.loose_reverse_dependencies.length == 0
                
              end
              
              def test_block_facade
                
                facade = @file.block_facade
                assert facade.last.scss.first === @file
                
                facade = @file.block_facade @file2
                assert facade.last.scss.first === @file2
                
              end
              
              def test_after
                
                @file.after @file2.block_facade
                assert @file.dependencies.first == @file2
                
              end
              
              def test_after_if_exists
                
                @file.after_if_exists @file2.block_facade
                assert @file.loose_dependencies.first == @file2
                
              end
              
              def test_before
                
                @file.before @file2.block_facade
                assert @file.reverse_dependencies.first == @file2
                
              end
              
              def test_before_if_exists
                
                @file.before_if_exists @file2.block_facade
                assert @file.loose_reverse_dependencies.first == @file2
                
              end

            end
          
          end
      
        end
      end
    end
  end
end