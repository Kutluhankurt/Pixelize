# 🚀 Nano Banana Pro - Türkçe Kurulum Rehberi

## 📱 Proje Hakkında

Nano Banana Pro, fotoğrafları pixel art'a dönüştüren bir Flutter uygulamasıdır. Supabase ve Replicate AI kullanarak çalışır.

## ✅ Şu An Hazır Olan

Tüm kod yapısı hazır! Sadece birkaç adım kaldı:

1. ✅ Flutter kodu yazıldı (lib/ klasörü)
2. ✅ UI bileşenleri hazır (pixel button, frame, loader)
3. ✅ Supabase entegrasyonu tamamlandı
4. ✅ Replicate AI entegrasyonu tamamlandı
5. ✅ 4 sayfa hazır: Upload, Generate, Result, Feed
6. ✅ API anahtarların girildi

## ⚠️ Yapman Gerekenler

### 1. Flutter SDK'yı Yükle

```bash
# macOS için Homebrew ile:
brew install flutter

# Veya indir: https://flutter.dev/docs/get-started/install
```

Yüklemeyi kontrol et:
```bash
flutter doctor
```

### 2. Proje Klasörüne Git

```bash
cd nano_banana_pro
```

### 3. Flutter Paketlerini İndir

```bash
flutter pub get
```

Bu komut Flutter'ın gerekli paketleri indirmesini sağlar. "Target of URI doesn't exist" hatası bundan kaynaklanıyor.

### 4. Supabase Veritabanını Ayarla

Supabase Dashboard'a git (https://app.supabase.com) ve SQL Editor'da şunu çalıştır:

```sql
-- Avatarlar için tablo oluştur
CREATE TABLE avatars (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  input_image_url TEXT NOT NULL,
  output_image_url TEXT NOT NULL,
  is_public BOOLEAN DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Hızlı sorgular için index
CREATE INDEX idx_avatars_public ON avatars(is_public, created_at DESC);
```

### 5. Supabase Storage Oluştur

1. Supabase Dashboard → **Storage**
2. **New bucket** tıkla
3. İsim: `avatars`
4. **Public** seç (herkese açık)
5. Oluştur

### 6. Pixel Fontları İndir

Bu 3 fontu indir ve `assets/fonts/` klasörüne at:

1. **Press Start 2P**: https://fonts.google.com/specimen/Press+Start+2P
   - Download → PressStart2P-Regular.ttf

2. **Pixel Operator**: https://www.dafont.com/pixel-operator.font
   - Download → PixelOperator.ttf

3. **VCR OSD Mono**: https://www.dafont.com/vcr-osd-mono.font
   - Download → VCR_OSD_MONO.ttf

Klasör yapısı şöyle olmalı:
```
assets/
  fonts/
    PressStart2P-Regular.ttf
    PixelOperator.ttf
    VCR_OSD_MONO.ttf
```

### 7. (Opsiyonel) Daha İyi Pixel Art Modeli

Şu an `google/imagen-4` kullanılıyor, ama pixel art için daha iyisi var.

`lib/main.dart` dosyasını aç ve 21. satırı değiştir:

```dart
// Şu an:
const replicateModelVersion = "google/imagen-4";

// Daha iyi pixel art için:
const replicateModelVersion = "nerijs/pixel-art-xl:LATEST_VERSION";
```

Model versiyonunu Replicate.com'dan kontrol et.

### 8. iOS İzinlerini Ekle (Sadece iOS için)

`ios/Runner/Info.plist` dosyasını oluştur veya Xcode'da düzenle:

```xml
<key>NSCameraUsageDescription</key>
<string>Fotoğraf çekmek için kamera erişimi gerekiyor</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Fotoğraf seçmek için galeri erişimi gerekiyor</string>
```

### 9. Uygulamayı Çalıştır!

```bash
# iOS Simulator (sadece macOS)
flutter run -d "iPhone 15 Pro"

# Android Emulator
flutter run -d emulator-5554

# Bağlı cihazları gör
flutter devices
flutter run -d <cihaz-id>
```

## 🎯 Uygulama Nasıl Çalışır?

### Akış Şeması:

```
1. Upload Page (Yükleme)
   ↓
   Fotoğraf seç (galeri/kamera)
   ↓
   Supabase Storage'a yükle
   ↓

2. Generate Page (Oluşturma)
   ↓
   Replicate AI'ya gönder
   ↓
   Pixel art oluştur (progress bar gösterilir)
   ↓

3. Result Page (Sonuç)
   ↓
   Pixel avatar göster
   ↓
   Veritabanına kaydet
   ↓

4. Feed Page (Galeri)
   ↓
   Tüm public avatarları göster (3 sütun grid)
```

## 🔑 API Anahtarların (Zaten Girildi)

`lib/main.dart` dosyasında şunlar zaten ayarlı:

- ✅ **Supabase URL**: `https://jhyzfbgmmbnccecijiwf.supabase.co`
- ✅ **Supabase Anon Key**: Girildi
- ✅ **Replicate API Key**: Girildi

## 🐛 Hatalar ve Çözümleri

### "Target of URI doesn't exist: 'package:flutter/material.dart'"

**Sebep**: Flutter paketleri henüz indirilmemiş.

**Çözüm**:
```bash
cd nano_banana_pro
flutter pub get
```

Sonra VS Code'u yeniden başlat (Cmd+Shift+P → Reload Window).

### "Flutter command not found"

**Çözüm**: Flutter SDK'yı yükle ve PATH'e ekle:

```bash
# ~/.zshrc veya ~/.bash_profile dosyasına ekle:
export PATH="$PATH:/path/to/flutter/bin"

# Sonra:
source ~/.zshrc
```

### "Supabase upload failed"

**Çözüm**:
1. `avatars` bucket'ın oluşturulduğundan emin ol
2. Bucket'ın **public** olduğunu kontrol et
3. Supabase URL'nin doğru olduğunu kontrol et

### "Table 'avatars' does not exist"

**Çözüm**: Yukarıdaki SQL komutlarını Supabase'de çalıştır.

### "Font bulunamadı"

**Çözüm**: Font dosyalarını `assets/fonts/` klasörüne ekle ve şunu çalıştır:
```bash
flutter clean
flutter pub get
```

## 📂 Proje Yapısı

```
nano_banana_pro/
├── lib/
│   ├── core/
│   │   ├── colors.dart           # Renk paleti
│   │   └── pixel_fonts.dart      # Font tanımları
│   ├── services/
│   │   ├── supabase_service.dart # Supabase entegrasyonu
│   │   └── replicate_service.dart # AI entegrasyonu
│   ├── widgets/
│   │   ├── pixel_button.dart     # Retro buton
│   │   ├── pixel_frame.dart      # Çerçeve bileşeni
│   │   └── pixel_loader.dart     # Yükleme barı
│   ├── features/
│   │   ├── upload/               # Fotoğraf yükleme sayfası
│   │   ├── generate/             # AI oluşturma sayfası
│   │   ├── result/               # Sonuç gösterme sayfası
│   │   └── feed/                 # Topluluk galerisi
│   └── main.dart                 # Ana dosya
├── assets/
│   └── fonts/                    # ⚠️ FONTLARI BURAYA EKLE
├── pubspec.yaml                  # Bağımlılıklar
└── README.md                     # İngilizce dokümantasyon
```

## 🎨 Kullanılan Teknolojiler

- **Flutter**: Cross-platform uygulama framework'ü
- **Supabase**: Veritabanı + dosya depolama
- **Replicate AI**: Imagen-4 ile pixel art oluşturma
- **Riverpod**: State management (opsiyonel)
- **Cached Network Image**: Hızlı resim yükleme

## 🚀 Test Et

Uygulamayı çalıştırdıktan sonra:

1. ✓ "Nano Banana Pro" başlığını gör
2. ✓ "UPLOAD IMAGE" veya "TAKE PHOTO" butonuna tıkla
3. ✓ Fotoğraf seç
4. ✓ "PIXELIZING YOUR FACE..." yazısı ve progress bar gör
5. ✓ Pixel art sonucu gör
6. ✓ "GO TO FEED" ile galeriye git

## 📱 App Store İçin Hazırlık

### Gerekli Adımlar:

1. **Privacy Policy** oluştur
2. **App icon** ekle (1024x1024 PNG)
3. **Launch screen** tasarla
4. **Code signing** ayarla (iOS için Xcode'da)
5. **Ekran görüntüleri** al
6. **Uygulama açıklaması** yaz

### Güvenlik İçin:

- ⚠️ Şu an API anahtarları kodda (test için OK)
- 🔒 Production için environment variables kullan
- 🔒 Kullanıcı authentication ekle
- 🔒 Content moderation (NSFW filtresi) ekle

## 💡 Önerilen Özellikler

### İlk Aşama:
- [ ] Cihaza kaydetme özelliği (şu an "coming soon")
- [ ] Kullanıcı girişi (Supabase Auth)
- [ ] Sosyal medyada paylaşma
- [ ] Farklı pixel art stilleri

### İkinci Aşama:
- [ ] Kullanıcı profilleri
- [ ] Beğeni sistemi
- [ ] Yorumlar
- [ ] Takip sistemi

### Gelir Modeli:
- [ ] Premium pixel stiller
- [ ] Yüksek çözünürlük export
- [ ] Reklamsız abonelik
- [ ] Toplu işleme

## 🆘 Yardım

### Kullanışlı Komutlar:

```bash
# Flutter kurulumunu kontrol et
flutter doctor -v

# Bağlı cihazları gör
flutter devices

# Temiz build
flutter clean

# Paketleri güncelle
flutter pub upgrade

# Verbose mode ile çalıştır
flutter run --verbose
```

### Dokümantasyon:

- **Bu dosya**: Türkçe kurulum rehberi
- **QUICK_START.md**: Hızlı başlangıç (İngilizce)
- **SETUP_GUIDE.md**: Detaylı kurulum (İngilizce)
- **TROUBLESHOOTING.md**: Sorun giderme (İngilizce)
- **PROJECT_SUMMARY.md**: Proje özeti (İngilizce)

## ✨ Hemen Başla!

```bash
# 1. Proje klasörüne git
cd nano_banana_pro

# 2. Paketleri indir
flutter pub get

# 3. Çalıştır
flutter run
```

## 🎯 Özet Checklist

- [ ] Flutter SDK yüklendi (`flutter doctor`)
- [ ] `flutter pub get` çalıştırıldı
- [ ] Supabase'de `avatars` tablosu oluşturuldu
- [ ] Supabase'de `avatars` bucket'ı oluşturuldu
- [ ] Pixel fontları `assets/fonts/` klasörüne eklendi
- [ ] VS Code/Android Studio yeniden başlatıldı
- [ ] `flutter run` ile uygulama çalıştırıldı

---

**Başarılar! 🚀 Sorular için TROUBLESHOOTING.md dosyasına bak.**
