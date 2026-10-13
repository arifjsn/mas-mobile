import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/api/api_client.dart';
import '../attendance/attendance_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final String role;

  const HomeScreen({
    Key? key,
    required this.username,
    required this.role,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _today;

  @override
  void initState() {
    super.initState();
    _today = _loadToday();
  }

  Future<Map<String, dynamic>> _loadToday() async {
    final response = await ApiClient().dio.get(
      '${AppConstants.attendancesUrl}?action=today_status',
    );
    if (response.data is! Map || response.data['success'] != true) {
      throw Exception('Gagal memuat waktu absensi');
    }
    return Map<String, dynamic>.from(response.data['data']);
  }

  String _time(dynamic record) {
    if (record == null) return 'Belum tercatat';
    final timestamp = DateTime.tryParse(record['created_at'].toString());
    if (timestamp == null) return 'Waktu tidak tersedia';
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')} WIB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade600,
                    child: Text(
                      widget.username.isNotEmpty ? widget.username.substring(0, widget.username.length >= 2 ? 2 : 1).toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.username, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.role.toUpperCase(),
                          style: TextStyle(color: Colors.blue.shade800, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<Map<String, dynamic>>(
            future: _today,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return TextButton(
                  onPressed: () => setState(() => _today = _loadToday()),
                  child: const Text('Waktu absensi gagal dimuat. Coba lagi'),
                );
              }
              final status = snapshot.data!;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Absensi ${status['date']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Check-in: ${_time(status['check_in'])}'),
                      Text('Check-out: ${_time(status['check_out'])}'),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const Text('Operations', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.white,
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.access_time_filled, color: Colors.white),
            ),
            title: const Text('Absensi Staff', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Presensi kamera & lokasi GPS'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AttendanceScreen()),
              );
              if (mounted) setState(() => _today = _loadToday());
            },
          ),
        ],
      ),
    );
  }
}
