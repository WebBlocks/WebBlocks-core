require 'systemu'

module WebBlocks
  module Core
    module Support
      class Bower
        def self.command commad 
          status, stdout, stderr = systemu "node_modules/bower/bin/bower #{commad}"
          puts stdout
          status.success?
        end
      end
    end
  end
end