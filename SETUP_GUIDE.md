# 🎯 Nano Banana Pro - Setup Guide

This guide will walk you through setting up the complete Nano Banana Pro project from scratch.

## 📦 Step 1: Install Flutter

If you don't have Flutter installed:

```bash
# macOS (using Homebrew)
brew install flutter

# Or download from: https://flutter.dev/docs/get-started/install
```

Verify installation:
```bash
flutter doctor
```

## 🗄️ Step 2: Configure Supabase

### Create Storage Bucket

1. Go to your Supabase dashboard: https://app.supabase.com
2. Navigate to **Storage** → **Create bucket**
3. Name it `avatars`
4. Make it **public** (or configure RLS policies)

### Create Database Table

Run this SQL in Supabase SQL Editor:

```sql
-- Create avatars table
CREATE TABLE avatars (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  input_image_url TEXT NOT NULL,
  output_image_url TEXT NOT NULL,
  is_public BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX idx_avatars_public ON avatars(is_public, created_at DESC);

-- Optional: Enable Row Level Security
ALTER TABLE avatars ENABLE ROW LEVEL SECURITY;

-- Policy: Allow public reads for public avatars
CREATE POLICY "Public avatars are viewable by everyone"
  ON avatars FOR SELECT
  USING (is_public = true);

-- Policy: Allow anyone to insert avatars (adjust based on your auth needs)
CREATE POLICY "Anyone can insert avatars"
  ON avatars FOR INSERT
  WITH CHECK (true);
```

### Get Your Supabase Credentials

Your credentials are already in `lib/main.dart`:
- **URL**: `https://jhyzfbgmmbnccecijiwf.supabase.co`
- **Anon Key**: Already configured

## 🤖 Step 3: Configure Replicate

Your Replicate API key is already configured in `lib/main.dart`.

### Choose a Model

The current setup uses `google/imagen-4`, but for pixel art, consider:

1. **Flux Pixel Art** (Recommended for pixel avatars):
   ```
   Model: nerijs/pixel-art-xl
   Version: Check replicate.com for latest
   ```

2. **Custom Pixel Model**:
   - Search "pixel art" on Replicate
   - Update `replicateModelVersion` in `main.dart`

To update the model:
```dart
// In lib/main.dart, change this line:
const replicateModelVersion = "nerijs/pixel-art-xl:LATEST_VERSION";
```

## 🎨 Step 4: Add Pixel Fonts

Download and add these fonts to `assets/fonts/`:

1. **Press Start 2P**: https://fonts.google.com/specimen/Press+Start+2P
2. **Pixel Operator**: https://www.dafont.com/pixel-operator.font
3. **VCR OSD Mono**: https://www.dafont.com/vcr-osd-mono.font

Directory structure:
```
assets/
  fonts/
    PressStart2P-Regular.ttf
    PixelOperator.ttf
    VCR_OSD_MONO.ttf
```

## 🔧 Step 5: Install Dependencies

```bash
cd nano_banana_pro
flutter pub get
```

## 🧪 Step 6: Test the App

### Option A: Use iOS Simulator (macOS only)
```bash
# List available simulators
flutter devices

# Run on iOS simulator
flutter run -d "iPhone 15 Pro"
```

### Option B: Use Android Emulator
```bash
# Make sure Android emulator is running
flutter run -d emulator-5554
```

### Option C: Test on Physical Device
```bash
# Connect device via USB
flutter devices
flutter run -d <device-id>
```

## 🐛 Step 7: Testing Checklist

- [ ] App launches without errors
- [ ] Can select image from gallery
- [ ] Can take photo with camera
- [ ] Image uploads to Supabase storage
- [ ] Replicate API call starts
- [ ] Progress bar animates during generation
- [ ] Generated pixel art displays
- [ ] Can navigate to community feed
- [ ] Feed shows public avatars

## 🚨 Common Issues & Solutions

### Issue: "Flutter command not found"
**Solution**: Make sure Flutter is in your PATH:
```bash
export PATH="$PATH:`pwd`/flutter/bin"
```

### Issue: "Supabase connection failed"
**Solution**:
- Verify your Supabase URL is correct (not the PostgreSQL connection string)
- Check that your anon key is valid
- Ensure the `avatars` bucket exists

### Issue: "Replicate prediction failed"
**Solution**:
- Verify API key is correct (remove `export REPLICATE_API_TOKEN=` prefix)
- Check model version is valid
- Look at Replicate dashboard for quota limits

### Issue: "Font not found"
**Solution**:
- Ensure fonts are in `assets/fonts/`
- Run `flutter clean && flutter pub get`
- Verify font names match exactly in `pubspec.yaml`

### Issue: "Permission denied for camera/gallery"
**Solution**:
- iOS: Add permissions to `ios/Runner/Info.plist`
- Android: Permissions are auto-handled by `image_picker`

## 📱 Step 8: Prepare for App Store

### iOS Code Signing

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your team in **Signing & Capabilities**
3. Update bundle identifier (e.g., `com.yourname.nanobananapro`)

### Build for TestFlight

```bash
# Build iOS release
flutter build ios --release

# Or use Xcode to archive and upload
```

### Android Release

```bash
# Generate release APK
flutter build apk --release

# Or generate App Bundle for Play Store
flutter build appbundle --release
```

## 🔐 Step 9: Secure Your API Keys (Production)

For production, move API keys to environment variables:

1. Create `lib/config/env.dart`:
```dart
class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseKey = String.fromEnvironment('SUPABASE_KEY');
  static const replicateKey = String.fromEnvironment('REPLICATE_KEY');
}
```

2. Run with environment variables:
```bash
flutter run --dart-define=SUPABASE_URL=your_url \
            --dart-define=SUPABASE_KEY=your_key \
            --dart-define=REPLICATE_KEY=your_key
```

## 🎉 Next Features to Add

- [ ] User authentication (Supabase Auth)
- [ ] Save to device functionality
- [ ] Share to social media
- [ ] Different pixel art styles
- [ ] Upvoting/liking system
- [ ] User profiles
- [ ] In-app purchases for premium styles
- [ ] Content moderation

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Replicate API Docs](https://replicate.com/docs)
- [App Store Guidelines](https://developer.apple.com/app-store/review/guidelines/)

---

**Need help?** Check the main README.md or file an issue in your repository.
