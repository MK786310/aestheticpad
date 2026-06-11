# AestheticPad Setup Guide

## Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- iOS/iPadOS 17.0 or later (deployment target)
- Apple Developer Account (for App Store deployment)

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/MK786310/AestheticPad.git
cd AestheticPad
```

### 2. Open in Xcode

```bash
open AestheticPad.xcodeproj
```

### 3. Build Settings

- Select **iPad** simulator (iPad Air, iPad Pro, or iPad Mini)
- Target: **iPadOS 17.0+**
- Scheme: **AestheticPad**

### 4. Run the App

```bash
Cmd + R
```

## Project Configuration

### App Target Settings

1. **General Tab**
   - Bundle Identifier: `com.yourcompany.aestheticpad`
   - Deployment Target: iOS 17.0+
   - Supported Destinations: iPad

2. **Signing & Capabilities**
   - Team: Select your Apple Developer account
   - Signing Certificate: Automatic
   - Capabilities:
     - In-App Purchase
     - CloudKit (optional, for sync)

### StoreKit Testing Configuration

See `STOREKIT_TESTING.md` for detailed StoreKit 2 setup.

## Features Overview

### Tab Navigation

1. **Home** - Dashboard with recent items and featured content
2. **Wallpapers** - Browse, search, and create custom wallpapers
3. **Widgets** - Design and preview widget templates
4. **Fonts** - Import and manage font files
5. **Themes** - Create and customize color themes
6. **Settings** - App configuration and premium options

### Free Features

- ✓ Browse wallpaper gallery
- ✓ Create custom wallpapers with gradients
- ✓ Add text and stickers to wallpapers
- ✓ Browse app icon packs
- ✓ Import .ttf and .otf fonts
- ✓ Create and customize themes
- ✓ Widget templates (basic)
- ✓ Light/dark mode support
- ✓ Settings and onboarding

### Premium Features

- ✓ Exclusive wallpaper packs
- ✓ Advanced widget templates
- ✓ Unlimited saved themes (vs 50 free)
- ✓ Premium font collections
- ✓ Cloud sync support
- ✓ Ad-free experience

## Architecture

### MVVM Structure

```
AestheticPad/
├── Models/
│   ├── Wallpaper.swift
│   ├── Font.swift
│   ├── Theme.swift
│   ├── Widget.swift
│   ├── IconPack.swift
│   └── SubscriptionProduct.swift
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── WallpaperViewModel.swift
│   ├── WidgetViewModel.swift
│   ├── FontViewModel.swift
│   ├── ThemeViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── Home/
│   ├── Wallpapers/
│   ├── Widgets/
│   ├── Fonts/
│   ├── Themes/
│   ├── Settings/
│   ├── Onboarding/
│   └── Common/
├── Managers/
│   ├── StoreKitManager.swift
│   ├── UserDefaultsManager.swift
│   ├── FontManager.swift
│   ├── WallpaperManager.swift
│   └── ThemeManager.swift
├── Services/
├── Utilities/
│   ├── Constants.swift
│   ├── Extensions.swift
│   └── Helpers.swift
└── App/
    └── AestheticPadApp.swift
```

## Data Storage

### UserDefaults

- Onboarding completion status
- Current theme selection
- Dark mode preference
- Subscription status

### App Support Directory

- Custom wallpapers (metadata)
- Imported fonts (binary files)
- Custom themes
- Widget configurations

## Testing

### Unit Tests

```bash
xcodebuild test -scheme AestheticPad
```

### Run on Specific Device

```bash
xcodebuild test -scheme AestheticPad -destination 'platform=iPad Simulator,name=iPad (10th generation)'
```

## Troubleshooting

### Build Failures

1. **"AestheticPad module not found"**
   - Clean build folder: `Cmd + Shift + K`
   - Quit Xcode and reopen

2. **"StoreKit import error"**
   - Ensure iOS 17.0+ is selected
   - Re-add StoreKit 2 framework in target settings

3. **Simulator Issues**
   - Reset simulator: `xcrun simctl erase all`
   - Select a fresh iPad simulator

### Runtime Issues

1. **Fonts not displaying**
   - Check app support directory permissions
   - Verify .ttf/.otf file integrity

2. **UserDefaults not persisting**
   - Simulator cache may be stale
   - Reset simulator data or uninstall app

## Next Steps

1. Review `ARCHITECTURE.md` for detailed design patterns
2. Check `STOREKIT_TESTING.md` for in-app purchase setup
3. Customize app name and bundle identifier
4. Add your own wallpaper/font assets
5. Configure App Store Connect for release

## Support

For issues or questions:
- Check GitHub issues
- Review documentation files
- Consult Apple's SwiftUI documentation

---

**Happy building! 🎨**
