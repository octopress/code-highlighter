require 'octopress-code/version'
require 'fileutils'
require 'digest/md5'
require 'rouge'
require 'colorator'
require 'octopress-ink'

CODE_CACHE_DIR = '.code-cache'
FileUtils.mkdir_p(CODE_CACHE_DIR)

module Octopress
  module Code
    DEFAULTS = {
      lang: 'plain',
      linenos: true,
      marks: [],
      start: 1
    }

    autoload :Cache,         'octopress-code/cache'
    autoload :OptionsParser, 'octopress-code/options_parser'
    autoload :Renderer,      'octopress-code/renderer'

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

class Code < Octopress::Ink::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__), '../assets'))
    @version = Octopress::Code::VERSION
    @description = "For beautiful code snippets."
    super
  end

  def add_assets
    add_sass 'code.scss'
  end
end

Octopress::Ink.register_plugin(Code, 'octopress-code', 'plugin')

