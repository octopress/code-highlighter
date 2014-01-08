module Octopress
  module Pygments
    class Renderer
      attr_accessor :code, :options, :lang

      def initialize(code, options = {})
        @code    = code
        @options = options.delete_if { |k,v| v.nil? }
        @options = DEFAULTS.merge(@options)
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
          rendered_code = "<figure class='pygments-code-figure'>#{title}#{rendered_code}</figure>"
          rendered_code = "{% raw %}#{rendered_code}{% endraw %}" if @options[:escape]
          Cache.write_to_cache(rendered_code, @options) unless @options[:no_cache]
          rendered_code
        end
      end

      def determine_lang(lang)
        if lang == ''
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
        figcaption  = "<figcaption class='pygments-code-caption'><span class='pygments-code-caption-title'>#{caption}</span>"
        figcaption += "<a class='pygments-code-caption-link' href='#{url}'>#{(link_text || 'link').strip}</a>" if url
        figcaption += "</figcaption>"
      end

      def tableize_code (code, lang, options = {})
        start = options[:start]
        lines = options[:linenos]
        marks = options[:marks]
        table = "<div class='pygments-code'>"
        table += "<pre class='pygments-code-pre #{lang}'>"
        code.lines.each_with_index do |line,index|
          classes = 'pygments-code-row'
          classes += lines ? ' numbered' : ' unnumbered'
          if marks.include? index + start
            classes += ' marked-line'
            classes += ' start-marked-line' unless marks.include? index - 1 + start
            classes += ' end-marked-line' unless marks.include? index + 1 + start
          end
          line = line.strip.empty? ? ' ' : line
          table += "<div data-line='#{index + start}' class='#{classes}'><div class='pygments-code-line'>#{line}</div></div>"
        end
        table +="</pre></div>"
      end

      # Public:
      #
      #
      def get_range(code, start, endline)
        length    = code.lines.count
        start
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
