# Changelog

## 4.3.0 - 2015-12-09
- Now supporting Jekyll 3+

## 4.2.6 - 2015-05-29
- Fix: Find enumerators on non-existent directories threw errors. 

## 4.2.5 - 2015-05-29
- Fix: Code cache doesn't attempt cleanup if there is no cache.

## 4.2.4 - 2015-05-18
- New: Now works with Jekyll 3 and Jekyll Hooks.
- Fix: Cache reads and writes do not trigger Jekyll watcher.
- Fix: Cache fingerprinting improvement.

## 4.2.3 - 2014-07-08
- Fixed: Code ranges now work on ruby 1.9.3
  
## 4.2.2 - 2014-07-07
- Fixed: Closing spans aren't wrapped to a newline.
  
## 4.2.1 - 2014-06-29
- Improved support for new Pygments.rb.

## 4.2.0 - 2014-06-28
- New: Add classnames on code figure: `class:"example classnames"`.

## 4.1.0 - 2014-06-27
- Added support for setting PHP's startinline option (now defaults to true).

## 4.0.3 - 2014-06-26
- Fixed: Improved escaping characters for Liquid.

## 4.0.2
- Fixed: end of range now works properly.

## 4.0.1
- Changed `get_range` method to `select_lines` which returns a code partial when `start`, `end` or `range` options are defined.

## 4.0.0
- Removed stylesheets. Now use gem octopress-solarized for stylesheets.
- Removed dependency on Octopress Ink.

## 3.1.0
- Updated stylesheets to be Sass 3.3 compatible.

## 3.0.1
- Changed name of cache dir to .code-highlighter-cache.

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
