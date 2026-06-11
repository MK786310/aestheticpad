# IPA Build & Release Guide

## Prerequisites

- Xcode 15.0+
- Apple Developer Account
- Valid Provisioning Profile
- Apple Distribution Certificate

## Quick Start: Building IPA

### Step 1: Make Script Executable

```bash
chmod +x scripts/build-ipa.sh
```

### Step 2: Configure Signing

Edit `ExportOptions.plist`:
```xml
<key>teamID</key>
<string>YOUR_TEAM_ID</string>

<key>provisioningProfiles</key>
<dict>
    <key>com.aestheticpad</key>
    <string>YOUR_PROFILE_NAME</string>
</dict>
```

### Step 3: Update Bundle Identifier

In Xcode:
1. Select `AestheticPad` target
2. **General** tab
3. Update **Bundle Identifier** (e.g., `com.yourcompany.aestheticpad`)

### Step 4: Build IPA

```bash
./scripts/build-ipa.sh
```

Output: `./build/AestheticPad.ipa`

---

## Manual Build Process

### Option 1: Archive from Xcode UI

1. Select **AestheticPad** scheme
2. Select **Any iOS Device (arm64)** destination
3. Product → Archive
4. Organizer window opens → Select archive
5. Distribute App → Ad Hoc/TestFlight/App Store
6. Choose signing method
7. Export

### Option 2: Command Line Build

```bash
# Clean
xcodebuild clean -scheme AestheticPad

# Archive
xcodebuild archive \
    -scheme AestheticPad \
    -configuration Release \
    -destination generic/platform=iOS \
    -archivePath ./build/AestheticPad.xcarchive

# Export
xcodebuild -exportArchive \
    -archivePath ./build/AestheticPad.xcarchive \
    -exportPath ./build \
    -exportOptionsPlist ExportOptions.plist
```

---

## Distribution Methods

### 1. Ad-Hoc (Direct Installation)

**Best for:** Testing on specific devices

```xml
<!-- ExportOptions.plist -->
<key>method</key>
<string>ad-hoc</string>
```

- Maximum 100 devices per year
- Share `.ipa` directly
- Install via Xcode or iOS App Installer

### 2. TestFlight (Beta Testing)

**Best for:** Public beta testing

```xml
<key>method</key>
<string>app-store</string>
```

```bash
xcrun altool --upload-app \
    --type ios \
    --file ./build/AestheticPad.ipa \
    --username your-apple-id@example.com \
    --password your-app-specific-password
```

### 3. Enterprise (Organization)

**Best for:** Internal distribution

```xml
<key>method</key>
<string>enterprise</string>
```

- Requires enterprise certificate
- Host on secure server
- Create manifest.plist for OTA install

### 4. App Store (Production)

**Best for:** Public release

```xml
<key>method</key>
<string>app-store</string>
```

1. Upload to App Store Connect
2. Fill app details
3. Submit for review
4. Apple approval (1-3 days)

---

## Certificate & Provisioning Setup

### Get Your Team ID

```bash
# Method 1: From xcodebuild
xcodebuild -showBuildSettings | grep DEVELOPMENT_TEAM

# Method 2: From App Store Connect
# Go to: Developer Settings → Membership
```

### Find Provisioning Profiles

```bash
ls ~/Library/MobileDevice/Provisioning\ Profiles/

# Extract profile info
security cms -D -i ~/Library/MobileDevice/Provisioning\ Profiles/PROFILE_UUID.mobileprovision
```

### Export Signing Certificate

```bash
# In Keychain Access:
# 1. Select "Apple Distribution" or "Apple Development"
# 2. Right-click → Export
# 3. Save as .p12 file
# 4. Set password for security
```

---

## GitHub Actions: Automated Builds

Create `.github/workflows/release.yml`:

```yaml
name: Build Release IPA

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Select Xcode Version
        run: sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
      
      - name: Build Archive
        run: |
          xcodebuild archive \
            -scheme AestheticPad \
            -configuration Release \
            -destination generic/platform=iOS \
            -archivePath build/AestheticPad.xcarchive \
            CODE_SIGN_IDENTITY="" \
            CODE_SIGNING_REQUIRED=NO
      
      - name: Export IPA
        run: |
          xcodebuild -exportArchive \
            -archivePath build/AestheticPad.xcarchive \
            -exportPath build \
            -exportOptionsPlist ExportOptions.plist
      
      - name: Upload to Release
        uses: softprops/action-gh-release@v1
        with:
          files: build/AestheticPad.ipa
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

**Usage:**
```bash
# Push tag to trigger build
git tag v1.0.0
git push origin v1.0.0
```

---

## Version Management

### Update Version & Build Number

```bash
# Method 1: Using Xcode
# General tab → Version & Build Number

# Method 2: Using plist
xcrun plutil -replace CFBundleShortVersionString -string "1.1.0" AestheticPad/Info.plist
xcrun plutil -replace CFBundleVersion -string "2" AestheticPad/Info.plist
```

### Semantic Versioning

- **Major (1.x.x):** Breaking changes
- **Minor (x.1.x):** New features
- **Patch (x.x.1):** Bug fixes

Example:
- v1.0.0 → Initial release
- v1.1.0 → New features
- v1.1.1 → Bug fixes
- v2.0.0 → Major update

---

## Testing Before Release

### Pre-Release Checklist

- [ ] All tests passing: `xcodebuild test`
- [ ] No compiler warnings
- [ ] Screenshots and app preview added
- [ ] App description updated
- [ ] Privacy policy URL configured
- [ ] Support email set
- [ ] Bundle ID correct
- [ ] Version number bumped
- [ ] Build number incremented
- [ ] Provisioning profile valid
- [ ] Certificate not expired
- [ ] IPA file size < 100 MB
- [ ] All permissions documented
- [ ] Accessibility tested (VoiceOver)
- [ ] Orientation supported (iPad landscape)

### Manual Testing on Device

```bash
# Install on connected device
xcodebuild -scheme AestheticPad \
    -configuration Release \
    -destination generic/platform=iOS \
    install
```

### Verify IPA Contents

```bash
# Extract and inspect
unzip -l build/AestheticPad.ipa | head -20

# Check app size
du -h build/AestheticPad.ipa
```

---

## Troubleshooting

### Issue: "No provisioning profiles found"

**Solution:**
1. Xcode → Preferences → Accounts
2. Select Apple ID
3. Click "Download All Profiles"
4. Retry build

### Issue: "Code signing failed"

**Solution:**
```bash
# Check available identities
security find-identity -v -p codesigning

# Force re-signing
rm -rf build/
./scripts/build-ipa.sh
```

### Issue: "Invalid provisioning profile"

**Solution:**
1. Verify bundle ID matches profile
2. Check profile hasn't expired
3. Regenerate profile in App Store Connect

### Issue: "Could not find arch for variant"

**Solution:**
- Ensure destination is `generic/platform=iOS`
- Check minimum deployment target is iOS 17.0+

---

## App Store Connect Setup

### Create App Record

1. Go to App Store Connect
2. Apps → New App
3. Platform: iOS
4. Bundle ID: `com.yourcompany.aestheticpad`
5. SKU: `aestheticpad-001`
6. Access Level: Full Access

### Configure App Details

1. **App Information**
   - Name: AestheticPad
   - Subtitle: Create Beautiful Wallpapers & Themes
   - Category: Graphics & Design

2. **Screenshots**
   - Upload iPad screenshots (2048×2732)
   - Show key features

3. **Description**
   - Feature list
   - Privacy practices
   - System requirements

4. **Pricing & Availability**
   - Price Tier: Free with In-App Purchases
   - Available Worldwide

5. **In-App Purchases**
   - Monthly Premium: $4.99
   - Yearly Premium: $39.99

### Submit for Review

1. Version Release: Manual or Automatic
2. Content Rights: Accept terms
3. Add Review Notes
4. Submit for Review

---

## Release Notes Template

```markdown
# AestheticPad v1.0.0

## 🎉 What's New
- 🎨 Wallpaper creator with custom gradients
- 🎭 Six beautiful color themes
- 📝 Import and manage custom fonts
- 🧩 Five widget design templates
- 💎 Premium subscription for exclusive features

## ✨ Features
- Gallery browsing with categories
- Drag-and-drop theme customization
- Cloud sync for premium users
- Ad-free experience on premium

## 🐛 Bug Fixes
- Fixed font loading performance
- Improved wallpaper rendering quality
- Enhanced theme switching animations

## 📝 Known Issues
- None at this time

---

**Download now for free with optional premium features!**
```

---

## Release Promotion

### Marketing Checklist

- [ ] Press release prepared
- [ ] Social media posts scheduled
- [ ] App preview video created
- [ ] Screenshots showcase key features
- [ ] App Store listing optimized for SEO
- [ ] Early access for reviewers
- [ ] Launch day announcements

---

## Monitoring After Release

### Track Analytics

- App Store Connect → Metrics
- Monitor downloads, crashes, ratings
- Review user feedback

### Handle Issues

```bash
# Hotfix for critical bug
# 1. Fix code
# 2. Bump version to v1.0.1
# 3. Rebuild IPA
# 4. Submit new build
```

---

**For official Apple guidelines: https://developer.apple.com/app-store/submissions/**
