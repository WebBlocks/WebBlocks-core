require 'extensions/kernel' if defined?(require_relative).nil?
require_relative 'CompilerTask'

module WebBlocks
  module Core
    class Compiler
      
      attr_accessor :options
      attr_accessor :component_factory
      attr_accessor :block_factory
      
      def initialize options = {}
        
        @options = default_options.merge options
        @component_factory = @options[:component_factory].new components_directory
        @block_factory = @component_factory.block_factory @options[:block_factory]
        
      end
      
      def base_directory
        @base_directory ||= Pathname.new(@options[:base_directory]).realpath
      end
      
      def components_directory
        @components_directory ||= (base_directory + @options[:components_directory])
      end
      
      def components
        @component_factory.components
      end
      
      def blocks
        @block_factory.blocks
      end
      
      def default_options
        
        {
          :base_directory => Pathname.new(__FILE__).parent.parent.parent,
          :components_directory => 'bower_components',
          :component_factory => ::WebBlocks::Core::ComponentFactory,
          :block_factory => ::WebBlocks::Core::BlockFactory
        }
        
      end
      
      def run task
        if task.is_a? Array
          task.each { |task| run task }
        else
          dispatch task
        end
      end
      
      def dispatch task
        unless task[0,2] == '::'
          task = instance_eval "CompilerTask::#{task.slice(0,1).capitalize + task.slice(1..-1)}"
        else
          task = eval task
        end
        task.new(self).run
      end
      
    end
  end
end