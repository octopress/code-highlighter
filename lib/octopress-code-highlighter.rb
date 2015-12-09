require 'octopress-code-highlighter/version'
require 'fileutils'
require 'digest/md5'
require 'jekyll'

require 'colorator'

begin require 'octopress'
rescue LoadError; end

require 'octopress-code-highlighter/hooks'

begin require 'octopress-ink'
rescue LoadError; end

require 'octopress-code-highlighter/cache'

module Octopress
  module CodeHighlighter
    DEFAULTS = {
      lang: 'plain',
      linenos: true,
      marks: [],
      start: 1
    }

    CODE_CACHE_DIR = '.code-highlighter-cache'

    autoload :OptionsParser, 'octopress-code-highlighter/options_parser'
    autoload :Renderer,      'octopress-code-highlighter/renderer'

    def self.highlight(code, options={})
      Renderer.new(code, options).highlight
    end

    def self.read_cache(code, options={})
      Cache.read_cache(code, options)
    end

    def self.parse_markup(input, defaults={})
      OptionsParser.new(input).parse_markup(defaults)
    end

    def self.clean_markup(input)
      OptionsParser.new(input).clean_markup
    end

    # Return a code partial when start, end, or range options are defined
    #
    def self.select_lines(code, options)
      length   = code.lines.count
      start    = options[:start] || 1
      endline  = options[:end] || length

      if start > 1 or endline < length
        raise "Code is #{length} lines long, cannot begin at line #{start}." if start > length
        raise "Code lines starting line #{start} cannot be after ending line #{endline}." if start > endline
        range = Range.new(start - 1, endline - 1)
        code = code.lines.to_a[range].join
      end
      code
    end

    def self.highlight_failed(error, syntax, markup, code, file = nil)
      code_snippet = code.split("\n")[0..9].map{|l| "    #{l}" }.join("\n")
      fail_message  = "\nError while parsing the following markup#{" in #{file}" if file}:\n\n".red
      fail_message += "    #{markup}\n#{code_snippet}\n"
      fail_message += "#{"    ..." if code.split("\n").size > 10}\n"
      fail_message += "\nValid Syntax:\n\n#{syntax}\n".yellow
      fail_message += "\nError:\n\n#{error.message}".red
      $stderr.puts fail_message.chomp
      raise ArgumentError
    end
  end
end
