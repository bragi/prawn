require 'prawn/formatter/instructions/base'

module Prawn
  module Formatter
    module Instructions

      class TagClose < Base
        def self.close(state, tag, draw_state)
          closer = new(state, tag)
          closer.draw(state.document, draw_state)
        end

        attr_reader :tag

        def initialize(state, tag)
          super(state)
          @tag = tag
        end

        def [](property)
          @tag[:style][property]
        end

        def draw(document, draw_state, options={})
          flush(document, draw_state)
          (@tag[:effects] || []).each do |effect|
            effect.finish(document, draw_state)
            draw_state[:pending_effects].delete(effect)
          end
        end

        def break?
          force_break?
        end

        def style
          @tag[:style]
        end

        def force_break?
          @tag[:style][:display] == :block || @tag[:style][:display] == :break
        end

        def end_box?
          @tag[:style][:display] == :block
        end
      end

    end
  end
end
