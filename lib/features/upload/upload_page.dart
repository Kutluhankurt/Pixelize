import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/pixel_button.dart';
import '../../widgets/pixel_frame.dart';
import '../../services/supabase_service.dart';

class UploadPage extends StatefulWidget {
  final SupabaseService supabaseService;
  final void Function(String uploadedUrl) onUploaded;

  const UploadPage(
      {required this.supabaseService, required this.onUploaded, Key? key})
      : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final picker = ImagePicker();
  File? _picked;
  XFile? _pickedWeb;
  bool _uploading = false;

  Future<void> _pickFromGallery() async {
    final p =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (p == null) return;

    setState(() {
      if (kIsWeb) {
        _pickedWeb = p;
      } else {
        _picked = File(p.path);
      }
      _uploading = true;
    });

    try {
      final publicUrl = kIsWeb
          ? await widget.supabaseService.uploadAvatarFileWeb(_pickedWeb!)
          : await widget.supabaseService.uploadAvatarFile(_picked!);

      print('🎯 Calling onUploaded callback with URL: $publicUrl');
      widget.onUploaded(publicUrl);
      print('✅ onUploaded callback completed');
    } catch (e) {
      print('❌ Upload or callback error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _pickFromCamera() async {
    final p =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (p == null) return;

    setState(() {
      if (kIsWeb) {
        _pickedWeb = p;
      } else {
        _picked = File(p.path);
      }
      _uploading = true;
    });

    try {
      final publicUrl = kIsWeb
          ? await widget.supabaseService.uploadAvatarFileWeb(_pickedWeb!)
          : await widget.supabaseService.uploadAvatarFile(_picked!);
      widget.onUploaded(publicUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1B24),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Pixelize',
                style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 18),
              ),
              const SizedBox(height: 16),
              PixelFrame(
                child: (_picked == null && _pickedWeb == null)
                    ? const SizedBox(
                        width: 240,
                        height: 240,
                        child: Icon(Icons.camera_alt,
                            color: Colors.white70, size: 64),
                      )
                    : kIsWeb
                        ? Image.network(_pickedWeb!.path,
                            width: 240, height: 240, fit: BoxFit.cover)
                        : Image.file(_picked!,
                            width: 240, height: 240, fit: BoxFit.cover),
              ),
              const SizedBox(height: 18),
              if (_uploading)
                const CircularProgressIndicator()
              else ...[
                PixelButton(text: 'UPLOAD IMAGE', onTap: _pickFromGallery),
                const SizedBox(height: 8),
                PixelButton(text: 'TAKE PHOTO', onTap: _pickFromCamera),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
