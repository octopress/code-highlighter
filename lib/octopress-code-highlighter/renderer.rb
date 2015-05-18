module Octopress
  module CodeHighlighter
    class Renderer
      attr_reader :code, :options, :lang

      def initialize(code, options = {})
        @code    = code
        @options = options.delete_if { |k,v| v.nil? }
        @options = DEFAULTS.merge(@options)
        if defined? Octopress.config
          @aliases = Octopress.config['code_aliases']
        elsif defined? Ink
          @aliases = Ink.config['code_aliases']
        end
        @aliases ||= stringify_keys(@options[:aliases] || {})
        @lang = @options[:lang]
        @options[:title] ||= ' ' if @options[:url]
        @renderer = select_renderer
      end

      def select_renderer
        case true
          when renderer_available?('rouge')
            require 'rouge'
            return  'rouge'
          when renderer_available?('pygments.rb')
            require 'pygments'
            return  'pygments'
        else
          $stderr.puts 'No syntax highlighting:'.yellow
          $stderr.puts "\tInstall pygments.rb, rouge".yellow
        end
  
        'plain'
      end
      
      def renderer_available?(which)
        Gem::Specification::find_all_by_name(which).any?
      end

      def highlight
        if cache = Cache.read_cache(code, options)
          cache
        else
          rendered_code = render
          rendered_code = escape_characters(rendered_code)
          rendered_code = tableize_code(rendered_code)
          classnames = 'code-highlight-figure'
          if options[:class]
            classnames << ' ' + options[:class]
          end
          rendered_code = "<figure class='#{classnames}'>#{caption}#{rendered_code}</figure>"
          rendered_code = "{% raw %}#{rendered_code}{% endraw %}" if options[:escape]
          Cache.write_to_cache(rendered_code, code, options) unless options[:no_cache]
          rendered_code
        end
      end

      def plain?
        options[:lang].empty? || options[:lang] == 'plain'
      end

      def render
        case @renderer
        when 'pygments'
          code = render_pygments
        when 'rouge'
          code = render_rouge
        else
          code = render_plain
        end

        if code =~ /<pre.*?>(.+?)<\/pre>/m
          code = $1.strip
        end

        # Force wrapping after tags
        code.gsub(/\n<\/span>/, "</span>\n")
      end

      def render_plain
        @code.gsub('<','&lt;') 
      end

      def render_pygments
        if lexer = Pygments::Lexer.find(lang) || Pygments::Lexer.find(@aliases[lang])
          begin
            options = { encoding: 'utf-8' }
            if lang =~ /php/ 
              options[:startinline] = @options[:startinline] || true
            end
            lexer.highlight @code, {
              formatter: 'html',
              options: options
            }
          rescue MentosError => e
            raise e
          end
        else
          render_plain
        end
      end

      def render_rouge
        if lexer = Rouge::Lexer.find(lang) || Rouge::Lexer.find(@aliases[lang])
          formatter = ::Rouge::Formatters::HTML.new(wrap: false)
          formatter.format(lexer.lex(@code))
        else
          render_plain
        end
      end

      def caption
        if options[:title]
          figcaption  = "<figcaption class='code-highlight-caption'><span class='code-highlight-caption-title'>#{options[:title]}</span>"
          figcaption += "<a class='code-highlight-caption-link' href='#{options[:url]}'>#{(options[:link_text] || 'link').strip}</a>" if options[:url]
          figcaption += "</figcaption>"
        else
          ''
        end
      end

      def tableize_code(code)
        start = options[:start]
        lines = options[:linenos]
        marks = options[:marks]

        table = "<div class='code-highlight'>"
        table += "<pre class='code-highlight-pre'>"
        code.lines.each_with_index do |line,index|
          classes = 'code-highlight-row'
          classes += lines ? ' numbered' : ' unnumbered'
          if marks.include? index + start
            classes += ' marked-line'
            classes += ' start-marked-line' unless marks.include? index - 1 + start
            classes += ' end-marked-line' unless marks.include? index + 1 + start
          end
          line = line.strip.empty? ? ' ' : line
          table += "<div data-line='#{index + start}' class='#{classes}'><div class='code-highlight-line'>#{line}</div></div>"
        end
        table +="</pre></div>"
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
          code = code.split(/\n/).slice(start - 1, endline + 1).join("\n")
        end
        code
      end

      def escape_characters(code)
        code.gsub(/{/, '&#x7b;').gsub(/}/, '&#x7d;')
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

