module Prawn
  module Formatter
    module Instructions

      class Base
        attr_reader :state, :ascent, :descent

        def initialize(state)
          @state = state
          state.font.size(state.font_size) do
            @height = state.font.height
            @ascent = state.font.ascender
            @descent = state.font.descender
          end
        end

        def spaces
          0
        end

        def width(*args)
          0
        end

        def height(*args)
          @height
        end

        def break?
          false
        end

        def force_break?
          false
        end

        def discardable?
          false
        end

        def start_box?
          false
        end

        def end_box?
          false
        end

        def style
          {}
        end

        def flush(document, draw_state)
          if draw_state[:accumulator]
            draw_state[:accumulator].draw!(document, draw_state)
            draw_state.delete(:accumulator)
          end
        end
      end

    end
  end
end
