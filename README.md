# ☕ Warkop Smart Management System

<p align="center">
  <img src="screenshots/logo.png" alt="Warkop Smart Logo" width="200"/>
</p>

<p align="center">
  <strong>Sistem Manajemen Warung Kopi Modern Berstandar Eksekutif</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/PHP-8.x-purple?logo=php" alt="PHP"/>
  <img src="https://img.shields.io/badge/MySQL-Database-orange?logo=mysql" alt="MySQL"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="License"/>
</p>

---

## 📖 Deskripsi

**Warkop Smart** adalah sistem manajemen warung kopi modern yang dirancang untuk meningkatkan efisiensi operasional dan transparansi data. Aplikasi ini memiliki dua peran utama: **Owner (Pemilik)** dan **Karyawan**, masing-masing dengan fitur dan akses yang berbeda.

Sistem ini terdiri dari:
- 📱 **Mobile App** - Dibangun dengan Flutter untuk pengalaman pengguna yang premium
- 🖥️ **Backend API** - REST API menggunakan PHP dengan database MySQL

---

## ✨ Fitur Utama

### 👑 Untuk Owner (Pemilik)

| Fitur | Deskripsi |
|-------|-----------|
| **📊 Executive Analytics** | Dashboard dengan grafik pendapatan real-time dan statistik transaksi |
| **📦 Inventaris Produk** | Kelola stok, harga, kategori, dan foto produk dengan animasi Hero |
| **👥 Manajemen Karyawan** | Tambah, edit, hapus karyawan dengan validasi form lengkap |
| **📅 Log Kehadiran** | Pantau absensi karyawan lengkap dengan bukti foto masuk & pulang |
| **💰 Laporan Finansial** | Filter laporan penjualan harian dan bulanan dengan detail transaksi |

### 🧑‍🍳 Untuk Karyawan

| Fitur | Deskripsi |
|-------|-----------|
| **📸 Smart Attendance** | Absensi menggunakan kamera selfie dengan validasi sekali per hari |
| **🛒 Point of Sale (POS)** | Antarmuka kasir modern dengan sistem keranjang belanja |
| **📋 Riwayat Absensi** | Lihat riwayat kehadiran pribadi dengan foto bukti |
| **👤 Profil Karyawan** | Kelola informasi profil dan ubah password |

---

## 🎯 Fitur Unggulan

### 1. Smart Attendance dengan Validasi
Sistem absensi cerdas yang memastikan:
- ✅ Karyawan hanya bisa **check-in sekali** per hari
- ✅ Harus **check-in dulu** sebelum bisa check-out
- ✅ Karyawan hanya bisa **check-out sekali** per hari
- ✅ Popup notifikasi yang jelas jika mencoba absensi ulang

<!-- Screenshot: Popup validasi absensi -->
![Validasi Absensi](screenshots/attendance_validation.png)

### 2. Executive Dashboard
Dashboard owner dengan:
- 📈 Grafik trend penjualan (Line Chart)
- 💵 Quick stats pendapatan hari ini
- 📊 Statistik transaksi terbaru
- 🔔 Notifikasi stok menipis

<!-- Screenshot: Dashboard Owner -->
![Dashboard Owner](screenshots/owner_dashboard.png)

### 3. Modern POS System
Sistem kasir dengan:
- 🏷️ Kategori produk (Makanan, Minuman, Snack)
- 🔍 Pencarian produk real-time
- 🛒 Keranjang belanja interaktif
- 💳 Proses pembayaran cepat

<!-- Screenshot: POS System -->
![POS System](screenshots/pos_system.png)

### 4. Manajemen Produk
- ➕ Tambah produk dengan upload foto dari kamera/galeri
- ✏️ Edit informasi produk
- 📦 Update stok dengan mudah
- 🗑️ Hapus produk dengan konfirmasi

<!-- Screenshot: Manajemen Produk -->
![Manajemen Produk](screenshots/manage_products.png)

---

## 🛠️ Teknologi yang Digunakan

### Frontend (Mobile App)
| Teknologi | Versi | Kegunaan |
|-----------|-------|----------|
| **Flutter** | SDK ^3.8.1 | Framework UI cross-platform |
| **Provider** | ^6.1.2 | State management |
| **Camera** | ^0.11.0+1 | Fitur kamera untuk absensi selfie |
| **Image Picker** | ^1.1.2 | Upload foto produk dari galeri/kamera |
| **FL Chart** | ^0.70.2 | Grafik dan chart analytics |
| **Google Fonts** | ^6.2.1 | Typography premium |
| **Intl** | ^0.19.0 | Format tanggal & mata uang Indonesia |
| **Shared Preferences** | ^2.2.3 | Penyimpanan lokal untuk session |
| **Path Provider** | ^2.1.3 | Akses path sistem file |
| **HTTP** | ^1.2.1 | HTTP client untuk API calls |

### Backend (API)
| Teknologi | Kegunaan |
|-----------|----------|
| **PHP 8.x** | Bahasa server-side |
| **PDO MySQL** | Database connection |
| **REST API** | Arsitektur API |
| **JSON** | Format response data |

### Database
| Tabel | Deskripsi |
|-------|-----------|
| `users` | Data pengguna (owner & karyawan) |
| `products` | Data produk |
| `sales` | Data transaksi penjualan |
| `sale_items` | Detail item per transaksi |
| `attendance` | Data absensi karyawan |

---

## 🎨 Desain UI/UX

Aplikasi menggunakan tema **Executive Dark** dengan:
- 🌙 **Dark Mode** - Nyaman untuk mata
- 🎨 **Color Palette** - Purple, Cyan, Pink Neon accents
- 💎 **Glassmorphism** - Efek kaca modern
- ✨ **Micro-animations** - Transisi halus dan interaktif
- 📐 **Clean Layout** - Tata letak yang rapi dan intuitif

---

## 📱 Screenshot Aplikasi

### Halaman Login
<!-- Tambahkan screenshot login -->
![Login Screen](screenshots/login.png)

### Dashboard Owner
<!-- Tambahkan screenshot dashboard owner -->
![Owner Dashboard](screenshots/owner_dashboard.png)

### Dashboard Karyawan
<!-- Tambahkan screenshot dashboard karyawan -->
![Employee Dashboard](screenshots/employee_dashboard.png)

### Absensi Selfie
<!-- Tambahkan screenshot absensi -->
![Attendance Screen](screenshots/attendance.png)

### Point of Sale
<!-- Tambahkan screenshot POS -->
![POS Screen](screenshots/pos.png)

### Manajemen Produk
<!-- Tambahkan screenshot manajemen produk -->
![Products Screen](screenshots/products.png)

### Laporan Penjualan
<!-- Tambahkan screenshot laporan -->
![Sales Report](screenshots/sales_report.png)

---

## 🚀 Cara Instalasi

### Prasyarat
- Flutter SDK 3.x
- XAMPP (Apache + MySQL)
- VS Code / Android Studio
- Android Emulator / Physical Device

### 1. Clone Repository
```bash
git clone https://github.com/ariaffandi12/Warkop_Smart_Mobile.git
cd Warkop_Smart_Mobile
```

### 2. Setup Database & API (Backend)
1. Buka **XAMPP Control Panel** dan aktifkan **Apache** serta **MySQL**
2. Buka [localhost/phpmyadmin](http://localhost/phpmyadmin)
3. Buat database baru dengan nama `warkop_db`
4. Buat tabel-tabel berikut di database:
   - `users` - Tabel pengguna (id, name, email, password, role, photo)
   - `products` - Tabel produk (id, name, price, stock, category, image)
   - `sales` - Tabel penjualan (id, user_id, total, date)
   - `sale_items` - Tabel detail penjualan (id, sale_id, product_id, quantity, price)
   - `attendance` - Tabel absensi (id, user_id, date, check_in, check_out, photo_in, photo_out)
5. Copy folder `warkop_api` ke dalam direktori `htdocs` (contoh: `C:\xampp\htdocs\warkop_api`)

### 3. Setup Aplikasi (Frontend)
1. Buka folder `warkop_smart` di terminal
2. Install dependensi:
   ```bash
   flutter pub get
   ```
3. Konfigurasi IP Address:
   - Buka file `lib/utils/constants.dart`
   - Untuk **Emulator Android**: gunakan `10.0.2.2`
   - Untuk **HP Android Asli**: gunakan IP komputer Anda (jalankan `ipconfig` di CMD)

### 4. Menjalankan Aplikasi
```bash
# Untuk development
flutter run

# Untuk build APK
flutter build apk --release
```

---

## 🔧 Konfigurasi IP Address

Konfigurasi IP ada di file `lib/utils/constants.dart`:

```dart
// lib/utils/constants.dart
static const String _webUrl = "http://127.0.0.1/warkop_api";
static const String _emulatorUrl = "http://10.0.2.2/warkop_api";
static const String _hpUrl = "http://10.16.42.133/warkop_api"; // Ganti IP sesuai WiFi
```

### Untuk Android Emulator
Gunakan `_emulatorUrl` (sudah ada default `10.0.2.2`):
```dart
return _emulatorUrl;
```

### Untuk HP Android Asli
1. Pastikan HP dan Komputer di **WiFi yang sama**
2. Buka CMD dan jalankan `ipconfig`
3. Catat **IPv4 Address** (contoh: `192.168.1.100`)
4. Update nilai `_hpUrl` di `constants.dart`:
```dart
static const String _hpUrl = "http://192.168.1.100/warkop_api";
```
5. Pastikan return `_hpUrl` di fungsi `baseUrl`:
```dart
return _hpUrl; // Untuk HP asli
```

---

## 🔑 Akun Demo

| Role | Email | Password |
|------|-------|----------|
| **👑 Owner** | `owner@warkop.com` | `password` |
| **🧑‍🍳 Karyawan** | `` | `` |

---

## 📁 Struktur Project

```
warkop_smart/
├── lib/
│   ├── main.dart                       # Entry point aplikasi
│   │
│   ├── models/                         # Data models
│   │   ├── product_model.dart          # Model produk
│   │   └── user_model.dart             # Model user
│   │
│   ├── providers/                      # State management (Provider)
│   │   ├── attendance_provider.dart    # Provider absensi
│   │   ├── auth_provider.dart          # Provider autentikasi
│   │   ├── employee_provider.dart      # Provider karyawan
│   │   ├── product_provider.dart       # Provider produk
│   │   ├── report_provider.dart        # Provider laporan
│   │   └── sales_provider.dart         # Provider penjualan
│   │
│   ├── screens/                        # UI Screens
│   │   ├── splash_screen.dart          # Splash screen
│   │   ├── profile_screen.dart         # Halaman profil
│   │   │
│   │   ├── auth/                       # Autentikasi
│   │   │   └── login_screen.dart       # Halaman login
│   │   │
│   │   ├── employee/                   # Screens karyawan
│   │   │   ├── employee_dashboard.dart # Dashboard karyawan
│   │   │   ├── attendance_screen.dart  # Absensi selfie
│   │   │   ├── my_attendance_screen.dart # Riwayat absensi
│   │   │   ├── add_sale_screen.dart    # POS - tambah transaksi
│   │   │   └── cart_screen.dart        # Keranjang belanja
│   │   │
│   │   └── owner/                      # Screens owner
│   │       ├── owner_beranda.dart      # Beranda owner (navigasi utama)
│   │       ├── owner_dashboard.dart    # Dashboard overview
│   │       ├── analytics_dashboard_screen.dart # Analytics dengan grafik
│   │       ├── manage_products_screen.dart     # Kelola produk
│   │       ├── add_product_screen.dart         # Tambah produk
│   │       ├── edit_product_screen.dart        # Edit produk
│   │       ├── manage_employees_screen.dart    # Kelola karyawan
│   │       ├── attendance_report_screen.dart   # Laporan absensi
│   │       └── sales_report_screen.dart        # Laporan penjualan
│   │
│   └── utils/
│       └── constants.dart              # Konfigurasi API & tema warna
│
├── pubspec.yaml                        # Konfigurasi dependencies Flutter
│
warkop_api/
├── config/
│   └── database.php                    # Koneksi database MySQL
│
├── debug_path.php                      # Debug helper untuk path
│
├── auth/                               # Endpoint autentikasi
│   ├── login.php                       # Login user
│   ├── register.php                    # Register karyawan baru
│   ├── get_employees.php               # Get daftar karyawan
│   ├── delete_employee.php             # Hapus karyawan
│   ├── update_password.php             # Update password
│   └── update_profile.php              # Update profil
│
├── products/                           # Endpoint produk
│   ├── get_products.php                # Get semua produk
│   ├── add_product.php                 # Tambah produk
│   ├── update_product.php              # Update produk
│   ├── delete_product.php              # Hapus produk
│   └── update_stock.php                # Update stok
│
├── attendance/                         # Endpoint absensi
│   ├── checkin.php                     # Check-in (dengan validasi 1x/hari)
│   ├── checkout.php                    # Check-out (dengan validasi 1x/hari)
│   ├── delete_attendance.php           # Hapus record absensi
│   └── debug_path.php                  # Debug helper untuk path gambar
│
├── sales/                              # Endpoint penjualan
│   └── add_sale.php                    # Tambah transaksi
│
├── reports/                            # Endpoint laporan
│   ├── sales_report.php                # Laporan penjualan (filter harian/bulanan/karyawan)
│   └── attendance_report.php           # Laporan absensi
│
└── uploads/                            # Folder upload gambar
    ├── products/                       # Foto produk
    ├── attendance/                     # Foto absensi
    │   ├── masuk/                      # Foto check-in
    │   └── pulang/                     # Foto check-out
    └── profiles/                       # Foto profil
```

---

## 🔐 Fitur Keamanan

- ✅ **Password Hashing** - Password disimpan dengan hash yang aman
- ✅ **Input Validation** - Validasi input di frontend dan backend
- ✅ **Session Management** - Manajemen sesi pengguna
- ✅ **Duplicate Prevention** - Mencegah absensi ganda per hari

---

## 📝 Catatan Penting

1. **Pastikan XAMPP berjalan** sebelum membuka aplikasi
2. **Firewall** mungkin perlu diatur untuk mengizinkan koneksi dari HP
3. **Port 80** harus tersedia untuk Apache
4. Untuk HP Android asli, **matikan Mobile Data** dan gunakan WiFi saja

---

## 🤝 Kontributor

- **Muhammad Ari Affandi** - Developer

---

## 📄 Lisensi

Project ini dibuat untuk keperluan **Ujian Akhir Semester (UAS)** mata kuliah **Pemrograman Mobile**.

---

<p align="center">
  <strong>Developed with ❤️ for Modern Warkop Management</strong>
</p>

<p align="center">
  ☕ Warkop Smart © 2026
</p>
