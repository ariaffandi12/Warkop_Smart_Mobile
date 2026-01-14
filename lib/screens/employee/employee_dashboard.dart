import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../utils/constants.dart';
import '../profile_screen.dart';
import 'attendance_screen.dart';
import 'add_sale_screen.dart';
import '../auth/login_screen.dart';
import '../owner/sales_report_screen.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  void initState() {
    super.initState();
    // Fetch today's sales report when dashboard loads
    Future.microtask(
      () => Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchSalesReport(type: 'today'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final reportProvider = Provider.of<ReportProvider>(context);

    // Calculate total for today
    int totalToday = 0;
    if (reportProvider.salesSummary != null) {
      // Assuming API returns total_amount as int or string
      totalToday =
          int.tryParse(
            reportProvider.salesSummary!['total_income'].toString(),
          ) ??
          0;
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0B0F1A), Color(0xFF171C34)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async =>
                reportProvider.fetchSalesReport(type: 'today'),
            color: const Color(0xFF6B4226),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: (user?.photo != null)
                            ? NetworkImage(
                                AppConstants.profileImagesUrl + user!.photo!,
                              )
                            : null,
                        backgroundColor: const Color(0xFF1F2937),
                        child: (user?.photo == null)
                            ? const Icon(Icons.person, color: Color(0xFF9CA3AF))
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Halo, ${user?.name ?? 'User'} 👋',
                              style: const TextStyle(
                                color: Color(0xFFE5E7EB),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF22C55E),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Aktif Bekerja',
                                  style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Total Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF12172A),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C5CFF).withOpacity(0.15),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(color: const Color(0xFF1F2937)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💰 Total Hari Ini',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp ',
                            decimalDigits: 0,
                          ).format(totalToday),
                          style: const TextStyle(
                            color: Color(0xFFE5E7EB),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    'Menu Operasional',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Menu List
                  _buildMenuItem(
                    title: 'Absensi Hadir',
                    subtitle: 'Check-in & Check-out',
                    icon: Icons.access_time_filled_rounded,
                    color: const Color(0xFF7C5CFF),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AttendanceScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    title: 'Catat Penjualan',
                    subtitle: 'Input pesanan baru',
                    icon: Icons.calculate_rounded,
                    color: const Color(0xFFF59E0B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddSaleScreen()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    title: 'Riwayat Penjualan',
                    subtitle: 'Lihat laporan transaksi',
                    icon: Icons.bar_chart_rounded,
                    color: const Color(0xFF22D3EE),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SalesReportScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItem(
                    title: 'Pengaturan',
                    subtitle: 'Profil & Akun',
                    icon: Icons.settings_rounded,
                    color: const Color(0xFFEC4899),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF12172A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFE5E7EB),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF4B5563)),
            ],
          ),
        ),
      ),
    );
  }
}
