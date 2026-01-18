import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/report_provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import 'owner_beranda.dart';
import 'manage_products_screen.dart';
import 'sales_report_screen.dart';
import 'attendance_report_screen.dart';
import '../profile_screen.dart';
import '../auth/login_screen.dart';
import 'manage_employees_screen.dart';

// Helper function to format rupiah
String _formatRupiah(dynamic value) {
  if (value == null) return 'Rp 0';
  final numValue = double.tryParse(value.toString()) ?? 0;
  final formatter = NumberFormat('#,###', 'id_ID');
  return 'Rp ${formatter.format(numValue.toInt())}';
}

String _formatCompact(dynamic value) {
  if (value == null) return '0';
  final numValue = double.tryParse(value.toString()) ?? 0;
  if (numValue >= 1000000) {
    return '${(numValue / 1000000).toStringAsFixed(1)}M';
  } else if (numValue >= 1000) {
    return '${(numValue / 1000).toStringAsFixed(0)}K';
  }
  return numValue.toInt().toString();
}

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  int _selectedNavIndex = 1; // Analytics selected

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    await Future.wait([
      reportProvider.fetchSalesReport(type: 'today'),
      reportProvider.fetchSalesReport(type: 'yesterday'),
      productProvider.fetchProducts(),
    ]);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildSidebar(user),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKPICards(),
                      const SizedBox(height: 24),
                      _buildRevenueTrendChart(),
                      const SizedBox(height: 24),
                      _buildTopProductsChart(),
                      const SizedBox(height: 24),
                      _buildCategoryDistribution(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.surface,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'LIVE',
                style: TextStyle(
                  color: AppColors.success,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Warkop Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.surface, AppColors.background],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKPICards() {
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        final summary = report.salesSummary;
        final yesterday = report.yesterdaySummary;

        final todayIncome =
            double.tryParse(summary?['total_income']?.toString() ?? '0') ?? 0;
        final yesterdayIncome =
            double.tryParse(yesterday?['total_income']?.toString() ?? '0') ?? 0;

        double growthPercent = 0;
        if (yesterdayIncome > 0) {
          growthPercent =
              ((todayIncome - yesterdayIncome) / yesterdayIncome) * 100;
        }

        final totalTransactions = summary?['total_transactions'] ?? 0;
        final avgOrder = totalTransactions > 0
            ? todayIncome / totalTransactions
            : 0;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColors.primary,
                    value: totalTransactions.toString(),
                    label: 'Total Sales',
                    sublabel: 'transactions',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKPICard(
                    icon: Icons.account_balance_wallet_rounded,
                    iconColor: AppColors.secondary,
                    value: 'Rp ${_formatCompact(todayIncome)}',
                    label: 'Revenue',
                    sublabel: 'today',
                    isHighlighted: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    icon: Icons.shopping_bag_rounded,
                    iconColor: AppColors.warning,
                    value: 'Rp ${_formatCompact(avgOrder)}',
                    label: 'Average',
                    sublabel: 'Order',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildKPICard(
                    icon: Icons.trending_up_rounded,
                    iconColor: growthPercent >= 0
                        ? AppColors.success
                        : AppColors.error,
                    value:
                        '${growthPercent >= 0 ? '+' : ''}${growthPercent.toStringAsFixed(1)}%',
                    label: 'Growth',
                    sublabel: 'vs yesterday',
                    valueColor: growthPercent >= 0
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
    required String sublabel,
    bool isHighlighted = false,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.05),
        ),
        boxShadow: isHighlighted
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: isHighlighted ? 0.3 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const Spacer(),
              Text(
                sublabel,
                style: TextStyle(
                  color: isHighlighted ? Colors.white70 : AppColors.textMuted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color:
                  valueColor ??
                  (isHighlighted ? Colors.white : AppColors.textPrimary),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isHighlighted ? Colors.white70 : AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueTrendChart() {
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        final sales = List.from(report.recentSales.reversed);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '7-Day Revenue Trend',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Weekly',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 180,
                child: sales.isEmpty
                    ? _buildEmptyChart('No sales data')
                    : _buildLineChart(sales),
              ),
              const SizedBox(height: 16),
              _buildChartLegend(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLineChart(List sales) {
    List<FlSpot> spots = [];
    for (int i = 0; i < sales.length && i < 7; i++) {
      final price = double.tryParse(sales[i]['total_price'].toString()) ?? 0;
      spots.add(FlSpot(i.toDouble(), price / 1000)); // in thousands
    }

    if (spots.length == 1) {
      spots.insert(0, const FlSpot(-1, 0));
    }

    if (spots.isEmpty) {
      spots = [const FlSpot(0, 0), const FlSpot(1, 0)];
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 50,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withValues(alpha: 0.05),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final index = value.toInt();
                if (index >= 0 && index < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[index],
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}K',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppColors.primary,
                  strokeWidth: 2,
                  strokeColor: AppColors.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.3),
                  AppColors.primary.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (spot) => AppColors.card,
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                return LineTooltipItem(
                  'Rp ${(barSpot.y * 1000).toInt()}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          'Revenue (in thousands)',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildTopProductsChart() {
    return Consumer<ReportProvider>(
      builder: (context, report, _) {
        // Aggregate sales by product
        final Map<String, double> productSales = {};
        for (var sale in report.recentSales) {
          final productName = sale['product_name']?.toString() ?? 'Unknown';
          final totalPrice =
              double.tryParse(sale['total_price']?.toString() ?? '0') ?? 0;
          productSales[productName] =
              (productSales[productName] ?? 0) + totalPrice;
        }

        // Sort and get top 5
        final sortedProducts = productSales.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topProducts = sortedProducts.take(5).toList();

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top 5 Products',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (topProducts.isEmpty)
                _buildEmptyChart('No product data')
              else
                ...topProducts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final maxValue = topProducts.isNotEmpty
                      ? topProducts.first.value
                      : 1;
                  final percentage = (product.value / maxValue).clamp(0.0, 1.0);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildProductBar(
                      name: product.key,
                      value: product.value,
                      percentage: percentage,
                      color: _getProductColor(index),
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Color _getProductColor(int index) {
    const colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.warning,
      AppColors.success,
      AppColors.accent,
    ];
    return colors[index % colors.length];
  }

  Widget _buildProductBar({
    required String name,
    required double value,
    required double percentage,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              _formatRupiah(value),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  height: 8,
                  width: constraints.maxWidth * percentage,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.7)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              right: 8,
              top: -2,
              child: Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryDistribution() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        final products = productProvider.products;

        // Simple category distribution based on product count
        final Map<String, int> categories = {
          'Minuman': 0,
          'Makanan': 0,
          'Snacks': 0,
          'Lainnya': 0,
        };

        for (var product in products) {
          final name = product.name.toLowerCase();
          if (name.contains('kopi') ||
              name.contains('teh') ||
              name.contains('es') ||
              name.contains('jus') ||
              name.contains('susu')) {
            categories['Minuman'] = categories['Minuman']! + 1;
          } else if (name.contains('nasi') ||
              name.contains('mie') ||
              name.contains('goreng') ||
              name.contains('ayam')) {
            categories['Makanan'] = categories['Makanan']! + 1;
          } else if (name.contains('roti') ||
              name.contains('toast') ||
              name.contains('snack') ||
              name.contains('kentang')) {
            categories['Snacks'] = categories['Snacks']! + 1;
          } else {
            categories['Lainnya'] = categories['Lainnya']! + 1;
          }
        }

        final total = categories.values.fold<int>(0, (sum, val) => sum + val);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category Distribution',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 150,
                      child: total == 0
                          ? _buildEmptyChart('No data')
                          : _buildDonutChart(categories, total),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCategoryLegendItem(
                          'Minuman',
                          categories['Minuman']!,
                          total,
                          AppColors.primary,
                        ),
                        const SizedBox(height: 12),
                        _buildCategoryLegendItem(
                          'Makanan',
                          categories['Makanan']!,
                          total,
                          AppColors.secondary,
                        ),
                        const SizedBox(height: 12),
                        _buildCategoryLegendItem(
                          'Snacks',
                          categories['Snacks']!,
                          total,
                          AppColors.warning,
                        ),
                        const SizedBox(height: 12),
                        _buildCategoryLegendItem(
                          'Lainnya',
                          categories['Lainnya']!,
                          total,
                          AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDonutChart(Map<String, int> categories, int total) {
    final categoryColors = {
      'Minuman': AppColors.primary,
      'Makanan': AppColors.secondary,
      'Snacks': AppColors.warning,
      'Lainnya': AppColors.textMuted,
    };

    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 3,
            centerSpaceRadius: 40,
            sections: categories.entries.map((entry) {
              return PieChartSectionData(
                value: entry.value.toDouble(),
                color: categoryColors[entry.key] ?? AppColors.textMuted,
                radius: 25,
                showTitle: false,
                titleStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList(),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Rp ${_formatCompact(_getTotalRevenue())}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Total Revenue',
              style: TextStyle(color: AppColors.textMuted, fontSize: 9),
            ),
          ],
        ),
      ],
    );
  }

  double _getTotalRevenue() {
    final report = Provider.of<ReportProvider>(context, listen: false);
    return double.tryParse(
          report.salesSummary?['total_income']?.toString() ?? '0',
        ) ??
        0;
  }

  Widget _buildCategoryLegendItem(
    String label,
    int count,
    int total,
    Color color,
  ) {
    final percentage = total > 0 ? (count / total * 100).toInt() : 0;
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyChart(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            color: AppColors.textMuted.withValues(alpha: 0.5),
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.analytics_rounded, 'Analytics', 1),
              _buildNavItem(Icons.receipt_long_rounded, 'Reports', 2),
              _buildNavItem(Icons.settings_rounded, 'Settings', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OwnerBeranda()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SalesReportScreen()),
            );
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar(dynamic user) {
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
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const OwnerBeranda()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.analytics_rounded,
                  label: 'Analytics Dashboard',
                  isSelected: true,
                  onTap: () => Navigator.pop(context),
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
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            backgroundImage: (user?.photo != null && user!.photo!.isNotEmpty)
                ? NetworkImage(AppConstants.profileImagesUrl + user!.photo!)
                : null,
            onBackgroundImageError:
                (user?.photo != null && user!.photo!.isNotEmpty)
                ? (_, __) {}
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
                  user?.name ?? 'Admin Owner',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Warkop Analytics',
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
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
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
