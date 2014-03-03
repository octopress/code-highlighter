# Changelog

## 3.0.0
  - Changed name to octopress-code-highlighter.
  - Now supporting both Pygments.rb and Rouge for highlighting.

## 2.0.1
  - Updated Octopress Ink version, added a simple demo project.

## 2.0.1
  - Updated Octopress Ink version, added a simple demo project.

## 2.0.0
  - Added support for Octopress Ink

## 1.3.1
  - Fixed: line numbers now start at 1 instead of zero.
  - Changed: `escape` option defaults to false.

## 1.3.0
  - Added `escape` option which wraps code in {% raw %} tags to escape liquid. Defaults to true.

## 1.2.3
  - Fixed: figcaptions now work when specifying a title.

## 1.2.2
  - Now you can call Pygments.read_cache directly.
  - Added an option to specify a label on cache files.
  - Simplified caching methods.

## 1.2.1
  - Fix: No longer overwriting options with `nil` in parse_markup

## 1.2.0
  - Added method for users to specify lexer aliases
  - Removed default aliases:
    - ru, yml, coffee - now handled by Pygments correctly
    - pl, m - match multiple languages, enforcing an alias is inappropriate

## 1.1.0
  - Boring bug fixes

## 1.0.0
  - Initial release
