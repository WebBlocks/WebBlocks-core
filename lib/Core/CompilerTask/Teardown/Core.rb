require 'fileutils'
require 'systemu'
require 'extensions/kernel' if defined?(require_relative).nil?
require_relative '../Base'
require_relative '../../Support/Bower'

module WebBlocks
  module Core
    module CompilerTask
      module Teardown
        class Core < ::WebBlocks::Core::CompilerTask::Base

          def run
            Dir.chdir @compiler.base_directory do
              FileUtils.rm_rf @compiler.components_directory + "WebBlocks-core"
              ::WebBlocks::Core::Support::Bower.command 'cache clean'
            end
          end

        end
      end
    end
  end
end