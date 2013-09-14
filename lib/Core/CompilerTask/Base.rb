module WebBlocks
  module Core
    module CompilerTask
      class Base
        
        def initialize compiler
          @compiler = compiler
        end
        
        def name
          self.class.name
        end
        
        def run
          raise 'Task does not exist'
        end
        
      end
    end
  end
end