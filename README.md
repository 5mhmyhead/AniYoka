# aniyoka

A redo of AniYoka, an AniList client for mobile.

## Important to Note

- pre-bundle fonts to prevent depending on dynamic runtime downloads for GoogleFonts
- follow constants from ui_helpers.dart to keep consistency within views
- follow colorScheme found in app_theme.dart which follows Material 3 conventions (background -> surface now)

## Golden Tests

Golden tests are already setup for this project. To run the tests and update the golden files, run:

```bash
flutter test --update-goldens
```

The golden test screenshots will be stored under `test/golden/`.
