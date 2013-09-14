require 'fileutils'
require 'systemu'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative 'Base'
require_relative '../Support/Bower'

module WebBlocks
  module Core
    module CompilerTask
      class Setup < Base
        
        def run
          Dir.chdir @compiler.base_directory do
            ::WebBlocks::Core::Support::Bower.command 'install'
          end
        end
        
      end
    end
  end
end