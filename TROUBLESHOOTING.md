# 🔧 Troubleshooting Guide

## Common Errors & Solutions

### Error: "Target of URI doesn't exist: 'package:flutter/material.dart'"

**Cause**: Flutter SDK not installed OR `flutter pub get` not run yet.

**Solution**:

1. **Install Flutter SDK first**:
   ```bash
   # macOS
   brew install flutter

   # Or download from https://flutter.dev/docs/get-started/install
   ```

2. **Verify Flutter installation**:
   ```bash
   flutter doctor
   ```

3. **Navigate to project and get dependencies**:
   ```bash
   cd nano_banana_pro
   flutter pub get
   ```

4. **If using VS Code**, reload the window:
   - Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
   - Type "Reload Window"
   - Press Enter

5. **If using Android Studio/IntelliJ**:
   - File → Invalidate Caches / Restart
   - File → Sync Project with Gradle Files

### Error: "Flutter command not found"

**Solution**: Flutter SDK not in PATH. Add to your shell profile:

```bash
# For bash (~/.bash_profile or ~/.bashrc)
export PATH="$PATH:/path/to/flutter/bin"

# For zsh (~/.zshrc)
export PATH="$PATH:/path/to/flutter/bin"

# Then reload:
source ~/.zshrc  # or ~/.bash_profile
```

### Error: "No valid iOS code signing key found"

**Solution**:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your Apple Developer Team
3. Or use automatic signing for development

### Error: "Supabase upload failed"

**Possible causes & solutions**:

1. **Bucket doesn't exist**:
   - Go to Supabase Dashboard → Storage
   - Create bucket named `avatars`
   - Make it public

2. **Wrong bucket permissions**:
   - Check bucket policies
   - Ensure public access is enabled

3. **Invalid Supabase URL**:
   - Verify URL format: `https://your-project.supabase.co`
   - NOT the PostgreSQL connection string

### Error: "Replicate prediction failed"

**Solutions**:

1. **Check API key format**:
   ```dart
   // Correct:
   const replicateApiKey = "r8_...";

   // Wrong:
   const replicateApiKey = "export REPLICATE_API_TOKEN=r8_...";
   ```

2. **Verify model version**:
   - Check model exists on Replicate
   - Use latest version ID
   - Example: `"nerijs/pixel-art-xl:abc123..."`

3. **Check quota**:
   - Go to Replicate dashboard
   - Verify you have credits/quota remaining

### Error: "Table 'avatars' does not exist"

**Solution**: Run SQL in Supabase SQL Editor:

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

### Error: "Font 'PressStart2P' is not a system font"

**Solution**:

1. **Download fonts** and place in `assets/fonts/`:
   - Press Start 2P: https://fonts.google.com/specimen/Press+Start+2P
   - Pixel Operator: https://www.dafont.com/pixel-operator.font
   - VCR OSD Mono: https://www.dafont.com/vcr-osd-mono.font

2. **Verify directory structure**:
   ```
   assets/
     fonts/
       PressStart2P-Regular.ttf
       PixelOperator.ttf
       VCR_OSD_MONO.ttf
   ```

3. **Run**:
   ```bash
   flutter clean
   flutter pub get
   ```

### Error: "MissingPluginException"

**Solution**:

1. **Stop the app completely**
2. **Run**:
   ```bash
   flutter clean
   flutter pub get
   ```
3. **Restart the app**

For iOS specifically:
```bash
cd ios
pod install
cd ..
flutter run
```

### Error: "Camera/Gallery permission denied"

**iOS Solution**: Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos for pixelation</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need photo library access to select images</string>
```

**Android Solution**: Permissions are automatically handled by `image_picker` plugin.

### Error: "Build failed" or "Gradle error"

**Solution**:

1. **Update Android SDK**:
   - Open Android Studio
   - Tools → SDK Manager
   - Update to latest SDK

2. **Clean build**:
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   flutter run
   ```

3. **Check Java version**:
   ```bash
   java -version
   # Should be Java 11 or higher for Flutter 3.x
   ```

### Error: "CocoaPods not installed" (iOS)

**Solution**:
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
flutter run
```

### Error: "Cached network image won't load"

**Solutions**:

1. **Check internet connection**
2. **Verify image URL is public**
3. **Clear cache**:
   ```bash
   flutter clean
   ```
4. **Check for CORS issues** (web only)

### Error: "App crashes on launch"

**Debug steps**:

1. **Check logs**:
   ```bash
   flutter run --verbose
   ```

2. **Run in debug mode**:
   ```bash
   flutter run --debug
   ```

3. **Check for null safety issues**:
   - All variables properly initialized?
   - Nullable types handled with `?` and `!` correctly?

4. **Verify API keys**:
   - Check Supabase URL format
   - Check Replicate key is valid

### Performance Issues

**Optimization tips**:

1. **Use const constructors** where possible
2. **Run in release mode** for testing:
   ```bash
   flutter run --release
   ```
3. **Profile the app**:
   ```bash
   flutter run --profile
   ```
4. **Check image sizes** - compress before upload

## 🆘 Still Having Issues?

### Debugging Checklist

- [ ] Flutter SDK installed? (`flutter doctor`)
- [ ] Dependencies installed? (`flutter pub get`)
- [ ] Supabase database table created?
- [ ] Supabase storage bucket created?
- [ ] Fonts added to `assets/fonts/`?
- [ ] API keys correct in `lib/main.dart`?
- [ ] Internet connection working?
- [ ] IDE restarted after making changes?

### Useful Debug Commands

```bash
# Check Flutter installation
flutter doctor -v

# See connected devices
flutter devices

# Clean build artifacts
flutter clean

# Update packages
flutter pub upgrade

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Build in verbose mode
flutter run --verbose
```

### Getting Help

1. **Check Flutter documentation**: https://flutter.dev/docs
2. **Supabase docs**: https://supabase.com/docs
3. **Replicate docs**: https://replicate.com/docs
4. **Stack Overflow**: Tag with `flutter`, `supabase`, `replicate`

### Debug Logging

Add debug prints to track issues:

```dart
// In lib/services/supabase_service.dart
print('Uploading file: ${file.path}');
print('Upload result: $publicUrl');

// In lib/services/replicate_service.dart
print('Starting prediction with ID: $id');
print('Prediction status: $status');
```

---

**Most issues are resolved by running `flutter pub get` and restarting your IDE!**
