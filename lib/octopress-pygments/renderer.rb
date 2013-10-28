module Octopress
  module Pygments
    class Renderer
      attr_accessor :code, :options, :lang

      def initialize(code, options = {})
        @code    = code
        @options = options
        @aliases = @options[:aliases]
        @aliases = (@aliases ? stringify_keys(@aliases) : {})
        @lang    = determine_lang(@options[:lang])
      end

      def highlight
        @options[:title] ||= ' ' if @options[:url]
        if cache = Cache.read_cache(code, @options)
          cache
        else
          if @lang == 'plain'
            rendered_code = code.to_s.gsub('<','&lt;')
          else
            rendered_code = render_pygments(code, @lang).match(/<pre>(.+)<\/pre>/m)[1].gsub(/ *$/, '') #strip out divs <div class="highlight">
          end
          rendered_code = tableize_code(rendered_code, @lang, {linenos: @options[:linenos], start: @options[:start], marks: @options[:marks]})
          title = captionize(@options[:title], @options[:url], @options[:link_text]) if @options[:title]
          rendered_code = "<figure class='code'>#{title}#{rendered_code}</figure>"
          Cache.write_to_cache(rendered_code, @options) unless @options[:no_cache]
          rendered_code
        end
      end

      def determine_lang(lang)
        if lang == '' or lang.nil? or !lang
          lang = 'plain'
        elsif ::Pygments::Lexer.find lang 
          lang
        elsif !@aliases[lang].nil? and ::Pygments::Lexer.find @aliases[lang]
          @aliases[lang]
        else
          'plain'
        end
      end

      def render_pygments(code, lang)
        highlighted_code = ::Pygments.highlight(
          code,
          {
            lexer:     lang,
            formatter: 'html',
            options: {
              encoding: 'utf-8'
            }
          }
        )
        encode_liquid(highlighted_code).to_s
      end

      def captionize (caption, url, link_text)
        figcaption  = "<figcaption>#{caption}"
        figcaption += "<a href='#{url}'>#{(link_text || 'link').strip}</a>" if url
        figcaption += "</figcaption>"
      end

      def tableize_code (code, lang, options = {})
        start = options[:start] || 1
        lines = options[:linenos] || true
        marks = options[:marks] || []
        table = "<div class='highlight'><table><tr>"
        table += number_lines(start, code.lines.count, marks) if lines
        table += "<td class='main #{'unnumbered' unless lines} #{lang}'><pre>"
        code.lines.each_with_index do |line,index|
          classes = 'line'
          if marks.include? index + start
            classes += ' marked'
            classes += ' start' unless marks.include? index - 1 + start
            classes += ' end' unless marks.include? index + 1 + start
          end
          line = line.strip.empty? ? ' ' : line
          table += "<div class='#{classes}'>#{line}</div>"
        end
        table +="</pre></td></tr></table></div>"
      end

      def number_lines (start, count, marks)
        start ||= 1
        lines = "<td class='line-numbers' aria-hidden='true'><pre>"
        count.times do |index|
          classes = 'line-number'
          if marks.include? index + start
            classes += ' marked'
            classes += ' start' unless marks.include? index - 1 + start
            classes += ' end' unless marks.include? index + 1 + start
          end
          lines += "<div data-line='#{index + start}' class='#{classes}'></div>"
        end
        lines += "</pre></td>"
      end

      # Public:
      #
      #
      def get_range(code, start, endline)
        length    = code.lines.count
        start   ||= 1
        endline ||= length
        if start > 1 or endline < length
          raise "#{filepath} is #{length} lines long, cannot begin at line #{start}" if start > length
          raise "#{filepath} is #{length} lines long, cannot read beyond line #{endline}" if endline > length
          code = code.split(/\n/).slice(start - 1, endline + 1 - start).join("\n")
        end
        code
      end

      def encode_liquid(code)
        code.gsub(/{{/, '&#x7b;&#x7b;')
          .gsub(/{%/, '&#x7b;&#x25;')
      end

      private

      def stringify_keys(hash)
        hash.inject({}){|result, (key, value)|
          new_key = case key
                    when String then key.to_s
                    else key
                    end
        new_value = case value
                    when Hash then stringify_keys(value)
                    else value
                    end
        result[new_key] = new_value
        result
        }
      end
    end
  end
end
