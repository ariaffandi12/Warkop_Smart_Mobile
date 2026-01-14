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
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        actions: [
          PopupMenuButton<String>(
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
            return const Center(child: CircularProgressIndicator());

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4226),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pendapatan',
                      style: TextStyle(color: Colors.white70),
                    ),
                    Text(
                      'Rp ${provider.salesSummary?['total_income'] ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: provider.recentSales.isEmpty
                    ? const Center(child: Text('Belum ada transaksi.'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: provider.recentSales.length,
                        itemBuilder: (context, index) {
                          final sale = provider.recentSales[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text('Rp ${sale['total_price']}'),
                              subtitle: Text('Oleh: ${sale['karyawan_name']}'),
                              trailing: Text(
                                sale['created_at'].toString().split(' ')[1],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
