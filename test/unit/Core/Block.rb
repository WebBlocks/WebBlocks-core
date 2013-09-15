require 'test/unit'
require 'pathname'
require 'fileutils'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../../../lib/Core/Block'
require_relative '../../../lib/Core/Compiler'

module WebBlocks
  module Core
    module Test
      module Unit
        module Core
      
          class Block < ::Test::Unit::TestCase
            
            def setup
              
              @base_directory = Pathname.new(__FILE__).realpath.parent + '.test'
              @components_directory = 'bower_components'
              
              FileUtils.rm_rf @base_directory
              FileUtils.mkdir @base_directory
              FileUtils.mkdir @base_directory + @components_directory
              
              @basic_block_name = 'block1'
              FileUtils.mkdir @base_directory + @components_directory + @basic_block_name
              File.open(@base_directory + @components_directory + @basic_block_name + 'Blocksfile.rb', 'w') do |file|
                file.puts "block '#{@basic_block_name}' do"
                file.puts "  scss_file 's1'"
                file.puts "  scss_file 's2'"
                file.puts "  scss_file 's3'"
                file.puts "end"
              end
              @basic_block = ::WebBlocks::Core::Block.new @base_directory + @components_directory + @basic_block_name
              
              @block_name = 'block2'
              FileUtils.mkdir @base_directory + @components_directory + @block_name
              FileUtils.touch @base_directory + @components_directory + @block_name + "Blocksfile.rb"
              
              @basic_component_name = 'component1'
              FileUtils.mkdir @base_directory + @components_directory + @basic_component_name
              
              @compiler = ::WebBlocks::Core::Compiler.new :base_directory => @base_directory, :components_directory => @components_directory
              
            end
            
            def teardown
              
              FileUtils.rm_rf @base_directory
              
            end

            def test_initialize
              
              path = Pathname.new(__FILE__).parent
              block = ::WebBlocks::Core::Block.new path.to_s
              assert block.directory == path
              
              assert_raise(Errno::ENOENT) { ::WebBlocks::Core::Block.new @base_directory + @components_directory + 'does-not-exist' }
              
            end
            
            def test_attributes
              
              path = Pathname.new(__FILE__).parent
              block = ::WebBlocks::Core::Block.new path
              
              assert block.directory.to_s == path.to_s
              assert_raise(NoMethodError) { block.directory = 'test' }
              
              assert block.name == 'Core'
              assert_raise(NoMethodError) { block.name = 'test' }
              
              assert block.blocksfile == path + 'Blocksfile.rb'
              assert_raise(NoMethodError) { block.blocksfile = 'test' }
              
              assert block.source_directory == false
              assert_nothing_raised { block.source_directory = 'a' }
              assert block.source_directory == 'a'
              
              assert_raise(RuntimeError) { block.compiler }
              assert_nothing_raised { block.compiler = @compiler }
              assert block.compiler === @compiler
              
              assert block.scss_files.is_a?(Hash)
              block.scss_files['test'] = true
              assert block.scss_files['test']
              assert_raise(NoMethodError) { block.scss_files = {} }
              
              assert block.last.scss != nil
              
            end
            
            def test_parsed?
              
              block = @compiler.blocks[@basic_block_name]
              
              assert !block.parsed?
              block.parse! @compiler
              assert block.parsed?
              
            end
            
            def test_compiler
              
              path = @base_directory + @components_directory + @basic_block_name
              block = ::WebBlocks::Core::Block.new path
              
              assert !block.has_compiler?
              assert_raise(RuntimeError) { block.compiler }
              assert block.with_compiler(@compiler) === block
              assert block.has_compiler?
              assert block.compiler === @compiler
              
            end
            
            def test_requires_compiler
              
              path = @base_directory + @components_directory + @basic_block_name
              block = ::WebBlocks::Core::Block.new path
              
              assert_raise(RuntimeError) { block.blocks }
              assert_raise(RuntimeError) { block.components }
              assert_raise(RuntimeError) { block.parse! }
              assert_raise(RuntimeError) { block.block @basic_block_name }
              
            end
            
            def test_parse!
              
              assert_raise(RuntimeError) { @basic_block.parse! }
              assert @basic_block.parse!(@compiler) === @basic_block
              assert_nothing_raised { @basic_block.parse! }
              assert @basic_block.parse!(@compiler) === @basic_block
              
              test_block = ::WebBlocks::Core::Block.new @base_directory + @components_directory + @basic_block_name
              test_block.with_compiler @compiler
              assert_nothing_raised { test_block.parse! }
              
              test_does_not_exist_block = ::WebBlocks::Core::Block.new @base_directory + @components_directory + @basic_component_name
              assert_raise(Errno::ENOENT) { test_does_not_exist_block.parse! @compiler }
              
            end
            
            def test_parsed?
              
              assert !@basic_block.parsed?
              assert @basic_block.parse! @compiler
              assert @basic_block.parsed?
              
            end
            
            def test_blocks
              
              assert @basic_block.with_compiler(@compiler).blocks === @compiler.blocks
              
            end
            
            def test_components
              
              assert @basic_block.with_compiler(@compiler).components === @compiler.components
              
            end
            
            def test_source_directory
              
              assert !@basic_block.source_directory
              @basic_block.source_directory 'test'
              assert @basic_block.source_directory == 'test'
              @basic_block.source_directory = 'test2'
              assert @basic_block.source_directory == 'test2'
              
            end
            
            def test_integration
              
              File.open(@base_directory + @components_directory + @block_name + 'Blocksfile.rb', 'w') do |file|
                
                file.puts "block '#{@block_name}' do"
                
                file.puts "  source_directory 'sd'"
                
                file.puts "  scss_file 's1'"
                file.puts "  scss_file 's2'"
                file.puts "  scss_file 's3'"
                
                # ld dependencies -> s1
                file.puts "  scss_file 'ld' do"
                file.puts "    after scss_file 's1'"
                file.puts "  end"
                
                # ld2 dependencies -> s1, s2
                file.puts "  scss_file 'ld2' do"
                file.puts "    after scss_file 's1'"
                file.puts "    after scss_file 's2'"
                file.puts "  end"
                
                # lld loose_dependencies -> s1
                file.puts "  scss_file 'lld' do"
                file.puts "    after_if_exists scss_file 's1'"
                file.puts "  end"
                
                # lld2 loose_dependencies -> s1, s2
                file.puts "  scss_file 'lld2' do "
                file.puts "    after_if_exists scss_file 's1'"
                file.puts "    after_if_exists scss_file 's2'"
                file.puts "  end"
                
                # rld reverse_dependencies -> s1
                file.puts "  scss_file 'rld' do "
                file.puts "    before scss_file 's1'"
                file.puts "  end"
                
                # rld2 reverse_dependencies -> s1, s2
                file.puts "  scss_file 'rld2' do "
                file.puts "    before scss_file 's1'"
                file.puts "    before scss_file 's2'"
                file.puts "  end"
                
                # lrld loose_reverse_dependencies -> s1
                file.puts "  scss_file 'lrld' do "
                file.puts "    before_if_exists scss_file 's1'"
                file.puts "  end"
                
                # lrld2 loose_reverse_dependencies -> s1, s2
                file.puts "  scss_file 'lrld2' do "
                file.puts "    before_if_exists scss_file 's1'"
                file.puts "    before_if_exists scss_file 's2'"
                file.puts "  end"
                
                # rd dependencies -> s1
                file.puts "  scss_file 'rd' do"
                file.puts "    after block('#{@basic_block_name}') { scss_file 's1' }"
                file.puts "  end"
                
                # lrd loose_dependencies -> s1
                file.puts "  scss_file 'lrd' do"
                file.puts "    after_if_exists block('#{@basic_block_name}') { scss_file 's1' }"
                file.puts "  end"
                
                # rrd reverse_dependencies -> s1
                file.puts "  scss_file 'rrd' do"
                file.puts "    before block('#{@basic_block_name}') { scss_file 's1' }"
                file.puts "  end"
                
                # rlrd loose_reverse_dependencies -> s1
                file.puts "  scss_file 'lrrd' do"
                file.puts "    before_if_exists block('#{@basic_block_name}') { scss_file 's1' }"
                file.puts "  end"
                
                file.puts "end"
                
              end
              
              block = @compiler.blocks[@block_name]
              block.parse! @compiler
              
              ['s1','s2','s3','ld','ld2','lld','lld2','rld','rld2','lrld','lrld2','rd','lrd','rrd','lrrd'].each do |file|
                assert block.scss_files.has_key?(file)
              end
              
              assert block.scss_files['ld'].dependencies.first.name == 's1'
              assert block.scss_files['ld'].dependencies.first.block.name == @block_name
              assert block.scss_files['ld'].loose_dependencies.length == 0
              assert block.scss_files['ld'].reverse_dependencies.length == 0
              assert block.scss_files['ld'].loose_reverse_dependencies.length == 0
              
              assert block.scss_files['ld2'].dependencies.first.name == 's1'
              assert block.scss_files['ld2'].dependencies.first.block.name == @block_name
              assert block.scss_files['ld2'].dependencies.last.name == 's2'
              assert block.scss_files['ld2'].dependencies.last.block.name == @block_name
              assert block.scss_files['ld2'].loose_dependencies.length == 0
              assert block.scss_files['ld2'].reverse_dependencies.length == 0
              assert block.scss_files['ld2'].loose_reverse_dependencies.length == 0
              
              assert block.scss_files['lld'].dependencies.length == 0
              assert block.scss_files['lld'].loose_dependencies.first.name == 's1'
              assert block.scss_files['lld'].loose_dependencies.first.block.name == @block_name
              assert block.scss_files['lld'].reverse_dependencies.length == 0
              assert block.scss_files['lld'].loose_reverse_dependencies.length == 0
              
              assert block.scss_files['lld2'].dependencies.length == 0
              assert block.scss_files['lld2'].loose_dependencies.first.name == 's1'
              assert block.scss_files['lld2'].loose_dependencies.first.block.name == @block_name
              assert block.scss_files['lld2'].loose_dependencies.last.name == 's2'
              assert block.scss_files['lld2'].loose_dependencies.last.block.name == @block_name
              assert block.scss_files['lld2'].reverse_dependencies.length == 0
              assert block.scss_files['lld2'].loose_reverse_dependencies.length == 0
              
              assert block.scss_files['rld'].dependencies.length == 0
              assert block.scss_files['rld'].loose_dependencies.length == 0
              assert block.scss_files['rld'].reverse_dependencies.first.name == 's1'
              assert block.scss_files['rld'].reverse_dependencies.first.block.name == @block_name
              assert block.scss_files['rld'].loose_reverse_dependencies.length == 0
              
              assert block.scss_files['rld2'].dependencies.length == 0
              assert block.scss_files['rld2'].loose_dependencies.length == 0
              assert block.scss_files['rld2'].reverse_dependencies.first.name == 's1'
              assert block.scss_files['rld2'].reverse_dependencies.first.block.name == @block_name
              assert block.scss_files['rld2'].reverse_dependencies.last.name == 's2'
              assert block.scss_files['rld2'].reverse_dependencies.last.block.name == @block_name
              assert block.scss_files['rld2'].loose_reverse_dependencies.length == 0
              
              assert block.scss_files['lrld'].dependencies.length == 0
              assert block.scss_files['lrld'].loose_dependencies.length == 0
              assert block.scss_files['lrld'].reverse_dependencies.length == 0
              assert block.scss_files['lrld'].loose_reverse_dependencies.first.name == 's1'
              assert block.scss_files['lrld'].loose_reverse_dependencies.first.block.name == @block_name
              
              assert block.scss_files['lrld2'].dependencies.length == 0
              assert block.scss_files['lrld2'].loose_dependencies.length == 0
              assert block.scss_files['lrld2'].reverse_dependencies.length == 0
              assert block.scss_files['lrld2'].loose_reverse_dependencies.first.name == 's1'
              assert block.scss_files['lrld2'].loose_reverse_dependencies.first.block.name == @block_name
              assert block.scss_files['lrld2'].loose_reverse_dependencies.last.name == 's2'
              assert block.scss_files['lrld2'].loose_reverse_dependencies.last.block.name == @block_name
              
              assert block.scss_files['rd'].dependencies.first.name == 's1'
              assert block.scss_files['rd'].dependencies.first.block.name == @basic_block_name
              assert block.scss_files['lrd'].loose_dependencies.first.name == 's1'
              assert block.scss_files['lrd'].loose_dependencies.first.block.name == @basic_block_name
              assert block.scss_files['rrd'].reverse_dependencies.first.name == 's1'
              assert block.scss_files['rrd'].reverse_dependencies.first.block.name == @basic_block_name
              assert block.scss_files['lrrd'].loose_reverse_dependencies.first.name == 's1'
              assert block.scss_files['lrrd'].loose_reverse_dependencies.first.block.name == @basic_block_name
              
            end
            
          end
      
        end
      end
    end
  end
end