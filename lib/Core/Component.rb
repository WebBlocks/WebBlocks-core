require 'pathname'

module WebBlocks
  module Core
    class Component
      
      attr_accessor :directory, :name
      
      def initialize directory
        @directory = Pathname.new(directory).realpath
        @name = File.basename directory
      end
      
    end
  end
end