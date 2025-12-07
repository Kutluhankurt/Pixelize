import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../widgets/pixel_button.dart';

class ResultPage extends StatelessWidget {
  final String imageUrl;

  const ResultPage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1B24),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Your Pixel Avatar',
                style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 12),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 6, color: Colors.black)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SizedBox(
                    width: 300,
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(
                    width: 300,
                    height: 300,
                    child: Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              PixelButton(
                text: 'SAVE TO DEVICE',
                onTap: () {
                  // TODO: Implement saving via gallery_saver or similar plugin
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Save feature coming soon!')),
                  );
                },
              ),
              const SizedBox(height: 8),
              PixelButton(
                text: 'GO TO FEED',
                onTap: () {
                  Navigator.of(context).pushNamed('/feed');
                },
              ),
              const SizedBox(height: 8),
              PixelButton(
                text: 'CREATE ANOTHER',
                onTap: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
