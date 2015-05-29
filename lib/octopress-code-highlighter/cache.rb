require 'find'

module Octopress
  module CodeHighlighter
    module Cache
      extend self

      @cached_files = []
      @write_cache = {}

      def read_cache(code, options)
        cache_label = options[:cache_label] || options[:lang] || ''
        path = get_cache_path(CODE_CACHE_DIR, cache_label, options.to_s + code)
        @cached_files << path
        File.exist?(path) ? File.read(path) : nil unless path.nil?
      end

      def write_to_cache(contents, code, options)
        FileUtils.mkdir_p(CODE_CACHE_DIR) unless File.directory?(CODE_CACHE_DIR)
        cache_label = options[:cache_label] || options[:lang] || ''
        path = get_cache_path(CODE_CACHE_DIR, cache_label, options.to_s + code)
        @write_cache[path] = contents
      end

      def get_cache_path(dir, label, str)
        label += '-' unless label === ''
        File.join(dir, ".#{label}#{Digest::MD5.hexdigest(str)}.html")
      end

      def write
        @write_cache.each do |path, contents|
          @cached_files << path
          File.open(path, 'w') do |f|
            f.print(contents)
          end
        end
        @write_cache = {}
      end

      def clean
        if File.exist?(CODE_CACHE_DIR)
          remove = []

          Find.find(CODE_CACHE_DIR).each do |file|
            remove << file unless @cached_files.include?(file) || File.directory?(file)
          end

          @cached_files = []

          FileUtils.rm remove
        end
      end
    end
  end
end
