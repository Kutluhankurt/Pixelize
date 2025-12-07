import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/supabase_service.dart';

class FeedPage extends StatefulWidget {
  final SupabaseService supabaseService;

  const FeedPage({required this.supabaseService, Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Map<String, dynamic>> avatars = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await widget.supabaseService.fetchPublicAvatars(limit: 90);
      setState(() {
        avatars = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1F1B24),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1F1B24),
        body: Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1F1B24),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1B24),
        title: const Text(
          'Community Feed',
          style: TextStyle(
              fontFamily: 'PressStart2P', fontSize: 10, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: avatars.isEmpty
            ? const Center(
                child: Text(
                  'No avatars yet!',
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'PressStart2P'),
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: avatars.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, idx) {
                  final item = avatars[idx];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/result',
                          arguments: item['output_image_url']);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.black)),
                      child: CachedNetworkImage(
                        imageUrl: item['output_image_url'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
