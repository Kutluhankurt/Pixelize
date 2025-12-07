import 'package:flutter/material.dart';
import 'services/supabase_service.dart';
import 'services/replicate_service.dart';
import 'features/upload/upload_page.dart';
import 'features/generate/generate_page.dart';
import 'features/result/result_page.dart';
import 'features/feed/feed_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Replace with your actual Supabase URL (not the PostgreSQL connection string)
  // The correct format is: https://your-project-id.supabase.co
  const supabaseUrl = 'YOUR_SUPABASE_URL';
  const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Replicate API configuration
  const replicateApiKey = 'YOUR_REPLICATE_API_KEY';

  // TODO: Replace with actual Replicate model version for pixelation
  // Example: "stability-ai/sdxl:xxxxx" or your chosen pixel art model
  const replicateModelVersion =
      'google/imagen-4'; // Using Imagen-4 as specified in your code

  final supa = await SupabaseService.init(supabaseUrl, supabaseAnonKey);
  final replicate = ReplicateService(
    apiKey: replicateApiKey,
    modelVersion: replicateModelVersion,
  );

  runApp(MyApp(supabaseService: supa, replicateService: replicate));
}

class MyApp extends StatelessWidget {
  final SupabaseService supabaseService;
  final ReplicateService replicateService;

  const MyApp({
    required this.supabaseService,
    required this.replicateService,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nano Banana Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'PressStart2P',
        scaffoldBackgroundColor: const Color(0xFF1F1B24),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => UploadPage(
              supabaseService: supabaseService,
              onUploaded: (url) {
                print('📍 onUploaded callback received URL: $url');
                print('📍 Navigating to GeneratePage...');
                try {
                  Navigator.of(ctx).push(
                    MaterialPageRoute(
                      builder: (_) {
                        print('📍 Building GeneratePage');
                        return GeneratePage(
                          inputImageUrl: url,
                          replicateService: replicateService,
                          supabaseService: supabaseService,
                        );
                      },
                    ),
                  );
                  print('📍 Navigation completed');
                } catch (e) {
                  print('❌ Navigation error: $e');
                }
              },
            ),
        '/result': (ctx) {
          final args = ModalRoute.of(ctx)!.settings.arguments as String?;
          return ResultPage(imageUrl: args ?? '');
        },
        '/feed': (ctx) => FeedPage(supabaseService: supabaseService),
      },
    );
  }
}
