import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';

class SalesReportScreen extends StatefulWidget {
  const SalesReportScreen({super.key});

  @override
  State<SalesReportScreen> createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends State<SalesReportScreen> {
  String _filterType = 'today';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    Future.microtask(
      () => Provider.of<ReportProvider>(
        context,
        listen: false,
      ).fetchSalesReport(type: _filterType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1B),
      appBar: AppBar(
        title: const Text(
          'Laporan Penjualan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF1B1B1B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.white70),
            onSelected: (value) {
              setState(() => _filterType = value);
              _fetchData();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'today', child: Text('Hari Ini')),
              const PopupMenuItem(value: 'monthly', child: Text('Bulan Ini')),
            ],
          ),
        ],
      ),
      body: Consumer<ReportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading)
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B4226)),
            );

          return RefreshIndicator(
            onRefresh: () async => provider.fetchSalesReport(type: _filterType),
            color: const Color(0xFF6B4226),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildAnalyticsSummary(provider),
                const Padding(
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history_rounded,
                        color: Colors.white38,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'RIWAYAT TRANSAKSI',
                        style: TextStyle(
                          color: Colors.white38,
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
                        style: TextStyle(color: Colors.grey),
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
                        color: const Color(0xFF252525),
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
                            color: const Color(0xFF6B4226).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_rounded,
                            color: Color(0xFF6B4226),
                          ),
                        ),
                        title: Text(
                          'Rp ${sale['total_price']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          'Oleh: ${sale['karyawan_name']}',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
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
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              sale['created_at'].toString().split(' ')[0],
                              style: const TextStyle(
                                color: Colors.white24,
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
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2C1B0E),
            const Color(0xFF1B1B1B).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
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
              color: Colors.white38,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp ${provider.salesSummary?['total_income'] ?? 0}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white12),
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
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }
}
