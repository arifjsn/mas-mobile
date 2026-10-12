import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/constants/app_constants.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  CameraController? _cameraController;
  bool _isCameraReady = false;
  String _attendanceType = 'in'; // 'in' or 'out'
  final TextEditingController _notesController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final frontCam = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      _cameraController = CameraController(
        frontCam,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController!.initialize();
      if (mounted) setState(() => _isCameraReady = true);
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _submitAttendance() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;
    setState(() => _isSubmitting = true);

    try {
      final xFile = await _cameraController!.takePicture();
      final bytes = await xFile.readAsBytes();
      final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

      final formData = FormData.fromMap({
        'type': _attendanceType,
        'photo': base64Image,
        'notes': _notesController.text.trim(),
      });

      final response = await ApiClient().dio.post(
        '${AppConstants.attendancesUrl}?action=submit',
        data: formData,
      );

      if (response.data['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.data['message'] ?? 'Presensi berhasil!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception(response.data['error'] ?? 'Gagal presensi');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Presensi Staff')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 280,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: _isCameraReady
                ? Center(child: CameraPreview(_cameraController!))
                : const Center(child: CircularProgressIndicator(color: Colors.white)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Check In'),
                  value: 'in',
                  groupValue: _attendanceType,
                  onChanged: (v) => setState(() => _attendanceType = v!),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Check Out'),
                  value: 'out',
                  groupValue: _attendanceType,
                  onChanged: (v) => setState(() => _attendanceType = v!),
                ),
              ),
            ],
          ),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Catatan (Opsional)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitAttendance,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: _isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.camera_alt),
            label: Text(_isSubmitting ? 'Mengirim...' : 'Kirim Presensi', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
