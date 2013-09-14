require 'tsort'

module WebBlocks
  module Core
    module Support
      module TSort
        class CyclicComponent < ::TSort::Cyclic
          attr_accessor :component
          def initialize component
            @component = component
            super("topological sort failed: #{component.inspect}")
          end
        end
      end
    end
  end
end