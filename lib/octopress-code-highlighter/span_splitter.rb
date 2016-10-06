module Octopress
  module CodeHighlighter
    class SpanSplitter
      START_REGEX = %r{(<span[^>]*>)(?:(?!</span>).)*$}
      END_REGEX = %r{^[^<]*</span>}

      def self.split(code)
        new(code).call
      end

      def initialize(code)
        @code = code
      end

      def call
        active_span = nil
        code.lines.map do |line|
          prefix = active_span || ""
          active_span = nil if END_REGEX =~ line
          match = START_REGEX.match(line)
          active_span = match[1] if match
          suffix = active_span ? "</span>" : ""
          "#{prefix}#{line.chomp}#{suffix}\n"
        end.join
      end

      private

      attr_reader :code
    end
  end
end
