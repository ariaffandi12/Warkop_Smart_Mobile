import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import 'manage_products_screen.dart';
import 'attendance_report_screen.dart';
import 'sales_report_screen.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchSalesReport(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dashboard Owner',
          style: TextStyle(
            color: Color(0xFF2C1B0E),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6B4226)),
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ReportProvider>(
          context,
          listen: false,
        ).fetchSalesReport(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              Consumer<ReportProvider>(
                builder: (context, report, _) {
                  if (report.isLoading) {
                    return const LinearProgressIndicator();
                  }
                  final total = report.salesSummary?['total_income'] ?? 0;
                  final count = report.salesSummary?['total_transactions'] ?? 0;

                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6B4226), Color(0xFFBC8F8F)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Penjualan Hari Ini',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp $total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$count Transaksi',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              const Text(
                'Manajemen',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C1B0E),
                ),
              ),
              const SizedBox(height: 16),
              _buildOwnerMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOwnerMenu(BuildContext context) {
    return Column(
      children: [
        _buildListTile(
          context,
          title: 'Kelola Produk & Stok',
          subtitle: 'Tambah, edit, dan restock produk',
          icon: Icons.inventory_2_rounded,
          color: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ManageProductsScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          title: 'Laporan Penjualan',
          subtitle: 'Lihat detail transaksi harian/bulanan',
          icon: Icons.bar_chart_rounded,
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SalesReportScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          title: 'Laporan Absensi',
          subtitle: 'Monitoring kehadiran karyawan',
          icon: Icons.assignment_ind_rounded,
          color: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AttendanceReportScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}
