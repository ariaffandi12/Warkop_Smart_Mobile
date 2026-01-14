import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'attendance_screen.dart';
import 'add_sale_screen.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4F1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, ${user?.name ?? 'Karyawan'}',
              style: const TextStyle(
                color: Color(0xFF2C1B0E),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Semangat kerjanya hari ini!',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF6B4226)),
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B4226), Color(0xFF8B5E3C)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status Absensi',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        'Belum Check-in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Menu Utama',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1B0E),
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  context,
                  title: 'Absensi',
                  icon: Icons.camera_alt_rounded,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                  ),
                ),
                _buildMenuCard(
                  context,
                  title: 'Tambah Jualan',
                  icon: Icons.add_shopping_cart_rounded,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddSaleScreen()),
                  ),
                ),
                _buildMenuCard(
                  context,
                  title: 'Riwayat Hari Ini',
                  icon: Icons.history_rounded,
                  color: Colors.green,
                  onTap: () {},
                ),
                _buildMenuCard(
                  context,
                  title: 'Profil',
                  icon: Icons.account_circle_rounded,
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C1B0E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
