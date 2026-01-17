import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../utils/constants.dart';

class MyAttendanceScreen extends StatefulWidget {
  const MyAttendanceScreen({super.key});

  @override
  State<MyAttendanceScreen> createState() => _MyAttendanceScreenState();
}

class _MyAttendanceScreenState extends State<MyAttendanceScreen> {
  String _selectedMonth = '';
  final List<Map<String, String>> _months = [];

  @override
  void initState() {
    super.initState();
    _generateMonthOptions();
    _selectedMonth = _months.isNotEmpty ? _months[0]['value']! : '';

    Future.microtask(() {
      if (mounted) {
        final userName = Provider.of<AuthProvider>(
          context,
          listen: false,
        ).user?.name;
        if (userName != null) {
          Provider.of<ReportProvider>(
            context,
            listen: false,
          ).fetchPersonalAttendance(userName, month: _selectedMonth);
        }
      }
    });
  }

  void _generateMonthOptions() {
    final now = DateTime.now();
    for (int i = 0; i < 6; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      _months.add({
        'label': DateFormat('MMMM yyyy', 'id_ID').format(date),
        'value': DateFormat('yyyy-MM').format(date),
      });
    }
  }

  void _onMonthChanged(String? month) {
    if (month == null) return;
    setState(() => _selectedMonth = month);
    final userName = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).user?.name;
    if (userName != null) {
      Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchPersonalAttendance(userName, month: month);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Riwayat Absensi Saya',
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
          return RefreshIndicator(
            onRefresh: () async {
              final userName = Provider.of<AuthProvider>(
                context,
                listen: false,
              ).user?.name;
              if (userName != null) {
                await provider.fetchPersonalAttendance(
                  userName,
                  month: _selectedMonth,
                );
              }
            },
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Month Filter
                  _buildMonthFilter(),
                  const SizedBox(height: 20),

                  // Summary Cards
                  _buildSummaryCards(provider),
                  const SizedBox(height: 24),

                  // Attendance List Title
                  const Text(
                    'Log Kehadiran',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Loading or List
                  if (provider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (provider.personalAttendance.isEmpty)
                    _buildEmptyState()
                  else
                    ...provider.personalAttendance.map(
                      (log) => _buildAttendanceCard(log),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedMonth,
          isExpanded: true,
          dropdownColor: AppColors.surface,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textSecondary,
          ),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          items: _months.map((m) {
            return DropdownMenuItem(
              value: m['value'],
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(m['label']!),
                ],
              ),
            );
          }).toList(),
          onChanged: _onMonthChanged,
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ReportProvider provider) {
    final summary = provider.attendanceSummary;
    final totalHadir = summary['total_hadir'] ?? 0;
    final totalSelesai = summary['total_selesai'] ?? 0;
    final rataJam = summary['rata_jam'] ?? 0.0;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline,
            label: 'Total Hadir',
            value: '$totalHadir hari',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.timer_outlined,
            label: 'Rata-rata Jam',
            value: '${rataJam.toStringAsFixed(1)} jam',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.done_all,
            label: 'Selesai',
            value: '$totalSelesai hari',
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: AppColors.textMuted.withOpacity(0.5),
            size: 60,
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada data absensi',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 4),
          const Text(
            'Data absensi kamu akan muncul di sini',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(dynamic log) {
    final checkIn = DateTime.parse(log['check_in']);
    final checkOut = log['check_out'] != null
        ? DateTime.parse(log['check_out'])
        : null;
    final isComplete = log['status'] == 'selesai';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date & Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('EEEE, d MMM yyyy', 'id_ID').format(checkIn),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isComplete ? 'SELESAI' : 'BEKERJA',
                  style: TextStyle(
                    color: isComplete ? AppColors.success : AppColors.warning,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Check-in & Check-out Row
          Row(
            children: [
              _buildTimeColumn(
                label: 'Masuk',
                time: DateFormat('HH:mm').format(checkIn),
                photo: log['photo_in'],
                isIn: true,
              ),
              const Spacer(),
              _buildTimeColumn(
                label: 'Keluar',
                time: checkOut != null
                    ? DateFormat('HH:mm').format(checkOut)
                    : '--:--',
                photo: log['photo_out'],
                isIn: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn({
    required String label,
    required String time,
    String? photo,
    required bool isIn,
  }) {
    final String fullUrl = (photo != null && photo.isNotEmpty)
        ? (isIn
                  ? AppConstants.attendanceImagesInUrl
                  : AppConstants.attendanceImagesOutUrl) +
              photo
        : '';

    return Row(
      children: [
        GestureDetector(
          onTap: fullUrl.isNotEmpty
              ? () => _showImagePreview(fullUrl, label)
              : null,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              image: fullUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(fullUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (photo == null || photo.isEmpty)
                ? const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.textMuted,
                    size: 18,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showImagePreview(String imageUrl, String title) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Foto $title',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Icon(Icons.close_rounded, color: Colors.white),
                ],
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
