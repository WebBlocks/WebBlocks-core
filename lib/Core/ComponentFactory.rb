require 'extensions/kernel' if defined?(require_relative).nil?
require_relative 'Component'

module WebBlocks
  module Core
    class ComponentFactory
      
      attr_accessor :components_directory

      def initialize components_directory
        @components_directory = Pathname.new(components_directory)
      end

      def directories
        @directories ||= Dir.glob("#{components_directory}/*")
      end

      def names
        @names ||= components.keys
      end
      
      def block_factory factory_class
        factory_class.new directories
      end
      
      def components
        @components ||= Hash[
          directories.map do |directory|
            component = Component.new directory
            [ component.name, component ]
          end
        ]
      end

    end
  end
end