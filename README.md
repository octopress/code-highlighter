# Octopress Code Highlighter

[![Build Status](https://travis-ci.org/octopress/code-highlighter.png)](https://travis-ci.org/octopress/code-highlighter)

Generates highlighted code using Pygments.rb or Rouge with enanced HTML output and fancy stylesheets. This gem is used by [octopress-codefence](https://github.com/octopress/codefence) and [octopress-gist](https://github.com/octopress/octopress-gist).

## Usage Note

This plugin is really a library plugin, handling the heavy lifting for generating nice code snippets. If you want to add nice code snippets to your Jekyll site,
you probably want [octopress-codefence](https://github.com/octopress/codefence), [octopress-render-code](https://github.com/octopress/render-code), [octopress-codeblock](https://github.com/octopress/codeblock), or [octopress-gist](https://github.com/octopress/gist).

If you want to style highlighted code markup, check out [octopress-solarized](https://github.com/octopress/solarized).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
