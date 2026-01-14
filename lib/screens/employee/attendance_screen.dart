import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/auth_provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  File? _image;
  final _picker = ImagePicker();

  Future<void> _takePhoto(bool isCheckIn) async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 50,
    );

    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });

      if (!mounted) return;
      final userId = Provider.of<AuthProvider>(context, listen: false).user!.id;
      final provider = Provider.of<AttendanceProvider>(context, listen: false);

      bool success;
      if (isCheckIn) {
        success = await provider.checkIn(userId, _image!);
      } else {
        success = await provider.checkOut(userId, _image!);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'Berhasil!' : 'Gagal. Silahkan coba lagi.'),
          ),
        );
        if (success) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Absensi Selfie')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(24),
              ),
              child: _image == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Foto selfie belum diambil'),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(_image!, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _takePhoto(true),
                    icon: const Icon(Icons.login),
                    label: const Text('Check-in'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _takePhoto(false),
                    icon: const Icon(Icons.logout),
                    label: const Text('Check-out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
