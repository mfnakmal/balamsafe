# 🌊 BalamSafe

**BalamSafe** adalah aplikasi **Peringatan Dini Banjir Bandar Lampung** berbasis mobile yang dibuat untuk membantu pengguna memantau kondisi curah hujan di beberapa wilayah kecamatan. Aplikasi ini menampilkan status kondisi wilayah seperti **Aman**, **Waspada**, dan **Bahaya** berdasarkan data curah hujan.

---

## 👥 Nama Kelompok

**BalamSafe**

---

## 👨‍💻 Anggota Kelompok

* **Muhammad Fauzan Akmal** - 23311043
* **Bintang Mahardinata Sukmaji** - 22311082
* **Aditya Pratama** - 23311054
* **Hendra** - 23311046

---

## 📱 Tentang Aplikasi

BalamSafe dirancang sebagai aplikasi pemantauan dini banjir yang berfokus pada wilayah **Bandar Lampung**. Aplikasi ini memberikan informasi curah hujan, status risiko banjir, rekomendasi tindakan, serta riwayat notifikasi peringatan.

Dengan tampilan modern dan mudah digunakan, BalamSafe diharapkan dapat membantu masyarakat untuk lebih waspada terhadap potensi banjir.

---

## ✨ Fitur Utama

* 🌧️ Menampilkan data curah hujan per wilayah
* 🚦 Menentukan status wilayah: **Aman**, **Waspada**, atau **Bahaya**
* 📍 Menampilkan lokasi wilayah pada peta
* 🔔 Notifikasi peringatan saat kondisi masuk level bahaya
* 🗂️ Penyimpanan data lokal menggunakan SQLite
* 📊 Pantauan daftar wilayah kecamatan
* ⚙️ Halaman pengaturan aplikasi
* 💡 Rekomendasi tindakan berdasarkan kondisi curah hujan

---

## 🛠️ Teknologi yang Digunakan

* **Flutter**
* **Dart**
* **SQLite / Sqflite**
* **Flutter Local Notifications**
* **Flutter Map**
* **OpenStreetMap**
* **HTTP Package**

---

## 🧭 Status Peringatan

Aplikasi menggunakan logika sederhana berdasarkan curah hujan:

| Curah Hujan   | Status  | Keterangan                  |
| ------------- | ------- | --------------------------- |
| < 5 mm/jam    | Aman    | Kondisi curah hujan rendah  |
| 5 - 15 mm/jam | Waspada | Curah hujan mulai meningkat |
| > 15 mm/jam   | Bahaya  | Risiko banjir tinggi        |

---

## 📌 Wilayah Pemantauan

Beberapa wilayah yang tersedia dalam aplikasi:

* Bumi Waras
* Enggal
* Kedamaian
* Kedaton
* Kemiling
* Labuhan Ratu
* Panjang
* Rajabasa
* Sukabumi
* Sukarame
* Teluk Betung
* Way Halim
* dan wilayah Bandar Lampung lainnya

---

## 🚀 Cara Menjalankan Project

Pastikan Flutter sudah terinstall di komputer.

### 1. Clone Repository

```bash
git clone https://github.com/mfnakmal/balamsafe.git
```

### 2. Masuk ke Folder Project

```bash
cd balamsafe
```

### 3. Install Dependency

```bash
flutter pub get
```

### 4. Jalankan Aplikasi

```bash
flutter run
```

---

## 📁 Struktur Project

```bash
lib/
├── core/
│   └── utils/
├── data/
│   ├── database/
│   ├── models/
│   └── services/
├── ui/
│   ├── screens/
│   └── widgets/
└── main.dart
```

---

## 🎯 Tujuan Aplikasi

Tujuan dari aplikasi BalamSafe adalah memberikan informasi peringatan dini banjir secara sederhana, cepat, dan mudah dipahami oleh pengguna, khususnya untuk wilayah Bandar Lampung.

---

## 🏫 Informasi Project

Project ini dibuat untuk memenuhi tugas mata kuliah **Pemrograman Mobile**.

**Nama Aplikasi:** BalamSafe
**Topik:** Aplikasi Peringatan Dini Banjir Bandar Lampung
**Platform:** Mobile App
**Framework:** Flutter

---

## 📄 Lisensi

Project ini dibuat untuk kebutuhan pembelajaran dan pengembangan aplikasi mobile.
