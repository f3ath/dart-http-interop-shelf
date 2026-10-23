## [0.1.0] - 2026-10-23
### Added
- Document that mounted handlers receive the original absolute request URI, including the mount prefix.

### Changed
- BREAKING: Require Dart SDK ^3.13.0 and upgrade http\_interop from ^2.1.0 to ^3.0.0.
- BREAKING: Preserve request method casing supplied by Shelf instead of normalizing it to lowercase.
- Reuse incoming Uint8List body chunks to avoid unnecessary copies.

### Fixed
- Preserve non-null response context values when converting to Shelf and omit null values.
- Copy incoming header value lists so Interop handlers can modify them without changing Shelf headers.
- Correct the package description and repository URL.
- Use an available port and safely register resource cleanup in integration tests.

## [0.0.1] - 2024-09-02
### Added
- Initial release

[0.1.0]: https://github.com/f3ath/dart-http-interop-shelf/compare/0.0.1...0.1.0
[0.0.1]: https://github.com/f3ath/dart-http-interop-shelf/releases/tag/0.0.1
