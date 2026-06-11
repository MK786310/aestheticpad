# AestheticPad

A modern, production-quality iPad app for creating beautiful wallpapers, managing fonts, designing widgets, and customizing themes. Built with SwiftUI and StoreKit 2.

## Features

### Free Features
- 🎨 Wallpaper gallery with categories
- 🖌️ Wallpaper creator with gradients, text, and stickers
- 🎯 App icon pack browser
- 🎭 Theme manager with light/dark mode support
- 📝 Font importer (.ttf and .otf)
- 📚 Font organization, preview, and management
- 🚀 Onboarding experience
- ⚙️ Comprehensive settings

### Premium Features (Subscription)
- ✨ Exclusive wallpaper packs
- 🧩 Advanced widget templates
- ∞ Unlimited saved themes
- 👑 Premium font collections
- ☁️ Cloud sync support
- 🚫 Ad-free experience

## Requirements

- iOS 17.0+ / iPadOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Apple Developer Account (for production deployment)

## Project Structure

```
AestheticPad/
├── AestheticPad.xcodeproj/
├── AestheticPad/
│   ├── App/
│   │   ├── AestheticPadApp.swift
│   │   └── AppDelegate.swift
│   ├── Models/
│   │   ├── Wallpaper.swift
│   │   ├── Font.swift
│   │   ├── Theme.swift
│   │   ├── Widget.swift
│   │   ├── IconPack.swift
│   │   └── SubscriptionProduct.swift
│   ├── ViewModels/
│   │   ├── HomeViewModel.swift
│   │   ├── WallpaperViewModel.swift
│   │   ├── WidgetViewModel.swift
│   │   ├── FontViewModel.swift
│   │   ├── ThemeViewModel.swift
│   │   └── SettingsViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── Home/
│   │   ├── Wallpapers/
│   │   ├── Widgets/
│   │   ├── Fonts/
│   │   ├── Themes/
│   │   ├── Settings/
│   │   └── Common/
│   ├── Managers/
│   │   ├── StoreKitManager.swift
│   │   ├── UserDefaultsManager.swift
│   │   ├── FontManager.swift
│   │   ├── WallpaperManager.swift
│   │   └── ThemeManager.swift
│   ├── Services/
│   │   ├── SubscriptionService.swift
│   │   ├── CloudSyncService.swift
│   │   └── FileManager.swift
│   ├── Utilities/
│   │   ├── Constants.swift
│   │   ├── Extensions.swift
│   │   └── Helpers.swift
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   └── Localizable.strings
│   └── StoreKit/
│       └── StoreKitConfig.storekit
├── AestheticPadTests/
└── Documentation/
    ├── SETUP.md
    ├── STOREKIT_TESTING.md
    └── ARCHITECTURE.md
```

## Installation & Setup

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/MK786310/AestheticPad.git
   cd AestheticPad
   ```

2. **Open in Xcode**
   ```bash
   open AestheticPad.xcodeproj
   ```

3. **Configure StoreKit Testing**
   - See `Documentation/STOREKIT_TESTING.md` for detailed setup

4. **Build and Run**
   - Select iPad simulator
   - Press Cmd+R to build and run

### App Store Deployment

1. Create App Store Connect record
2. Configure App ID capabilities (In-App Purchases)
3. Create subscription products in App Store Connect
4. Replace `StoreKitConfig.storekit` with production configuration
5. Archive and submit for review

## Architecture

### MVVM Pattern
- **Models**: Data structures and business entities
- **ViewModels**: State management and business logic
- **Views**: SwiftUI components (UIComponent-based)
- **Managers**: Singleton services (UserDefaults, StoreKit, Fonts)
- **Services**: Network and cloud sync operations

### Key Design Patterns
- **Dependency Injection**: For testability
- **Reactive Programming**: Using @Published and Combine
- **Error Handling**: Comprehensive error types
- **Loading States**: Proper async/await handling

## Testing

### Run Tests
```bash
xcodebuild test -scheme AestheticPad -destination 'platform=iPad Simulator,name=iPad (10th generation)'
```

### Test Categories
- Unit Tests: ViewModels, Managers, Utilities
- Integration Tests: StoreKit, UserDefaults
- UI Tests: Navigation, User flows

## StoreKit 2 Configuration

### Local Testing
- Use `StoreKitConfig.storekit` for testing
- Products automatically available in simulator
- No App Store connection required

### Production
- Configure products in App Store Connect
- Monthly subscription: `com.aestheticpad.premium.monthly`
- Yearly subscription: `com.aestheticpad.premium.yearly`

See `Documentation/STOREKIT_TESTING.md` for detailed instructions.

## UI/UX Design

- **iPad Optimized**: Full-screen layouts with sidebar support
- **Modern Aesthetics**: Gradients, shadows, and Apple-style components
- **Accessibility**: VoiceOver support, Dynamic Type, high contrast
- **Animations**: Smooth transitions and microinteractions
- **Dark Mode**: Full light/dark mode support

## Performance Optimization

- Lazy loading for wallpaper gallery
- Image caching and compression
- Efficient font rendering
- Background sync for cloud features
- Memory-efficient widget preview rendering

## Privacy & Security

- Local-only font storage (user imported files)
- Optional cloud sync with encryption
- No tracking or analytics by default
- GDPR compliant

## Contributing

This is a personal project. Feel free to fork and modify for your needs.

## License

All rights reserved. See LICENSE file for details.

## Support

For issues, questions, or feature requests, open an issue on GitHub.

---

**Built with ❤️ using SwiftUI and StoreKit 2**
