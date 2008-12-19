module Prawn
  module Formatter
    class State
      attr_reader :document
      attr_reader :original_style, :style

      def initialize(document, options={})
        @document = document
        @previous = options[:previous]

        @original_style = (@previous && @previous.inheritable_style || {}).
          merge(options[:style] || {})

        compute_styles!
      end

      def inheritable_style
        @inheritable_style ||= begin
          subset = original_style.dup
          subset.delete(:meta)
          subset.delete(:display)
          subset.delete(:text_indent)
          subset.delete(:margin_left)
          subset.delete(:margin_right)
          subset.delete(:margin_top)
          subset.delete(:margin_bottom)
          subset.delete(:width)
          subset
        end
      end

      def kerning?
        @style[:kerning]
      end

      def display
        @style[:display] || :inline
      end

      def text_align
        @style[:text_align] || :left
      end

      def font_size
        @style[:font_size] || 12
      end

      def font_family
        @style[:font_family] || "Helvetica"
      end

      def font_style
        @style[:font_style] || :normal
      end

      def font_weight
        @style[:font_weight] || :normal
      end

      def color
        @style[:color] || "000000"
      end

      def vertical_align
        @style[:vertical_align] || 0
      end

      def text_indent
        @style[:text_indent] || 0
      end

      def text_decoration
        @style[:text_decoration] || :none
      end

      def font
        @font ||= document.find_font(font_family, :style => pdf_font_style)
      end

      def pdf_font_style
        if bold? && italic?
          :bold_italic
        elsif bold?
          :bold
        elsif italic?
          :italic
        else
          :normal
        end
      end

      def with_style(style)
        self.class.new(document, :previous => self, :style => style)
      end

      def apply!(text_object, cookies)
        if cookies[:font] != [font_family, pdf_font_style, font_size]
          cookies[:font] = [font_family, pdf_font_style, font_size]
          font = document.font(font_family, :style => pdf_font_style)
          text_object.font(font.identifier, font_size)
        end

        if cookies[:color] != color
          cookies[:color] = color
          text_object.fill_color(color)
        end

        if cookies[:vertical_align] != vertical_align
          cookies[:vertical_align] = vertical_align
          text_object.rise(vertical_align)
        end
      end

      def italic?
        font_style == :italic || font_style == :bold_italic
      end

      def bold?
        font_style == :bold || font_style == :bold_italic
      end

      def previous(attr=nil, default=nil)
        return @previous unless attr
        return default unless @previous
        return @previous.send(attr) || default
      end

      private

        def compute_styles!
          @style = @original_style.dup

          evaluate_style(:font_size, 12, :current)
          evaluate_style(:text_indent, nil, :current)
          evaluate_style(:vertical_align, 0, font_size, :super => "+40%", :sub => "-30%")
        end

        def evaluate_style(which, default, relative_to, mappings={})
          current = previous(which, default)
          relative_to = current if relative_to == :current
          @style[which] = document.evaluate_measure(@style[which],
            :em => @previous && @previous.font_size || 12,
            :current => current, :relative => relative_to, :mappings => mappings) || default
        end
    end
  end
end
