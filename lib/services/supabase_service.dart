import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient client;

  SupabaseService._(this.client);

  static Future<SupabaseService> init(String url, String anonKey) async {
    await Supabase.initialize(url: url, anonKey: anonKey);
    return SupabaseService._(Supabase.instance.client);
  }

  Future<String> uploadAvatarFile(File file) async {
    final ts = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'upload_$ts.png';

    final bytes = await file.readAsBytes();
    final uploadPath = await client.storage
        .from('avatars')
        .uploadBinary(fileName, bytes);

    final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);
    return publicUrl;
  }

  Future<String> uploadAvatarFileWeb(XFile file) async {
    print('🔄 Starting upload for web...');
    final ts = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'upload_$ts.png';
    print('📝 File name: $fileName');

    final bytes = await file.readAsBytes();
    print('📦 File size: ${bytes.length} bytes');

    try {
      final uploadPath = await client.storage
          .from('avatars')
          .uploadBinary(fileName, bytes);
      print('✅ Upload successful: $uploadPath');

      final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);
      print('🌐 Public URL: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Upload error: $e');
      rethrow;
    }
  }

  Future<void> saveAvatarRecord({
    required String inputUrl,
    required String outputUrl,
    bool isPublic = true,
  }) async {
    await client.from('avatars').insert({
      'input_image_url': inputUrl,
      'output_image_url': outputUrl,
      'is_public': isPublic
    });
  }

  Future<List<Map<String, dynamic>>> fetchPublicAvatars({int limit = 60}) async {
    final res = await client
        .from('avatars')
        .select()
        .eq('is_public', true)
        .order('created_at', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(res as List);
  }
}
