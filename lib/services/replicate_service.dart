import 'dart:convert';
import 'package:http/http.dart' as http;

class ReplicateService {
  final String apiKey;
  final String modelVersion;

  ReplicateService({required this.apiKey, required this.modelVersion});

  Future<String> startPrediction(String imageUrl,
      {String pixelStyle = '8bit'}) async {
    print('🎨 Starting Replicate prediction...');
    print('📷 Image URL: $imageUrl');
    print('🎯 Model: $modelVersion');

    // TEMPORARY: Skip Replicate API due to CORS in web
    // Return a fake prediction ID
    print('⚠️ Using TEMPORARY fake prediction (CORS bypass for web testing)');
    print('✅ Fake prediction started');
    return 'fake-prediction-${DateTime.now().millisecondsSinceEpoch}';

    /* ORIGINAL CODE - Re-enable when backend proxy is ready
    final uri = Uri.parse('https://api.replicate.com/v1/predictions');
    final body = jsonEncode({
      'version': modelVersion,
      'input': {
        'prompt': 'The photo: Create a cinematic, photorealistic pixel art style image. Transform this into retro 8-bit pixel art with vibrant colors and nostalgic gaming aesthetics.',
        'image': imageUrl,
        'aspect_ratio': '1:1'
      }
    });

    print('📤 Sending request to Replicate...');

    try {
      final r = await http.post(
        uri,
        headers: {
          'Authorization': 'Token $apiKey',
          'Content-Type': 'application/json'
        },
        body: body,
      );

      print('📥 Response status: ${r.statusCode}');
      print('📥 Response body: ${r.body}');

      if (r.statusCode != 201 && r.statusCode != 200) {
        throw Exception('Replicate start failed: ${r.body}');
      }

      final data = jsonDecode(r.body);
      final predictionId = data['id'];
      print('✅ Prediction started: $predictionId');
      return predictionId;
    } catch (e) {
      print('❌ Replicate error: $e');
      rethrow;
    }
    */
  }

  Future<Map<String, dynamic>> getPrediction(String id) async {
    final uri = Uri.parse('https://api.replicate.com/v1/predictions/$id');
    final r = await http.get(
      uri,
      headers: {
        'Authorization': 'Token $apiKey',
      },
    );

    if (r.statusCode != 200) {
      throw Exception('Replicate get failed: ${r.body}');
    }

    return jsonDecode(r.body);
  }

  Future<String?> pollResult(String id,
      {int intervalMs = 1500, int maxAttempts = 60, String? inputImageUrl}) async {

    // TEMPORARY: If using fake prediction, simulate processing and return input image
    if (id.startsWith('fake-prediction-')) {
      print('⚠️ Fake prediction detected, simulating processing...');

      // Simulate progress updates
      for (int i = 0; i <= 100; i += 20) {
        print('🔄 Processing... $i%');
        await Future.delayed(Duration(milliseconds: 500));
      }

      print('✅ Fake processing complete! Returning input image as result');
      // Return the input image URL as the "pixelized" result for testing
      return inputImageUrl ?? 'https://via.placeholder.com/512';
    }

    // ORIGINAL CODE: Real Replicate polling
    int attempts = 0;
    while (attempts < maxAttempts) {
      final data = await getPrediction(id);
      final status = data['status'];

      if (status == 'succeeded') {
        // output genellikle data['output'] -> list of urls
        final output = data['output'];
        if (output is List && output.isNotEmpty) {
          return output[0] as String;
        } else if (output is String) {
          return output;
        }
      } else if (status == 'failed') {
        throw Exception('Replicate job failed: $data');
      }

      await Future.delayed(Duration(milliseconds: intervalMs));
      attempts++;
    }

    throw Exception('Replicate polling timed out');
  }
}
