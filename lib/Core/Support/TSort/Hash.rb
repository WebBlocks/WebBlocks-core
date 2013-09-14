require 'extensions/kernel' if defined?(require_relative).nil?
require 'tsort'
require_relative 'CyclicComponent'

module WebBlocks
  module Core
    module Support
      module TSort
        class Hash < ::Hash
          include ::TSort
          alias tsort_each_node each_key
          def tsort_each_child(node, &block)
            fetch(node).each(&block)
          end
          def tsort_each
            each_strongly_connected_component {|component|
              if component.size == 1
                yield component.first
              else
                raise CyclicComponent.new(component)
              end
            }
          end
        end
      end
    end
  end
end