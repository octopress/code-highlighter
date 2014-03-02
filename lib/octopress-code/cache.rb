module Octopress
  module Code
    class Cache
      CODE_CACHE_DIR = '.code-style-cache'

      class << self
        def read_cache(code, options)
          cache_label = options[:cache_label] || options[:lang] || ''
          path = get_cache_path(CODE_CACHE_DIR, cache_label, options.to_s + code)
          File.exist?(path) ? File.read(path) : nil unless path.nil?
        end

        def write_to_cache(contents, options)
          FileUtils.mkdir_p(CODE_CACHE_DIR) unless File.directory?(CODE_CACHE_DIR)
          cache_label = options[:cache_label] || options[:lang] || ''
          path = get_cache_path(CODE_CACHE_DIR, cache_label, options.to_s + contents)
          File.open(path, 'w') do |f|
            f.print(contents)
          end
        end

        def get_cache_path(dir, label, str)
          label += '-' unless label === ''
          File.join(dir, "#{label}#{Digest::MD5.hexdigest(str)}.html")
        end
      end
    end
  end
end
