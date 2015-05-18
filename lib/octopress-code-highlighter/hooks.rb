module Octopress
  module CodeHighlighter
    if defined?(Jekyll::Hooks)
      Jekyll::Hooks.register :site, :post_write do |site|
        Octopress::CodeHighlighter::Cache.write
        Octopress::CodeHighlighter::Cache.clean
      end
    else
      require 'octopress-hooks'
      class SiteHook < Octopress::Hooks::Site
        def post_write(site)
          Octopress::CodeHighlighter::Cache.write
          Octopress::CodeHighlighter::Cache.clean
        end
      end
    end
  end
end
