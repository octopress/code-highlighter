module Octopress
  module CodeStyle
    class Renderer
      attr_accessor :code, :options, :lang

      def initialize(code, options = {})
        @code    = code
        @options = options.delete_if { |k,v| v.nil? }
        @options = DEFAULTS.merge(@options)
        @aliases = @options[:aliases]
        @aliases = (@aliases ? stringify_keys(@aliases) : {})
        @lang = @options[:lang]
      end

      def highlight
        options[:title] ||= ' ' if options[:url]
        if cache = Cache.read_cache(code, options)
          cache
        else
          if options[:lang].empty? || options[:lang] == 'plain'
            rendered_code = encode_liquid(code.gsub('<','&lt;')).to_s
          else
            rendered_code = render
          end
          rendered_code = tableize_code(rendered_code)
          title = captionize(options[:title], options[:url], options[:link_text]) if options[:title]
          rendered_code = "<figure class='octopress-code-figure'>#{title}#{rendered_code}</figure>"
          rendered_code = "{% raw %}#{rendered_code}{% endraw %}" if options[:escape]
          Cache.write_to_cache(rendered_code, options) unless options[:no_cache]
          rendered_code
        end
      end

      def render
        lexer = Rouge::Lexer.find(lang) || Rouge::Lexer.find(@aliases[lang])
        lexer = Rouge::Lexers::PlainText unless lexer
        formatter = ::Rouge::Formatters::HTML.new()
        code = formatter.format(lexer.lex(@code))
        code = code.match(/<pre.+?>(.+)<\/pre>/m)[1].strip #strip out divs <div class="highlight">
        code = encode_liquid(code).to_s
      end

      def captionize (caption, url, link_text)
        figcaption  = "<figcaption class='octopress-code-caption'><span class='octopress-code-caption-title'>#{caption}</span>"
        figcaption += "<a class='octopress-code-caption-link' href='#{url}'>#{(link_text || 'link').strip}</a>" if url
        figcaption += "</figcaption>"
      end

      def tableize_code (code)
        start = options[:start]
        lines = options[:linenos]
        marks = options[:marks]

        table = "<div class='octopress-code'>"
        table += "<pre class='octopress-code-pre'>"
        code.lines.each_with_index do |line,index|
          classes = 'octopress-code-row'
          classes += lines ? ' numbered' : ' unnumbered'
          if marks.include? index + start
            classes += ' marked-line'
            classes += ' start-marked-line' unless marks.include? index - 1 + start
            classes += ' end-marked-line' unless marks.include? index + 1 + start
          end
          line = line.strip.empty? ? ' ' : line
          table += "<div data-line='#{index + start}' class='#{classes}'><div class='octopress-code-line'>#{line}</div></div>"
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
