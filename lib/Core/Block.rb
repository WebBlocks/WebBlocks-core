require 'pathname'
require 'ostruct'
require 'docile'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative 'BlockFile/Scss'

module WebBlocks
  module Core
    class Block
      
      attr_reader :directory, :name, :blockfile
      attr_writer :source_directory
      attr_writer :compiler
      attr_reader :scss_files
      attr_accessor :last
      
      def initialize directory
        
        @directory = Pathname.new(directory).realpath
        @name = File.basename directory
        @blockfile = @directory + "Blockfile.rb"
        
        @source_directory = false
        @parsed = false
        @compiler = nil
        @scss_files = {}
        
        @last = OpenStruct.new
        @last.scss = []
        
      end
      
      def parsed?
        
        @parsed
        
      end
      
      def has_compiler?
        
        @compiler != nil
        
      end
      
      def with_compiler compiler
        
        @compiler = compiler
        self
        
      end
      
      def parse! a_compiler = nil
        
        unless parsed?
          
          with_compiler a_compiler if a_compiler
          raise 'Block must invoke `with_compiler` or pass compiler to `parse!`' unless has_compiler?
          
          @parsed = true
          instance_eval File.open(blockfile).read
          
        end
        
        self
        
      end
      
      def reset_last!
        last.scss.clear
      end
      
      # DSL
      
      def compiler
        
        raise 'Block must invoke `with_compiler`' unless has_compiler?
        @compiler
        
      end
      
      def blocks
        
        compiler.blocks
        
      end
      
      def components
        
        compiler.components
        
      end
        
      def source_directory source_directory = nil
        
        @source_directory = source_directory unless source_directory == nil
        @source_directory
        
      end
        
      def block name, &block
        
        compiler.blocks[name].parse! compiler
        compiler.blocks[name].reset_last!
        Docile.dsl_eval(compiler.blocks[name], &block)
        compiler.blocks[name]
        
      end
        
      def scss_file file, &block
        
        @scss_files[file] = BlockFile::Scss.new(file, self) unless @scss_files.include? file
        Docile.dsl_eval(@scss_files[file], &block) if block_given?
        last.scss << @scss_files[file]
        @scss_files[file]
        
      end
      
    end
  end
end