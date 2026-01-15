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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Log Kehadiran Karyawan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Consumer<ReportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchAttendanceReport(),
            color: AppColors.primary,
            child: provider.attendanceRecords.isEmpty
                ? const Center(
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 400,
                        child: Center(
                          child: Text(
                            'Belum ada log kehadiran.',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final log = provider.attendanceRecords[index];
                      return _buildAttendanceCard(log);
                    },
                  ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceCard(dynamic log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log['karyawan_name'],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      log['check_in'].toString().split(' ')[0],
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: log['status'] == 'selesai'
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  log['status'] == 'selesai' ? 'SELESAI' : 'BEKERJA',
                  style: TextStyle(
                    color: log['status'] == 'selesai'
                        ? AppColors.success
                        : AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildPhotoColumn(
                'Masuk',
                log['photo_in'],
                log['check_in'].toString().split(' ')[1],
              ),
              const Spacer(),
              _buildPhotoColumn(
                'Pulang',
                log['photo_out'],
                log['check_out']?.toString().split(' ')[1] ?? '--:--',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoColumn(String label, String? photo, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                image: (photo != null && photo.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(
                          (label == 'Masuk'
                                  ? AppConstants.attendanceImagesInUrl
                                  : AppConstants.attendanceImagesOutUrl) +
                              photo,
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: (photo == null || photo.isEmpty)
                  ? const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              time.substring(0, 5),
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
