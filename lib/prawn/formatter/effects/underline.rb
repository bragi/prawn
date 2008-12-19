module Prawn
  module Formatter
    module Effects

      class Underline
        def initialize(from)
          @from = from
        end

        def finish(document, draw_state)
          x1 = draw_state[:x] + @from
          x2 = draw_state[:x] + draw_state[:dx]
          y  = draw_state[:y] + draw_state[:dy] - 2

          document.move_to(x1, y)
          document.line_to(x2, y)
          document.stroke
        end

        def wrap(document, draw_state)
          finish(document, draw_state)
          @from = 0
        end
      end

    end
  end
end
