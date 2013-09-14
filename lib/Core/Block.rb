require 'pathname'

module WebBlocks
  module Core
    class Block
      
      attr_accessor :directory, :name, :blocksfile
      
      def initialize directory
        @directory = Pathname.new(directory).realpath
        @name = File.basename directory
        @blocksfile = @directory + "Blocksfile.rb"
      end
      
    end
  end
end