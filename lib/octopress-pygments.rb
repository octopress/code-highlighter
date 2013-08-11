require "octopress-pygments/version"
require 'fileutils'
require 'digest/md5'
require 'pygments'
require 'colorator'

PYGMENTS_CACHE_DIR = '.pygments-cache'
FileUtils.mkdir_p(PYGMENTS_CACHE_DIR)

module Octopress
  module Pygments
    autoload :Cache,         'octopress-pygments/cache'
    autoload :OptionsParser, 'octopress-pygments/options_parser'
    autoload :Renderer,      'octopress-pygments/renderer'

    def self.highlight(code, options = {})
      Renderer.new(code, options).highlight
    end

    def self.parse_markup(input, defaults={})
      OptionsParser.new(input).parse_markup(defaults)
    end

    def self.clean_markup(input)
      OptionsParser.new(input).clean_markup
    end

    def self.highlight_failed(error, syntax, markup, code, file = nil)
      code_snippet = code.split("\n")[0..9].map{|l| "    #{l}" }.join("\n")
      fail_message  = "\nPygments Error while parsing the following markup#{" in #{file}" if file}:\n\n".red
      fail_message += "    #{markup}\n#{code_snippet}\n"
      fail_message += "#{"    ..." if code.split("\n").size > 10}\n"
      fail_message += "\nValid Syntax:\n\n#{syntax}\n".yellow
      fail_message += "\nPygments Error:\n\n#{error.message}".red
      $stderr.puts fail_message.chomp
      raise ArgumentError
    end
  end
end

