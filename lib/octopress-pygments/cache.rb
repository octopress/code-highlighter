module Octopress
  module Pygments
    class Cache
      PYGMENTS_CACHE_DIR = '.pygments-cache'

      class << self
        def fetch_from_cache(code, options)
          path  = options[:cache_path] || get_cache_path(PYGMENTS_CACHE_DIR, options[:lang], options.to_s + code)
          cache = read_cache(path)
        end

        def write_to_cache(contents, options)
          FileUtils.mkdir_p(PYGMENTS_CACHE_DIR) unless File.directory?(PYGMENTS_CACHE_DIR)
          path = options[:cache_path] || get_cache_path(PYGMENTS_CACHE_DIR, options[:lang], options.to_s + code)
          File.open(path, 'w') do |f|
            f.print(contents)
          end
        end

        def read_cache(path)
          File.exist?(path) ? File.read(path) : nil unless path.nil?
        end

        def get_cache_path(dir, name, str)
          File.join(dir, "#{name}-#{Digest::MD5.hexdigest(str)}.html")
        end
      end
    end
  end
end
