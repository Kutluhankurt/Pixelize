# ⚡ Quick Start - Nano Banana Pro

Get up and running in 5 minutes!

## 🎯 Immediate Next Steps

### 1. Install Flutter (if not already installed)
```bash
# Check if Flutter is installed
flutter --version

# If not, install via Homebrew (macOS)
brew install flutter

# Or download from: https://flutter.dev/docs/get-started/install
```

### 2. Install Dependencies
```bash
cd nano_banana_pro
flutter pub get
```

### 3. Set Up Supabase Database

Go to your Supabase SQL Editor and run:

```sql
CREATE TABLE avatars (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  input_image_url TEXT NOT NULL,
  output_image_url TEXT NOT NULL,
  is_public BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_avatars_public ON avatars(is_public, created_at DESC);
```

### 4. Create Supabase Storage Bucket

1. Go to **Storage** in Supabase dashboard
2. Click **New bucket**
3. Name: `avatars`
4. Make it **public**

### 5. Download Pixel Fonts

Create `assets/fonts/` directory and add these fonts:

- **Press Start 2P**: https://fonts.google.com/specimen/Press+Start+2P
- **Pixel Operator**: https://www.dafont.com/pixel-operator.font
- **VCR OSD Mono**: https://www.dafont.com/vcr-osd-mono.font

```bash
mkdir -p assets/fonts
# Download and place the .ttf files there
```

### 6. Fix Replicate API Key

In `lib/main.dart`, the Replicate API key is already set, but make sure it's in the correct format:

```dart
// In lib/main.dart:
const replicateApiKey = "YOUR_REPLICATE_API_KEY";
```

### 7. Choose Better Pixel Art Model

The default uses `google/imagen-4`, but for better pixel art, update `lib/main.dart`:

```dart
// Replace line 21 with a pixel art specific model:
const replicateModelVersion = "nerijs/pixel-art-xl:b8c96199ef..."; // Check Replicate for latest version
```

Recommended models for pixel art:
- `nerijs/pixel-art-xl` - Best for avatars
- `alvdansen/haunted_ps1_diffusion` - Retro PS1 style
- Search "pixel art" on replicate.com for more

### 8. Run the App

```bash
# iOS Simulator (macOS only)
flutter run -d "iPhone 15 Pro"

# Android Emulator
flutter run -d emulator-5554

# Physical device
flutter devices
flutter run -d <device-id>
```

## 🔧 Important Configuration Notes

### Your API Keys (Already Configured)

✅ **Supabase URL**: `https://jhyzfbgmmbnccecijiwf.supabase.co`
✅ **Supabase Anon Key**: Already set in main.dart
✅ **Replicate API Key**: Already set in main.dart

### What's NOT Configured Yet

❌ **Pixel fonts** - You need to download and add them
❌ **Replicate model** - Currently using Imagen-4, should use pixel art model
❌ **iOS permissions** - Need to add to Info.plist for camera/gallery

## 📱 iOS Permissions (Required)

Add to `ios/Runner/Info.plist` (you'll need to create this file or use Xcode):

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos for pixelation</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>
```

## 🚀 Test Your Setup

1. **App Launches**: White screen with "Nano Banana Pro" title ✓
2. **Pick Image**: Gallery picker opens ✓
3. **Upload**: Image uploads to Supabase ✓
4. **Generate**: Shows "PIXELIZING YOUR FACE..." ✓
5. **Result**: Pixel art displays ✓
6. **Feed**: Shows grid of generated avatars ✓

## 🐛 Quick Troubleshooting

**Error: "command not found: flutter"**
→ Install Flutter SDK

**Error: "Font 'PressStart2P' is not a system font"**
→ Add font files to `assets/fonts/`

**Error: "Failed to upload to Supabase"**
→ Check that `avatars` storage bucket exists and is public

**Error: "Replicate prediction failed"**
→ Verify API key and model version

**Error: "Table avatars does not exist"**
→ Run the SQL commands in Supabase SQL Editor

## 📊 Project Structure

```
nano_banana_pro/
├── lib/
│   ├── core/              # Colors, fonts
│   ├── services/          # Supabase, Replicate
│   ├── widgets/           # Pixel UI components
│   ├── features/          # Upload, Generate, Result, Feed
│   └── main.dart          # App entry point
├── assets/fonts/          # ADD FONTS HERE ⚠️
├── pubspec.yaml           # Dependencies
└── README.md              # Full documentation
```

## 🎨 Customization Ideas

- Change colors in `lib/core/colors.dart`
- Add more pixel art styles
- Implement user authentication
- Add sharing functionality
- Create premium features

## 📚 Full Documentation

- **README.md** - Complete project overview
- **SETUP_GUIDE.md** - Detailed setup instructions
- **This file** - Quick reference

---

**Ready to build?** Run `flutter pub get` then `flutter run`! 🚀
