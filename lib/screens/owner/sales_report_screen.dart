import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/report_provider.dart';
import '../../utils/constants.dart';

// Helper function to format rupiah with thousand separators
String formatRupiah(dynamic value) {
  final num amount = num.tryParse(value?.toString() ?? '0') ?? 0;
  final formatter = NumberFormat('#,###', 'id_ID');
  return 'Rp ${formatter.format(amount)}';
}

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data with current filter type from provider
    Future.microtask(() {
      final provider = Provider.of<ReportProvider>(context, listen: false);
      provider.fetchEmployees(); // Fetch employee list
      provider.fetchSalesReport(type: provider.currentFilterType);
    });
  }

  void _showEmployeeFilter(BuildContext context, ReportProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Karyawan',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // All employees option
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: provider.selectedEmployeeId == null
                      ? AppColors.primary
                      : AppColors.subCard,
                  child: const Icon(
                    Icons.people,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  'Semua Karyawan',
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                trailing: provider.selectedEmployeeId == null
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () {
                  provider.changeEmployeeFilter(null);
                  Navigator.pop(context);
                },
              ),
              const Divider(color: AppColors.subCard),
              // Employee list
              ...provider.employees.map((emp) {
                final empId = int.tryParse(emp['id'].toString()) ?? 0;
                final isSelected = provider.selectedEmployeeId == empId;
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: isSelected
                        ? AppColors.primary
                        : AppColors.subCard,
                    child: Text(
                      (emp['name'] ?? 'K')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    emp['name'] ?? 'Unknown',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    provider.changeEmployeeFilter(empId);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Laporan Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          // Employee Filter Button
          Consumer<ReportProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(
                      Icons.person_search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    if (provider.selectedEmployeeId != null)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _showEmployeeFilter(context, provider),
              );
            },
          ),
          // Date Filter Button
          Consumer<ReportProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<String>(
                icon: const Icon(
                  Icons.filter_list_rounded,
                  color: AppColors.textSecondary,
                ),
                color: AppColors.surface,
                onSelected: (value) {
                  provider.changeFilter(value);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'today',
                    child: Row(
                      children: [
                        Icon(
                          provider.currentFilterType == 'today'
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: provider.currentFilterType == 'today'
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Hari Ini',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'monthly',
                    child: Row(
                      children: [
                        Icon(
                          provider.currentFilterType == 'monthly'
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: provider.currentFilterType == 'monthly'
                              ? AppColors.primary
                              : AppColors.textMuted,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Bulan Ini',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<ReportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                provider.fetchSalesReport(type: provider.currentFilterType),
            color: AppColors.primary,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                // Employee filter indicator
                if (provider.selectedEmployeeId != null)
                  Container(
                    margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Filter: ${provider.selectedEmployeeName}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => provider.changeEmployeeFilter(null),
                          child: const Icon(
                            Icons.close,
                            color: AppColors.primary,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                _buildAnalyticsSummary(provider),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: AppColors.textMuted,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'RIWAYAT TRANSAKSI',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                if (provider.recentSales.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Text(
                        'Belum ada transaksi.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  ...provider.recentSales.map((sale) {
                    return Container(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                        left: 16,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          sale['product_name'] ?? sale['name'] ?? 'Produk',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatRupiah(sale['total_price']),
                              style: TextStyle(
                                color: AppColors.success,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Oleh: ${sale['karyawan_name'] ?? 'Unknown'}',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              sale['created_at']
                                  .toString()
                                  .split(' ')[1]
                                  .substring(0, 5),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              sale['created_at'].toString().split(' ')[0],
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsSummary(ReportProvider provider) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, Color(0xFF5E36FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Total Pendapatan',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            formatRupiah(provider.salesSummary?['total_income'] ?? 0),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                provider.salesSummary?['total_transactions']?.toString() ?? '0',
                'Total Transaksi',
              ),
              _buildStatItem('Status', 'Success'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }
}
