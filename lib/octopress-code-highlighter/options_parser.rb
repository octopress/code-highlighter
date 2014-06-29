module Octopress
  module CodeHighlighter
    class OptionsParser
      attr_accessor :input

      def initialize(markup)
        @input = markup.strip
      end

      def clean_markup
        input.sub(/\s*lang:\s*\S+/i,'')
          .sub(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i,'')
          .sub(/\s*url:\s*(\S+)/i,'')
          .sub(/\s*link_text:\s*(("(.+?)")|('(.+?)')|(\S+))/i,'')
          .sub(/\s*mark:\s*\d\S*/i,'')
          .sub(/\s*linenos:\s*\w+/i,'')
          .sub(/\s*start:\s*\d+/i,'')
          .sub(/\s*end:\s*\d+/i,'')
          .sub(/\s*range:\s*\d+-\d+/i,'')
          .sub(/\s*escape:\s*\w+/i,'')
          .sub(/\s*startinline:\s*\w+/i,'')
          .sub(/\s*class:\s*(("(.+?)")|('(.+?)')|(\S+))/i,'')
      end

      def parse_markup(defaults = {})
        options = {
          lang:      lang,
          url:       url,
          title:     title,
          linenos:   linenos,
          marks:     marks,
          link_text: link_text,
          start:     start,
          end:       endline,
          escape:    escape,
          startinline: startinline,
          class:     classnames
        }
        options = options.delete_if { |k,v| v.nil? }
        defaults.merge(options)
      end
      
      def lang
        extract(/\s*lang:\s*(\S+)/i)
      end

      def startinline
        boolize(extract(/\s*startinline:\s*(\w+)/i))
      end

      def classnames
        extract(/\s*class:\s*(("(.+?)")|('(.+?)')|(\S+))/i, [3, 5, 6])
      end

      def url
        extract(/\s*url:\s*(("(.+?)")|('(.+?)')|(\S+))/i, [3, 5, 6])
      end

      def title
        extract(/\s*title:\s*(("(.+?)")|('(.+?)')|(\S+))/i, [3, 5, 6])
      end

      def linenos
        boolize(extract(/\s*linenos:\s*(\w+)/i))
      end

      def escape
        boolize(extract(/\s*escape:\s*(\w+)/i))
      end

      # Public: Matches pattern for line marks and returns array of line
      #         numbers to mark
      #
      # Example input
      #   Input:  "mark:1,5-10,2"
      #   Output: [1,2,5,6,7,8,9,10]
      #
      # Returns an array of integers corresponding to the lines which are
      #   indicated as marked
      def marks
        marks = []
        if input =~ / *mark:(\d\S*)/i
          marks = $1.gsub /(\d+)-(\d+)/ do
            ($1.to_i..$2.to_i).to_a.join(',')
          end
          marks = marks.split(',').collect {|s| s.to_i}.sort
        end
        marks
      end

      def link_text
        extract(/\s*link[-_]text:\s*(("(.+?)")|('(.+?)')|(\S+))/i, [3, 5, 6], 'link')
      end

      def start
        if range
          range.first
        else
          num = extract(/\s*start:\s*(\d+)/i)
          num = num.to_i unless num.nil?
          num
        end
      end

      def endline
        if range
          range.last
        else
          num = extract(/\s*end:\s*(\d+)/i)
          num = num.to_i unless num.nil?
          num
        end
      end

      def range
        if input.match(/ *range:(\d+)-(\d+)/i)
          [$1.to_i, $2.to_i]
        end
      end

      def extract(regexp, indices_to_try = [1], default = nil)
        thing = input.match(regexp)
        if thing.nil?
          default
        else
          indices_to_try.each do |index|
            return thing[index] if thing[index]
          end
        end
      end

      def boolize(str)
        return nil if str.nil?
        return true if str == true || str =~ (/(true|t|yes|y|1)$/i)
        return false if str == false || str =~ (/(false|f|no|n|0)$/i) || str.strip.size > 1
        return str
      end
    end
  end
end

