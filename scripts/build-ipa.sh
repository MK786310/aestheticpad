#!/bin/bash

# AestheticPad IPA Build Script
# This script builds and exports an IPA file

set -e

echo "🏗️  Building AestheticPad IPA..."

# Configuration
SCHEME="AestheticPad"
CONFIGURATION="Release"
DESTINATION="generic/platform=iOS"
ARCHIVE_PATH="./build/AestheticPad.xcarchive"
IPA_OUTPUT="./build/AestheticPad.ipa"
EXPORT_OPTIONS="ExportOptions.plist"

# Create build directory
mkdir -p ./build

# Step 1: Clean
echo "🧹 Cleaning build artifacts..."
xcodebuild clean -scheme $SCHEME

# Step 2: Archive
echo "📦 Creating archive..."
xcodebuild archive \
    -scheme $SCHEME \
    -configuration $CONFIGURATION \
    -destination $DESTINATION \
    -archivePath $ARCHIVE_PATH \
    -derivedDataPath ./build/DerivedData \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO

# Step 3: Export IPA
echo "📤 Exporting IPA file..."
xcodebuild -exportArchive \
    -archivePath $ARCHIVE_PATH \
    -exportPath ./build \
    -exportOptionsPlist $EXPORT_OPTIONS

echo "✅ Build completed!"
echo "📍 IPA Location: $IPA_OUTPUT"
echo "📊 File Size: $(du -h $IPA_OUTPUT | cut -f1)"
