# Customizable Dashboard Widget System Rules

### Overview
NexusHub features a dynamic widget builder system allowing users to customize their Daily Briefing Home screen.

### Widget Schema
Every custom dashboard widget is defined by:
- `id`: Unique string UUID.
- `title`: User-defined or default label.
- `type`: Enum (`weatherGlance`, `apodHero`, `newsTicker`, `devLaugh`, `countryFact`, `customApiCard`, `quickNote`).
- `config`: Map of parameters (e.g., target city, news category, custom API URL, refresh interval, note content).
- `isVisible`: Boolean flag to toggle visibility.
- `orderIndex`: Integer for dashboard positioning.

### Rules
1. **Creation Modal**: Users can launch a "Create Widget" modal from the Home Screen or Settings to choose a widget type, enter custom endpoints or parameters, and save.
2. **Reordering & Deletion**: Widgets can be reordered via drag-and-drop or position buttons, edited, or removed.
3. **Local Persistence**: All created widgets are stored in local storage and reloaded on app launch.
4. **Resilience**: If a custom API widget encounters a network error, it must render an inline error state with a retry button without crashing the rest of the dashboard.
