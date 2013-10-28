# Changelog

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
