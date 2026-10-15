# Theming and Localization Rules

### Multi-Color Theming
- The app supports 5 selectable color themes:
  1. **Cosmic Indigo**: Primary `#6366F1`, Secondary `#818CF8`, Surface tint indigo.
  2. **Cyber Emerald**: Primary `#10B981`, Secondary `#34D399`, Mint accent.
  3. **Solar Amber**: Primary `#F59E0B`, Secondary `#FBBF24`, Warm gold accent.
  4. **Neon Crimson**: Primary `#F43F5E`, Secondary `#FB7185`, Rose red accent.
  5. **Royal Violet**: Primary `#8B5CF6`, Secondary `#A78BFA`, Purple glow accent.
- Both **Light** and **Dark** brightness modes must be supported for every color theme.
- All styles must use Material 3 `Theme.of(context).colorScheme` tokens, avoiding hardcoded hex colors in widget trees.

### Multi-Language Internationalization
- Supported Locales:
  - `en` (English)
  - `es` (Spanish)
  - `fr` (French)
  - `de` (German)
  - `hi` (Hindi)
  - `ar` (Arabic)
- For `ar` (Arabic), the UI must automatically respect RTL reading direction (`Directionality` or `MaterialApp(locale: ...)`).
- Every interactive screen, tab, form field, button, and error message must use localized lookup keys.
