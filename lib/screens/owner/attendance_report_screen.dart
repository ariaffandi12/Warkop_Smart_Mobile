import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../utils/constants.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchAttendanceReport(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Absensi')),
      body: Consumer<ReportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading)
            return const Center(child: CircularProgressIndicator());
          if (provider.attendanceRecords.isEmpty)
            return const Center(child: Text('Tidak ada riwayat absensi.'));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.attendanceRecords.length,
            itemBuilder: (context, index) {
              final record = provider.attendanceRecords[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record['karyawan_name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTimeInfo(
                            'Masuk',
                            record['check_in'],
                            record['photo_in'],
                            AppConstants.attendanceImagesInUrl,
                          ),
                          if (record['check_out'] != null)
                            _buildTimeInfo(
                              'Pulang',
                              record['check_out'],
                              record['photo_out'],
                              AppConstants.attendanceImagesOutUrl,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTimeInfo(
    String label,
    String? time,
    String? photo,
    String baseUrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        Text(
          time?.split(' ')[1] ?? '-',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        if (photo != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              baseUrl + photo,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
      ],
    );
  }
}
