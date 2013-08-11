module Octopress
  module Pygments
    class Renderer
      attr_accessor :code, :options, :lang

      def initialize(code, options = {})
        @code    = code
        @options = options
        @lang    = determine_lang
      end

      def highlight
        @options[:title] ||= ' ' if @options[:url]
        cache = Cache.fetch_from_cache(code, options)
        unless cache
         if @lang == 'plain'
            code = code.gsub('<','&lt;')
          else
            code = render_pygments(code, options[:lang]).match(/<pre>(.+)<\/pre>/m)[1].gsub(/ *$/, '') #strip out divs <div class="highlight">
          end
          code = tableize_code(code, options[:lang], {linenos: options[:linenos], start: options[:start], marks: options[:marks]})
          title = captionize(options[:title], options[:url], options[:link_text]) if options[:title]
          code = "<figure class='code'>#{title}#{code}</figure>"
          Cache.write_to_cache(code, options) unless options[:no_cache]
        end
        cache || code
      end

      def determine_lang
        lang = options[:lang]
        lang = 'ruby' if lang == 'ru'
        lang = 'objc' if lang == 'm'
        lang = 'perl' if lang == 'pl'
        lang = 'yaml' if lang == 'yml'
        lang = 'coffeescript' if lang == 'coffee'
        lang = 'csharp' if lang == 'cs'
        lang = 'plain' if lang == '' or lang.nil? or !lang
        options[:lang] = lang
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
          .gsub(/{%/, '&#x7b;&#x25;') #FIXME: remove the space here
      end
    end
  end
end
