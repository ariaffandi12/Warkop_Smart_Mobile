import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/product_provider.dart';
import 'providers/sales_provider.dart';
import 'providers/report_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/employee/employee_dashboard.dart';
import 'screens/owner/owner_dashboard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => ReportProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warkop Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4226), // Coffee brown
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.outfitTextTheme(),
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (auth.isAuthenticated) {
            return auth.user!.role == 'owner'
                ? const OwnerDashboard()
                : const EmployeeDashboard();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}
