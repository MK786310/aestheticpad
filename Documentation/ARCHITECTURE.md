# AestheticPad Architecture Guide

## Overview

AestheticPad follows a clean MVVM (Model-View-ViewModel) architecture with clear separation of concerns.

## Architecture Layers

### 1. Models Layer

Data structures representing app entities:

- **Wallpaper.swift** - Wallpaper metadata and configuration
- **Font.swift** - Imported font data and collections
- **Theme.swift** - Color themes and customization
- **Widget.swift** - Widget templates and configurations
- **IconPack.swift** - App icon collections
- **SubscriptionProduct.swift** - Subscription models

All models conform to `Identifiable` and `Codable` for storage.

### 2. ViewModels Layer

State management and business logic:

- **HomeViewModel** - Dashboard data and recent items
- **WallpaperViewModel** - Wallpaper creation and management
- **FontViewModel** - Font import and organization
- **WidgetViewModel** - Widget template management
- **ThemeViewModel** - Theme creation and switching
- **SettingsViewModel** - App configuration

ViewModels use:
- `@Published` for reactive state
- `@StateObject` for lifecycle management
- Combine for data flow
- Async/await for concurrency

### 3. Views Layer

SwiftUI components organized by feature:

```
Views/
├── Common/
│   └── Reusable components
├── Home/
│   └── Dashboard
├── Wallpapers/
│   ├── Gallery
│   └── Creator
├── Widgets/
│   ├── Browser
│   └── Designer
├── Fonts/
│   ├── Manager
│   └── Preview
├── Themes/
│   ├── Selector
│   └── Creator
├── Settings/
│   ├── Main settings
│   ├── Premium
│   └── Subscriptions
└── Onboarding/
    └── Welcome flow
```

Views follow:
- Composition over inheritance
- Single responsibility
- Reactive state binding
- Proper environment object usage

### 4. Managers Layer

Singleton managers handling persistent state:

- **StoreKitManager** - In-app purchases and subscriptions
- **UserDefaultsManager** - User preferences and settings
- **FontManager** - Font file operations
- **WallpaperManager** - Wallpaper storage
- **ThemeManager** - Theme management

Managers:
- Use `@MainActor` for thread safety
- Provide reactive interfaces with `@Published`
- Handle file I/O and persistence
- Implement error handling

### 5. Services Layer

Business logic and external integrations:

- **SubscriptionService** - Subscription management
- **CloudSyncService** - Cloud synchronization (optional)
- **FileManager** - File operations helper

### 6. Utilities Layer

Helper code and extensions:

- **Constants.swift** - App-wide constants
- **Extensions.swift** - Foundation and SwiftUI extensions
- **Helpers.swift** - Error types and utilities

## Data Flow

### Example: Creating a Wallpaper

```
1. User interacts with View
   ↓
2. View triggers ViewModel method
   ↓
3. ViewModel calls Manager method
   ↓
4. Manager persists to UserDefaults/FileSystem
   ↓
5. Manager publishes updated state
   ↓
6. ViewModel observes changes
   ↓
7. View updates automatically (reactive binding)
```

### State Management Pattern

```swift
// ViewModel
@MainActor
class WallpaperViewModel: ObservableObject {
    @Published var wallpapers: [Wallpaper] = []
    private let manager = WallpaperManager.shared
    
    func create(_ wallpaper: Wallpaper) {
        manager.save(wallpaper)  // Persists
        wallpapers = manager.getAll()  // Updates view
    }
}

// View
struct WallpaperView: View {
    @StateObject var viewModel = WallpaperViewModel()
    
    var body: some View {
        List(viewModel.wallpapers) { wallpaper in
            // Auto-updates when wallpapers change
        }
    }
}
```

## Dependency Injection

Managers use singleton pattern:

```swift
class FontManager: ObservableObject {
    static let shared = FontManager()
    private init() { }  // Prevents multiple instances
}

// Usage
let fontManager = FontManager.shared
```

ViewModels inject dependencies:

```swift
class FontViewModel: ObservableObject {
    private let manager = FontManager.shared
}
```

Views receive environment objects:

```swift
ContentView()
    .environmentObject(StoreKitManager.shared)
    .environmentObject(ThemeManager.shared)
```

## Error Handling

Custom error enum:

```swift
enum AestheticPadError: LocalizedError {
    case wallpaperNotFound
    case fontNotFound
    case fileTooLarge
    // ...
    
    var errorDescription: String? { /* ... */ }
    var recoverySuggestion: String? { /* ... */ }
}
```

Usage in ViewModels:

```swift
@Published var error: AestheticPadError?

func loadWallpapers() {
    do {
        wallpapers = try manager.load()
    } catch {
        self.error = error as? AestheticPadError ?? .unknown(error.localizedDescription)
    }
}
```

## Concurrency Model

### Main Thread Operations

```swift
@MainActor  // Forces main thread
class StoreKitManager: ObservableObject {
    @Published var products: [Product] = []
    
    func fetchProducts() async {
        // Runs on main thread
    }
}
```

### Background Tasks

```swift
func loadExpensiveData() async {
    let data = await fetchFromNetwork()  // Background thread
    await MainActor.run {
        self.items = data  // Update on main thread
    }
}
```

## Testing Strategy

### Unit Testing

```swift
class WallpaperViewModelTests: XCTestCase {
    var viewModel: WallpaperViewModel!
    
    func testCreateWallpaper() async {
        // Test wallpaper creation logic
    }
}
```

### ViewModel Testing

- Test business logic separately from UI
- Mock managers for isolation
- Verify state updates

### Integration Testing

- Test manager persistence
- Verify data flows correctly
- Test error scenarios

## Performance Optimizations

### Lazy Loading

```swift
LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
    ForEach(wallpapers) { wallpaper in
        // Rendered on demand
    }
}
```

### Memory Management

- Use `@StateObject` for view models
- Clean up observers in `deinit`
- Limit stored image data

### Caching

```swift
struct CacheManager {
    static let shared = CacheManager()
    private var cache = NSCache<NSString, UIImage>()
    
    func cache(_ image: UIImage, for key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
```

## Naming Conventions

- **Classes/Structs**: PascalCase (`WallpaperViewModel`)
- **Functions/Variables**: camelCase (`createWallpaper()`)
- **Constants**: PascalCase (`Constants.UI.cornerRadius`)
- **Views**: Suffix with `View` (`HomeTabView`)
- **ViewModels**: Suffix with `ViewModel` (`HomeViewModel`)
- **Managers**: Suffix with `Manager` (`FontManager`)

## Code Organization

### File Size Guidelines

- **Views**: Max 500 lines (split into subviews)
- **ViewModels**: Max 300 lines
- **Models**: Max 200 lines
- **Managers**: Max 400 lines

### Subviews

```swift
// Extract UI components into separate structs
struct ThemeItemView: View {
    let theme: Theme
    var body: some View { /* ... */ }
}

// Use in parent
struct ThemeListView: View {
    var body: some View {
        List(themes) { theme in
            ThemeItemView(theme: theme)
        }
    }
}
```

## Security Considerations

1. **Data Storage**
   - User defaults: Non-sensitive data only
   - File system: Encrypted file storage
   - CloudKit: Encrypted sync

2. **API Security**
   - HTTPS only
   - Certificate pinning (if needed)
   - Token refresh

3. **User Privacy**
   - No tracking
   - Minimal analytics
   - Transparent data usage

## Future Enhancements

1. **Modularization**
   - Split into frameworks
   - Feature-based modules

2. **Networking**
   - Add cloud sync
   - Server-side subscriptions

3. **Advanced Features**
   - Collaborative editing
   - Social sharing
   - AI-powered suggestions

---

**For questions about architecture, refer to SwiftUI and iOS best practices documentation.**
