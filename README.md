# 🎨 Pixelize

8bit Show Case - A pixelated avatar generator app built with Flutter, Supabase, and Replicate AI.

## 🚀 Features

- **Photo Upload**: Upload from gallery or take photos directly
- **AI Pixelation**: Transform photos into pixel art using Replicate AI
- **Cloud Storage**: Store avatars in Supabase
- **Community Feed**: Browse public pixel avatars
- **Retro UI**: Authentic pixel-art design with custom fonts

## 🛠️ Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Supabase**: Backend-as-a-Service (storage + database)
- **Replicate**: AI model hosting (Imagen-4 for pixelation)
- **Riverpod**: State management
- **Cached Network Image**: Efficient image loading

## 📋 Prerequisites

Before running the app, ensure you have:

1. **Flutter SDK** installed (3.0.0 or higher)
2. **Supabase project** set up with:
   - `avatars` storage bucket
   - `avatars` table with columns:
     - `id` (uuid, primary key)
     - `input_image_url` (text)
     - `output_image_url` (text)
     - `is_public` (boolean)
     - `created_at` (timestamp)
3. **Replicate API key**
4. **Pixel fonts** in `assets/fonts/`:
   - PressStart2P-Regular.ttf
   - PixelOperator.ttf
   - VCR_OSD_MONO.ttf

## 🔧 Setup

1. **Clone and navigate to project**:
   ```bash
   cd nano_banana_pro
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Configure API keys** in `lib/main.dart`:
   - Replace `supabaseUrl` with your Supabase project URL
   - Your `supabaseAnonKey` is already configured
   - Your `replicateApiKey` is already configured

4. **Add pixel fonts** to `assets/fonts/` directory

5. **Configure Supabase**:
   - Create `avatars` storage bucket (make it public)
   - Create `avatars` table with the schema mentioned above
   - Enable Row Level Security policies as needed

## 🏃 Running the App

### iOS
```bash
flutter run -d ios
```

### Android
```bash
flutter run -d android
```

## 📱 App Store Preparation

### Important Considerations

1. **Privacy Policy**: Required for App Store submission
   - Disclose photo collection and storage
   - Explain Supabase and Replicate usage
   - Include data retention policies

2. **Permissions** (add to `Info.plist` for iOS):
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>We need camera access to take photos for pixelation</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>We need photo library access to select images for pixelation</string>
   ```

3. **Content Moderation**:
   - Consider adding NSFW filtering
   - Implement user reporting system for inappropriate content

4. **API Key Security**:
   - Move API keys to environment variables or secure storage
   - Use backend proxy for production

5. **TestFlight**:
   - Configure code signing in Xcode
   - Set up App Store Connect account
   - Create app listing with screenshots

## 🗂️ Project Structure

```
lib/
├── core/
│   ├── colors.dart          # Color palette
│   └── pixel_fonts.dart     # Font definitions
├── services/
│   ├── supabase_service.dart   # Supabase integration
│   └── replicate_service.dart  # Replicate AI integration
├── widgets/
│   ├── pixel_button.dart    # Custom button component
│   ├── pixel_frame.dart     # Frame component
│   └── pixel_loader.dart    # Loading bar component
├── features/
│   ├── upload/
│   │   └── upload_page.dart    # Photo upload screen
│   ├── generate/
│   │   └── generate_page.dart  # AI generation screen
│   ├── result/
│   │   └── result_page.dart    # Result display screen
│   └── feed/
│       └── feed_page.dart      # Community feed screen
└── main.dart                # App entry point
```

## 🔐 Security Notes

- **Never commit API keys** to version control
- The current `main.dart` contains placeholder keys for demo purposes
- For production, use environment variables or Flutter's secure storage
- Implement proper authentication before App Store release

## 📝 Next Steps

1. Add pixel fonts to `assets/fonts/`
2. Test locally with `flutter run`
3. Configure proper API key management
4. Set up Supabase database schema
5. Test Replicate integration
6. Prepare for TestFlight deployment

## 🐛 Known Issues

- Save to device feature not yet implemented
- API keys are hardcoded (move to secure storage)
- No user authentication (add before public release)
- No content moderation filters

## 📄 License

This is a starter template. Add your own license as needed.

## 🤝 Contributing

This is a personal project template. Fork and modify as needed!

---

**Built with ❤️ using Flutter, Supabase, and Replicate**
