import 'package:flutter/material.dart';
import '../../widgets/pixel_loader.dart';
import '../../services/replicate_service.dart';
import '../../services/supabase_service.dart';

class GeneratePage extends StatefulWidget {
  final String inputImageUrl;
  final ReplicateService replicateService;
  final SupabaseService supabaseService;

  const GeneratePage({
    required this.inputImageUrl,
    required this.replicateService,
    required this.supabaseService,
    Key? key,
  }) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

class _GeneratePageState extends State<GeneratePage> {
  double progress = 0.0;
  String? resultUrl;
  String? error;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      final id =
          await widget.replicateService.startPrediction(widget.inputImageUrl);

      // Simple progressive poll with slight progress animation
      for (int i = 0; i < 6; i++) {
        await Future.delayed(const Duration(milliseconds: 600));
        setState(() {
          progress += 0.1;
        });
      }

      final output = await widget.replicateService.pollResult(
        id,
        intervalMs: 1500,
        maxAttempts: 60,
        inputImageUrl: widget.inputImageUrl, // Pass input image for fake response
      );

      if (output != null) {
        setState(() {
          resultUrl = output;
          progress = 1.0;
        });

        // Save to DB automatically (public by default)
        await widget.supabaseService.saveAvatarRecord(
          inputUrl: widget.inputImageUrl,
          outputUrl: resultUrl!,
          isPublic: true,
        );
      }
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1F1B24),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Error',
                  style: TextStyle(
                      fontFamily: 'PressStart2P', color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  error!,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (resultUrl == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1F1B24),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'PIXELIZING YOUR FACE...',
                style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 10),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PixelLoader(progress: progress),
            ],
          ),
        ),
      );
    } else {
      // Navigate to ResultPage
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context)
            .pushReplacementNamed('/result', arguments: resultUrl);
      });
      return Container();
    }
  }
}
