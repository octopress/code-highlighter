module Octopress
  module CodeHighlighter
    Jekyll::Hooks.register :site, :post_write do |site|
      Octopress::CodeHighlighter::Cache.write
      Octopress::CodeHighlighter::Cache.clean
    end
  end
end
