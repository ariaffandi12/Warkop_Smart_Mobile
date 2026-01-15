import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/report_provider.dart';
import '../../utils/constants.dart';
import 'manage_products_screen.dart';
import 'sales_report_screen.dart';
import 'attendance_report_screen.dart';
import 'owner_dashboard.dart';
import 'edit_product_screen.dart';
import '../profile_screen.dart';
import '../auth/login_screen.dart';

// Helper function to format rupiah with thousand separators
String formatRupiah(dynamic value) {
  final num amount = num.tryParse(value?.toString() ?? '0') ?? 0;
  final formatter = NumberFormat('#,###', 'id_ID');
  return 'Rp ${formatter.format(amount)}';
}

class OwnerBeranda extends StatefulWidget {
  const OwnerBeranda({super.key});

  @override
  State<OwnerBeranda> createState() => _OwnerBerandaState();
}

class _OwnerBerandaState extends State<OwnerBeranda> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshData();
    // Set up periodic refresh every 30 seconds for "real-time" feel
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _refreshData() {
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      final reportProvider = Provider.of<ReportProvider>(
        context,
        listen: false,
      );
      // Use the current filter type from provider (synced with Sales Report)
      reportProvider.fetchSalesReport(type: reportProvider.currentFilterType);
      reportProvider.fetchAttendanceReport();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildSidebar(context, user),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(user),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStockAlertSection(),
                    const SizedBox(height: 24),
                    _buildInsightsSection(),
                    const SizedBox(height: 24),
                    _buildQuickStatsSection(),
                    const SizedBox(height: 24),
                    _buildRecentTransactionsSection(),
                    const SizedBox(height: 24),
                    _buildTipsCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(dynamic user) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat Datang,',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    user?.name ?? 'Owner',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.surface,
                    backgroundImage:
                        (user?.photo != null && user!.photo!.isNotEmpty)
                        ? NetworkImage(
                            AppConstants.profileImagesUrl + user!.photo!,
                          )
                        : null,
                    child: (user?.photo == null || user!.photo!.isEmpty)
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStockAlertSection() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        final lowStockProducts = provider.products
            .where((p) => (p.stock ?? 0) <= 5)
            .toList();

        if (lowStockProducts.isEmpty) return const SizedBox.shrink();

        return Container(
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.error.withOpacity(0.2)),
          ),
          child: ExpansionTile(
            leading: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.error,
            ),
            title: Text(
              '⚠ ${lowStockProducts.length} produk hampir habis',
              style: const TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shape: const RoundedRectangleBorder(side: BorderSide.none),
            children: lowStockProducts.map((p) {
              return ListTile(
                dense: true,
                title: Text(
                  p.name ?? 'Produk',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Text(
                  '${p.stock} pcs',
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProductScreen(product: p),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildInsightsSection() {
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        final summary = report.salesSummary;
        final yesterday = report.yesterdaySummary;

        // Comparative Insight Calculation
        final double todayIncome =
            double.tryParse(summary?['total_income']?.toString() ?? '0') ?? 0;
        final double yesterdayIncome =
            double.tryParse(yesterday?['total_income']?.toString() ?? '0') ?? 0;

        double growth = 0;
        bool isUp = true;
        if (yesterdayIncome > 0) {
          growth = ((todayIncome - yesterdayIncome) / yesterdayIncome) * 100;
          isUp = growth >= 0;
        } else if (todayIncome > 0) {
          growth = 100;
          isUp = true;
        }

        final String growthText = growth == 0 && todayIncome == 0
            ? 'Belum ada transaksi hari ini'
            : '${isUp ? '📈' : '📉'} Penjualan ${isUp ? 'naik' : 'turun'} ${growth.abs().toStringAsFixed(1)}% vs kemarin';

        // Top Product Logic
        String topProduct = 'Belum ada data';
        if (report.recentSales.isNotEmpty) {
          final Map<String, int> productCounts = {};
          for (var sale in report.recentSales) {
            final name = sale['product_name'] ?? 'Unknown';
            productCounts[name] = (productCounts[name] ?? 0) + 1;
          }
          final sorted = productCounts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));
          topProduct = sorted.first.key;
        }

        // Peak Hour Detection
        String peakHourText = 'Belum ada data';
        if (report.recentSales.isNotEmpty) {
          final Map<int, int> hourCounts = {};
          for (var sale in report.recentSales) {
            try {
              final DateTime dt = DateTime.parse(sale['created_at']);
              final int hour = dt.hour;
              hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
            } catch (_) {}
          }
          if (hourCounts.isNotEmpty) {
            final sortedHours = hourCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final int peakHour = sortedHours.first.key;
            peakHourText =
                '${peakHour.toString().padLeft(2, '0')}.00 - ${(peakHour + 1).toString().padLeft(2, '0')}.00';
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'DAILY INSIGHTS',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightCard(
              title: growthText,
              subtitle: 'Berdasarkan volume transaksi hari ini',
              icon: isUp
                  ? Icons.trending_up_rounded
                  : Icons.trending_down_rounded,
              color: isUp ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              title: '🥇 Terlaris: $topProduct',
              subtitle: 'Produk paling diminati hari ini',
              icon: Icons.emoji_events_rounded,
              color: AppColors.warning,
            ),
            const SizedBox(height: 12),
            _buildInsightCard(
              title: '⏰ Jam Ramai: $peakHourText',
              subtitle: 'Waktu transaksi terbanyak harian',
              icon: Icons.access_time_filled_rounded,
              color: AppColors.secondary,
            ),
          ],
        );
      },
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quick Stats Section - 3 cards in horizontal row
  Widget _buildQuickStatsSection() {
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        final summary = report.salesSummary;
        final totalTransactions =
            summary?['total_transactions']?.toString() ?? '0';

        // Calculate total income from recentSales if salesSummary doesn't have it
        num totalIncome = 0;
        final summaryIncome = summary?['total_income'];
        if (summaryIncome != null) {
          totalIncome = num.tryParse(summaryIncome.toString()) ?? 0;
        }

        // If still 0, calculate from recentSales
        if (totalIncome == 0 && report.recentSales.isNotEmpty) {
          for (var sale in report.recentSales) {
            totalIncome +=
                num.tryParse(sale['total_price']?.toString() ?? '0') ?? 0;
          }
        }

        // Format income for display
        String formattedIncome = 'Rp 0';
        if (totalIncome > 0) {
          if (totalIncome >= 1000000) {
            formattedIncome =
                'Rp ${(totalIncome / 1000000).toStringAsFixed(1)}jt';
          } else if (totalIncome >= 1000) {
            formattedIncome = 'Rp ${(totalIncome / 1000).toStringAsFixed(0)}rb';
          } else {
            formattedIncome = 'Rp $totalIncome';
          }
        }

        // Count products sold from recent sales
        int productsSold = 0;
        for (var sale in report.recentSales) {
          productsSold +=
              int.tryParse(sale['quantity']?.toString() ?? '1') ?? 1;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'QUICK STATS',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.filterLabel,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.receipt_long_rounded,
                    label: 'Total Transaksi',
                    value: totalTransactions,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.payments_rounded,
                    label: 'Pendapatan',
                    value: formattedIncome,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.inventory_2_rounded,
                    label: 'Produk Terjual',
                    value: '$productsSold item',
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Recent Transactions Section
  Widget _buildRecentTransactionsSection() {
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        final sales = report.recentSales.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaksi Terbaru',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SalesReportScreen(),
                      ),
                    );
                    // No force refresh - let filter persist from Sales Report
                  },
                  child: Row(
                    children: [
                      Text(
                        'Lihat Semua',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primary,
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (sales.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.textMuted,
                        size: 40,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Belum ada transaksi hari ini',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: sales.asMap().entries.map((entry) {
                    final index = entry.key;
                    final sale = entry.value;
                    final isLast = index == sales.length - 1;

                    // Parse time from created_at
                    String timeStr = '--:--';
                    try {
                      final dt = DateTime.parse(sale['created_at']);
                      timeStr =
                          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                    } catch (_) {}

                    final productName =
                        sale['product_name'] ?? sale['name'] ?? 'Produk';
                    final quantity = sale['quantity']?.toString() ?? '1';
                    final totalPrice = sale['total_price']?.toString() ?? '0';

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                                bottom: BorderSide(color: Colors.white10),
                              ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              timeStr,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '$productName x$quantity',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatRupiah(totalPrice),
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      },
    );
  }

  // Tips Card with rotating daily tips
  Widget _buildTipsCard() {
    // Get tip based on day of week for variety
    final tips = [
      'Selamat bekerja! Semangat mengelola usaha hari ini 💪',
      'Pelanggan puas = Bisnis berkembang ☕',
      'Menu favorit layak dipromosikan 🏆',
      'Restock produk sebelum kehabisan 📦',
      'Karyawan yang happy = Pelayanan terbaik 😊',
      'Akhir minggu biasanya ramai, siapkan stok ekstra! 🚀',
      'Evaluasi penjualan minggu ini untuk planning lebih baik 📊',
    ];
    final tipIndex = DateTime.now().weekday - 1;
    final currentTip = tips[tipIndex % tips.length];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.secondary.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: AppColors.warning,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tips:',
                  style: TextStyle(
                    color: AppColors.warning,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentTip,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, dynamic user) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          _buildDrawerHeader(user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  label: 'Beranda',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
                ),
                _buildDrawerItem(
                  icon: Icons.analytics_rounded,
                  label: 'Analytics Dashboard',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OwnerDashboard()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.inventory_2_rounded,
                  label: 'Inventaris Produk',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ManageProductsScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.payments_rounded,
                  label: 'Laporan Finansial',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SalesReportScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.groups_2_rounded,
                  label: 'Manajemen Tim',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AttendanceReportScreen(),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
                  child: Divider(color: Colors.white12),
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profil Owner',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: AppColors.error,
                  onTap: () async {
                    final auth = Provider.of<AuthProvider>(
                      context,
                      listen: false,
                    );
                    await auth.logout();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(dynamic user) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 60, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: (user?.photo != null && user!.photo!.isNotEmpty)
                ? NetworkImage(AppConstants.profileImagesUrl + user!.photo!)
                : null,
            child: (user?.photo == null || user!.photo!.isEmpty)
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.name ?? 'Owner',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Owner Access',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              color ?? (isSelected ? AppColors.primary : AppColors.textMuted),
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: color ?? (isSelected ? Colors.white : AppColors.textMuted),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
