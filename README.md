# AestheticPad - Complete iPad App

A **production-quality iOS/iPadOS app** built with SwiftUI and StoreKit 2 for creating beautiful wallpapers, managing fonts, designing widgets, and customizing themes.

## ✨ Features

### 🎨 Free Features
- **Wallpaper Gallery** - Browse 5+ categories with beautiful designs
- **Wallpaper Creator** - Custom gradients, text, and stickers
- **Theme Manager** - 6 beautiful pre-built themes
- **Font Importer** - Support for .ttf and .otf font files
- **Widget Templates** - 5 professional widget designs
- **App Settings** - Full customization options
- **Onboarding** - Comprehensive first-time user guide
- **Dark Mode** - Complete light/dark mode support

### 💎 Premium Features ($4.99/mo or $39.99/yr)
- **Exclusive Wallpapers** - Premium wallpaper collections
- **Advanced Widgets** - Professional widget templates
- **Unlimited Themes** - Save unlimited custom themes
- **Premium Fonts** - Curated premium font collections
- **Cloud Sync** - Access creations across devices
- **Ad-Free** - Complete ad-free experience

## 📋 Requirements

- **iOS/iPadOS** 17.0 or later
- **Xcode** 15.0 or later
- **Swift** 5.9 or later
- **iPad** (all models supported)

## 🚀 Quick Start

### Clone & Setup
```bash
git clone https://github.com/MK786310/AestheticPad.git
cd AestheticPad
open AestheticPad.xcodeproj
```

### Run in Simulator
1. Select iPad simulator
2. Press **Cmd+R** to build and run
3. Complete onboarding tour

### Build Release IPA
```bash
chmod +x scripts/build-ipa.sh
./scripts/build-ipa.sh
# Output: ./build/AestheticPad.ipa
```

## 📱 6 Main Tabs

| Tab | Features |
|-----|----------|
| **Home** | Dashboard with recent items and featured content |
| **Wallpapers** | Gallery with categories, search, and creator |
| **Widgets** | 5 template browser with customization |
| **Fonts** | Import, preview, organize font files |
| **Themes** | 6 themes + custom theme creator |
| **Settings** | Premium subscription, app preferences |

## 🏗️ Project Architecture

### Clean MVVM Structure
```
AestheticPad/
├── Models/              # Data structures
├── ViewModels/          # State management (@Published)
├── Views/               # SwiftUI UI components
├── Managers/            # Singleton services
├── Utilities/           # Helpers & extensions
└── Documentation/       # Setup & guides
```

### Key Technologies
- ✅ SwiftUI - Modern declarative UI
- ✅ StoreKit 2 - In-app purchases
- ✅ Combine - Reactive programming
- ✅ Async/Await - Modern concurrency
- ✅ UserDefaults - Data persistence

## 🎯 Core Functionality

### Wallpapers
- 📸 Category browsing (Abstract, Nature, Urban, Minimalist, Colorful, Custom)
- 🖌️ Custom gradient editor with color picker
- 📝 Add text elements with font selection
- ✨ Add emoji stickers and decorations
- 💾 Save, organize, rename, delete wallpapers

### Fonts
- 📥 Import .ttf and .otf font files
- 👁️ Font preview with customizable text
- 📚 Organize into collections
- ✅ Activate/deactivate fonts
- 🏷️ Rename and manage imported fonts

### Themes
- 🎨 6 pre-built themes: Light, Dark, Ocean, Sunset, Forest, Premium Gradient
- 🖍️ Color picker for each theme component
- 💾 Create unlimited custom themes
- 📋 Duplicate existing themes
- 🎯 Apply themes app-wide

### Widgets
- 🧩 5 templates: Productivity, Weather, Calendar, Fitness, News
- 🎨 Customize colors and layout
- 📊 Live preview of widget designs
- 📖 Setup guides for each widget
- 🔧 Export widget configurations

### Premium
- 💳 Monthly ($4.99) or Yearly ($39.99) subscription
- 📱 Restore purchases functionality
- ✅ Subscription status tracking
- 🔐 Secure StoreKit 2 integration

## 📚 Documentation

| File | Purpose |
|------|---------|
| [SETUP.md](Documentation/SETUP.md) | Development environment setup |
| [STOREKIT_TESTING.md](Documentation/STOREKIT_TESTING.md) | In-app purchase testing |
| [ARCHITECTURE.md](Documentation/ARCHITECTURE.md) | Design patterns & architecture |
| [IPA_BUILD.md](Documentation/IPA_BUILD.md) | Building & releasing IPA |

## 🧪 Testing

### Unit Tests
```bash
xcodebuild test -scheme AestheticPad
```

### Manual Testing Checklist
- ✅ All tabs navigate correctly
- ✅ Wallpaper creation and customization
- ✅ Font import and preview
- ✅ Theme switching and customization
- ✅ Widget template browsing
- ✅ Premium paywall display
- ✅ Settings and preferences

## 📦 Building for Distribution

### Local Testing (Ad-Hoc)
```bash
./scripts/build-ipa.sh
# Install on iPad via Xcode or Apple Configurator
```

### TestFlight Beta
See [IPA_BUILD.md](Documentation/IPA_BUILD.md) for steps to:
- Setup provisioning profiles
- Configure certificates
- Upload to TestFlight

### App Store Release
1. Create App Store Connect record
2. Configure app details and screenshots
3. Setup In-App Purchase products
4. Submit for review

## 🎨 Design Highlights

✨ **Apple-style UI** - Clean, modern interface
✨ **Smooth animations** - Polished transitions and interactions
✨ **iPad optimized** - Full-screen layouts and landscape support
✨ **Accessibility** - VoiceOver compatible, Dynamic Type support
✨ **Dark mode** - Complete light/dark mode implementation

## 🔐 Security & Privacy

✅ **Local storage** - Font files stored securely on device
✅ **Optional cloud sync** - Encrypted data synchronization
✅ **No analytics** - User data stays private
✅ **GDPR compliant** - Respects user privacy
✅ **Transparent practices** - Clear privacy policy

## 📊 Project Statistics

- **Models** - 6 data structures
- **ViewModels** - 6 state managers
- **Views** - 20+ SwiftUI components
- **Managers** - 5 singleton services
- **Total LOC** - 3,500+ lines of production code
- **Test Ready** - Unit test structure included

## 🤝 Contributing

This is a personal project. Feel free to fork and customize for your own use.

## 📄 License

All rights reserved. See LICENSE file for details.

## 💬 Support & Feedback

- 🐛 **Issues** - GitHub Issues
- 📧 **Email** - support@aestheticpad.app
- 📖 **Docs** - See Documentation folder
- 🌐 **GitHub** - https://github.com/MK786310/aestheticpad

---

## 🚀 Getting Started Checklist

- [ ] Clone repository
- [ ] Open in Xcode 15+
- [ ] Select iPad simulator
- [ ] Build & run (Cmd+R)
- [ ] Complete onboarding
- [ ] Explore all features
- [ ] Read documentation
- [ ] Build release IPA
- [ ] Deploy to App Store

---

**Built with ❤️ using SwiftUI and StoreKit 2**

**Current Version:** 1.0.0 | **Status:** Production Ready
