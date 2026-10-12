# Mitra-Asset System (MAS) Mobile App

Aplikasi mobile resmi untuk Mitra-Asset System (MAS) PT Jasanet yang dibangun menggunakan **Flutter (Dart)**.

## Fitur Utama
1. **Autentikasi User**: Terintegrasi langsung dengan endpoint sesi PHP MAS.
2. **Absensi Staff (Presensi Kamera & GPS)**:
   - Snapshot selfie kamera depan (`camera` package).
   - Penguncian koordinat GPS akurasi tinggi (meter) (`geolocator`).
   - Reverse geocoding alamat lokasi (`geocoding`).
   - Jadwal kerja otomatis 10:00 - 18:00 WIB (Senin - Jumat) & bonus lembur weekend Rp 100k/hari.
3. **Master & Operasional**:
   - Sinkronisasi data Service RMA.
   - Maintenance report & tiket dukungan.

## Menjalankan Aplikasi
```bash
flutter pub get
flutter run
```

## Build APK Android
```bash
flutter build apk --release
```
File APK output berada di `build/app/outputs/flutter-apk/app-release.apk`.
