<img width="386" height="871" alt="image" src="https://github.com/user-attachments/assets/6e495d23-c6d5-4467-b1d0-3ed3028c61a5" /># ☕ Warkop Smart Management System

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
<img width="395" height="859" alt="image" src="https://github.com/user-attachments/assets/f00fff91-e9c3-48ef-8630-4f193a971ae1" />


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
| Teknologi | Kegunaan |
|-----------|----------|
| **Flutter 3.x** | Framework UI cross-platform |
| **Provider** | State management |
| **Camera** | Fitur kamera untuk absensi |
| **Image Picker** | Upload foto produk |
| **FL Chart** | Grafik dan chart analytics |
| **Google Fonts** | Typography premium |
| **Intl** | Format tanggal & mata uang Indonesia |

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
4. Import file database yang berada di `/warkop_api/warkop_db.sql`
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

### Untuk Android Emulator
```dart
// lib/utils/constants.dart
return _emulatorUrl; // http://10.0.2.2/warkop_api
```

### Untuk HP Android Asli
1. Pastikan HP dan Komputer di **WiFi yang sama**
2. Buka CMD dan jalankan `ipconfig`
3. Catat IPv4 Address (contoh: `192.168.1.100`)
4. Update di `constants.dart`:
```dart
static const String _hpUrl = "http://192.168.1.100/warkop_api";
return _hpUrl;
```

---

## 🔑 Akun Demo

| Role | Email | Password |
|------|-------|----------|
| **👑 Owner** | `owner@warkop.com` | `password` |
| **🧑‍🍳 Karyawan** | `karyawan1@warkop.com` | `password` |

---

## � Struktur Project

```
warkop_smart/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── models/                   # Data models
│   │   ├── user.dart
│   │   ├── product.dart
│   │   └── sale.dart
│   ├── providers/                # State management
│   │   ├── auth_provider.dart
│   │   ├── product_provider.dart
│   │   ├── cart_provider.dart
│   │   └── attendance_provider.dart
│   ├── screens/                  # UI screens
│   │   ├── auth/
│   │   │   └── login_screen.dart
│   │   ├── employee/
│   │   │   ├── employee_beranda.dart
│   │   │   ├── attendance_screen.dart
│   │   │   └── pos_screen.dart
│   │   └── owner/
│   │       ├── owner_beranda.dart
│   │       ├── manage_products_screen.dart
│   │       └── sales_report_screen.dart
│   ├── utils/
│   │   └── constants.dart        # Konfigurasi API & tema
│   └── widgets/                  # Reusable widgets
│
warkop_api/
├── config/
│   └── database.php              # Koneksi database
├── auth/
│   ├── login.php
│   ├── register.php
│   └── get_employees.php
├── products/
│   ├── get_products.php
│   ├── add_product.php
│   └── update_product.php
├── attendance/
│   ├── checkin.php               # Dengan validasi duplicate
│   └── checkout.php              # Dengan validasi duplicate
├── sales/
│   └── add_sale.php
├── reports/
│   ├── sales_report.php
│   └── attendance_report.php
└── uploads/                      # Folder upload gambar
    ├── products/
    ├── attendance/
    └── profiles/
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
