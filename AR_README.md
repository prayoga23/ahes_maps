# Fitur Web AR untuk Fasilitas AHES

## Deskripsi
Aplikasi ini telah dilengkapi dengan fitur Web AR (Augmented Reality) untuk setiap fasilitas di Asrama Haji Embarkasi Surabaya (AHES). Setiap fasilitas memiliki koordinat GPS yang spesifik dan dapat ditampilkan dalam mode AR.

## Fasilitas yang Tersedia

### 1. Gedung Hall Mina
- **Koordinat**: -7.284952331606736, 112.77897043496384
- **ID**: 1
- **Gambar**: hall_mina.jpg

### 2. Gedung Muzdalifah
- **Koordinat**: -7.2852341338859725, 112.77900526197112
- **ID**: 2
- **Gambar**: musdhalifah.jpg

### 3. Gedung Zam-Zam
- **Koordinat**: -7.28526975568221, 112.778024470646
- **ID**: 3
- **Gambar**: zam-zam.jpg

### 4. Masjid
- **Koordinat**: -7.282747114926446, 112.77830549612212
- **ID**: 4
- **Gambar**: masjid.jpg

## Cara Menggunakan

### 1. Akses Menu AR Fasilitas
1. Buka aplikasi AHES Maps
2. Pada halaman beranda, pilih menu "AR Fasilitas"
3. Anda akan melihat daftar semua fasilitas dengan gambar dan koordinat

### 2. Menjalankan AR
1. Pilih fasilitas yang ingin Anda lihat dalam AR
2. Klik tombol "Lihat AR"
3. Aplikasi akan meminta izin untuk mengakses kamera dan GPS
4. Arahkan kamera ke lokasi fasilitas sesuai koordinat yang ditentukan

### 3. Fitur AR yang Tersedia
- **Tampilan 3D**: Setiap fasilitas ditampilkan dengan marker 3D yang berputar
- **Informasi Real-time**: Panel informasi menampilkan nama fasilitas dan koordinat
- **Perhitungan Jarak**: Sistem akan menghitung jarak dari posisi Anda ke fasilitas
- **Kontrol AR**: Tombol untuk toggle info dan refresh AR

## File yang Dibuat

### 1. Template HTML
- `lib/WebAR/template.html` - Template dasar untuk AR
- `lib/WebAR/advanced_template.html` - Template canggih dengan fitur tambahan

### 2. Screen Flutter
- `lib/screens/facility_ar_screen.dart` - Screen untuk menampilkan AR per fasilitas
- `lib/screens/facility_list_screen.dart` - Screen daftar fasilitas dengan tombol AR

### 3. Data
- `lib/constants/asrama.dart` - Data fasilitas dengan koordinat yang diperbarui

## Teknologi yang Digunakan

### Frontend (Flutter)
- `webview_flutter` - Untuk menampilkan konten HTML
- Material Design - Untuk UI/UX yang konsisten

### Web AR (HTML/JavaScript)
- **A-Frame** - Framework untuk AR/VR
- **AR.js** - Library untuk AR berbasis web
- **GPS-based AR** - AR berdasarkan koordinat GPS

## Persyaratan Sistem

### Hardware
- Smartphone dengan GPS
- Kamera untuk AR
- Akses internet untuk loading library

### Software
- Flutter SDK
- WebView support
- Browser yang mendukung WebGL

## Troubleshooting

### AR Tidak Muncul
1. Pastikan GPS aktif
2. Pastikan Anda berada di lokasi yang sesuai dengan koordinat
3. Refresh AR dengan tombol refresh
4. Pastikan kamera memiliki izin akses

### Error Loading
1. Periksa koneksi internet
2. Restart aplikasi
3. Clear cache aplikasi

## Pengembangan Selanjutnya

### Fitur yang Dapat Ditambahkan
1. **AR Marker Detection** - Deteksi marker fisik
2. **3D Model Fasilitas** - Model 3D yang lebih detail
3. **Informasi Interaktif** - Popup informasi saat tap
4. **Navigasi AR** - Petunjuk arah ke fasilitas
5. **Offline Support** - AR tanpa internet

### Optimasi
1. **Performance** - Optimasi loading dan rendering
2. **Accuracy** - Peningkatan akurasi GPS
3. **UI/UX** - Peningkatan interface pengguna

## Kontribusi
Untuk menambahkan fasilitas baru:
1. Tambahkan data di `lib/constants/asrama.dart`
2. Tambahkan gambar di `assets/image/`
3. Update koordinat yang akurat
4. Test AR di lokasi yang sesuai 