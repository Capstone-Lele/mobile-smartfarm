# Alur Fitur Aplikasi Budidaya Lele Mobile

Dokumen ini menjelaskan alur lengkap setiap fitur pada aplikasi Budidaya Lele Mobile. Digunakan sebagai referensi untuk pembuatan activity diagram.

---

## Daftar Fitur

1. [Autentikasi (Login & Logout)](#1-autentikasi-login--logout)
2. [Splash Screen & Routing Awal](#2-splash-screen--routing-awal)
3. [Dashboard & Data IoT](#3-dashboard--data-iot)
4. [Manajemen Kolam](#4-manajemen-kolam)
5. [Profil Pengguna](#5-profil-pengguna)
6. [Ganti Password](#6-ganti-password)
7. [Jadwal (Cleaning, Feeding, Sampling)](#7-jadwal-cleaning-feeding-sampling)
8. [Laporan Kematian Ikan](#8-laporan-kematian-ikan)
9. [Laporan Benih](#9-laporan-benih)
10. [Laporan Vitamin](#10-laporan-vitamin)
11. [Laporan Pakan](#11-laporan-pakan)
12. [Laporan Pembersihan Kolam](#12-laporan-pembersihan-kolam)
13. [Laporan Sampling](#13-laporan-sampling)
14. [Laporan Panen](#14-laporan-panen)
15. [Laporan Pindah Kolam](#15-laporan-pindah-kolam)
16. [Laporan Ikan Sakit](#16-laporan-ikan-sakit)
17. [Inventori & Transaksi](#17-inventori--transaksi)
18. [Notifikasi](#18-notifikasi)
19. [Parameter & Status Perangkat](#19-parameter--status-perangkat)
20. [Halaman Laporan (Report Hub)](#20-halaman-laporan-report-hub)

---

## Struktur Navigasi Bawah (Bottom Navigation)

| Tab | Halaman | Deskripsi |
|-----|---------|-----------|
| 0 | `/dashboard` | Dashboard utama + ringkasan kolam |
| 1 | `/pool` | Daftar semua kolam |
| 2 | `/schedule` | Manajemen jadwal |
| 3 | `/report` | Hub laporan semua jenis |
| 4 | Settings | Profil pengguna & pengaturan |

---

## 1. Autentikasi (Login & Logout)

### Login

**Trigger:** Pengguna belum login / token tidak valid

**Langkah-langkah:**
1. Pengguna membuka halaman Login (`/login`)
2. Pengguna memasukkan **Email** dan **Password**
3. Sistem memvalidasi input:
   - Email: wajib diisi, harus mengandung "@"
   - Password: wajib diisi
4. Jika validasi gagal → tampilkan pesan error di form
5. Jika validasi berhasil → kirim request ke API
6. **[API]** `POST /auth/login` dengan body `{ email, password }`
7. **Jika login berhasil:**
   - Simpan token ke `SharedPreferences` via `AppSession`
   - Load informasi pengguna (`GET /app/user-info`)
   - Daftarkan token FCM ke server (`POST /auth/device/register`)
   - Navigasi ke halaman `/dashboard`
8. **Jika login gagal:**
   - Tampilkan snackbar error dengan pesan dari server
   - Pengguna tetap di halaman login

### Logout

**Trigger:** Pengguna menekan tombol logout ATAU token 401 dari server

**Langkah-langkah:**
1. Sistem memanggil `POST /auth/device/unregister` (hapus token FCM)
2. Hapus token dari `SharedPreferences`
3. Navigasi ke halaman `/login`

**API yang digunakan:**

| Aksi | Method | Endpoint | Body |
|------|--------|----------|------|
| Login | POST | `/auth/login` | email, password |
| Register FCM | POST | `/auth/device/register` | fcmToken, deviceName, deviceType |
| Unregister FCM | POST | `/auth/device/unregister` | fcmToken |
| Info pengguna | GET | `/app/user-info` | - |

---

## 2. Splash Screen & Routing Awal

**Trigger:** Aplikasi pertama kali dibuka

**Langkah-langkah:**
1. Splash screen tampil selama ±2 detik
2. Sistem memeriksa token di `SharedPreferences`
3. Jika token ada → Load info pengguna (`GET /app/user-info`)
   - Berhasil → Navigasi ke `/dashboard`
   - Gagal (token expired/invalid) → Navigasi ke `/login`
4. Jika token tidak ada → Navigasi ke `/login`

---

## 3. Dashboard & Data IoT

**Trigger:** Login berhasil atau tap Tab 0 pada bottom navigation

**Langkah-langkah:**
1. Halaman Dashboard (`/dashboard`) dibuka
2. Sistem memuat daftar kolam (`GET /pool`)
3. Pengguna disambut dengan nama dan peran (role)
4. Pengguna memilih kolam dari **dropdown**
5. Sistem memuat data IoT untuk kolam yang dipilih (`GET /iot/pool/{nodeId}`)
6. Data IoT ditampilkan:
   - Jumlah ikan di kolam
   - Nilai pH air
   - Status feeder (aktif/tidak)
   - Suhu air
   - Badge status: **Aman** / **Peringatan** / **Bahaya**
7. **Polling otomatis:** Data IoT diperbarui setiap **60 detik**
8. Pengguna dapat **pull-to-refresh** untuk memperbarui data

**Logika status:**
- Suhu dan pH dibandingkan dengan threshold min/normal/max dari konfigurasi kolam
- Status **Aman**: suhu dan pH dalam batas normal
- Status **Peringatan**: salah satu di luar batas normal
- Status **Bahaya**: salah satu mencapai batas kritis

**Navigasi dari Dashboard:**
- Ketuk "Lihat Semua Kolam" → `/pool`
- Ketuk "Lihat Semua Data Iot" → `/pool-condition`
- Ketuk ikon notifikasi → `/notification`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar kolam | GET | `/pool` |
| Data IoT kolam | GET | `/iot/pool/{nodeId}` |
| Chart IoT | GET | `/iot/chart/{nodeId}?start_date={}&end_date={}` |

---

## 4. Manajemen Kolam

**Trigger:** Tap Tab 1 bottom navigation atau "Lihat Semua Kolam" dari dashboard

**Langkah-langkah:**
1. Halaman daftar kolam (`/pool`) dibuka
2. Sistem memuat semua kolam (`GET /pool`)
3. Jika role PIC: tampilkan ringkasan kolam (Pembenihan / Pembesaran / Karantina)
4. Pengguna dapat mencari kolam via **search bar** (filter nama, tidak sensitif huruf besar/kecil)
5. Setiap item kolam menampilkan:
   - Nama kolam
   - Badge kategori: **Pembenihan** (kuning) / **Pembesaran** (hijau) / **Karantina** (merah)
   - Jumlah ikan saat ini
6. Ketuk kolam → Navigasi ke `/move-pool-report/create` (membuat laporan pindah kolam untuk kolam tersebut)

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar kolam | GET | `/pool` |
| Detail kolam | GET | `/pool/{poolId}?inventoryType=all` |

---

## 5. Profil Pengguna

**Trigger:** Tap Tab 4 (Settings) → Pilih ganti profil

**Langkah-langkah:**
1. Halaman ganti profil (`/change-profile`) dibuka
2. Form menampilkan data profil saat ini (nama)
3. Pengguna mengubah **nama**
4. Opsional: Pengguna memilih **foto profil** baru dari kamera atau galeri
5. Sistem memvalidasi: nama wajib diisi
6. Pengguna menekan tombol simpan
7. **[API]** `PUT /app/user` dengan multipart: `name`, `image` (opsional)
8. **Jika berhasil:**
   - Tampilkan snackbar sukses
   - Data pengguna diperbarui secara global
9. **Jika gagal:**
   - Tampilkan snackbar error

**API yang digunakan:**

| Aksi | Method | Endpoint | Body |
|------|--------|----------|------|
| Ganti profil | PUT (Multipart) | `/app/user` | name, image |

---

## 6. Ganti Password

**Trigger:** Tap Tab 4 (Settings) → Pilih ganti password

**Langkah-langkah:**
1. Halaman ganti password (`/change-password`) dibuka
2. Pengguna memasukkan:
   - Password lama
   - Password baru
   - Konfirmasi password baru
3. Sistem memvalidasi:
   - Semua field wajib diisi
   - Password baru harus sama dengan konfirmasi password
4. Jika validasi gagal → tampilkan pesan error
5. Pengguna menekan tombol simpan
6. **[API]** `PUT /app/change-password` dengan multipart: `oldPassword`, `newPassword`
7. **Jika berhasil:** tampilkan snackbar sukses
8. **Jika gagal:** tampilkan snackbar error (misal: password lama salah)

**API yang digunakan:**

| Aksi | Method | Endpoint | Body |
|------|--------|----------|------|
| Ganti password | PUT (Multipart) | `/app/change-password` | oldPassword, newPassword |

---

## 7. Jadwal (Cleaning, Feeding, Sampling)

**Trigger:** Tap Tab 2 bottom navigation

### Melihat Jadwal

1. Halaman jadwal (`/schedule`) dibuka
2. Sistem memuat ketiga jenis jadwal sekaligus
3. Tiga tab tersedia:
   - Tab 0: **Jadwal Pembersihan**
   - Tab 1: **Jadwal Pemberian Pakan**
   - Tab 2: **Jadwal Sampling**
4. Jika role PIC: tampilkan ringkasan kartu per jenis jadwal
5. Opsional: Pengguna memfilter berdasarkan rentang tanggal
6. Pull-to-refresh memperbarui data tab aktif

### Membuat Jadwal Baru

1. Pengguna menekan tombol tambah → Navigasi ke `/schedule/create`
2. Pengguna memilih **jenis jadwal** (Cleaning / Feeding / Sampling)
3. Sistem memuat dropdown kolam
4. Pengguna memilih **kolam** → sistem memuat opsi autofill (pilihan penanggung jawab)
5. Pengguna mengisi:
   - Kolam (dropdown, wajib)
   - Penanggung jawab/AutoFill (dropdown, wajib)
   - Tanggal jadwal (date picker, wajib)
6. Pengguna menekan simpan
7. **[API]** `POST /schedule/{type}` dengan body: `poolId`, `userId`, `scheduleDate`
8. **Jika berhasil:** snackbar sukses, kembali ke daftar jadwal
9. **Jika gagal:** snackbar error

### Melihat Detail Jadwal

1. Pengguna mengetuk item jadwal → Navigasi ke `/schedule/detail` (parameter: `scheduleId`, `scheduleType`)
2. Detail jadwal ditampilkan
3. Tersedia aksi: **Edit** atau **Hapus**

### Mengubah Jadwal

1. Dari detail → tekan Edit → Navigasi ke `/schedule/update`
2. Form terisi otomatis dengan data yang ada
3. Pengguna mengubah data
4. **[API]** `PUT /schedule/{type}/{id}`

### Menghapus Jadwal

1. Dari detail → tekan Hapus
2. Konfirmasi penghapusan
3. **[API]** `DELETE /schedule/{type}/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar jadwal | GET | `/schedule/{type}` |
| Detail jadwal | GET | `/schedule/{type}/{id}` |
| Buat jadwal | POST | `/schedule/{type}` |
| Ubah jadwal | PUT | `/schedule/{type}/{id}` |
| Hapus jadwal | DELETE | `/schedule/{type}/{id}` |

> `{type}` = `cleaning` / `feeding` / `sampling`

---

## 8. Laporan Kematian Ikan

**Trigger:** Report Hub → Pilih kolam → "Laporan Kematian"

### Melihat Daftar Laporan

1. Halaman `/mortality-report` dibuka (parameter: `cycleId`, `poolId`, `poolName`)
2. Sistem memuat daftar laporan (`GET /note/mortality?poolId={poolId}`)
3. Daftar laporan ditampilkan dengan tanggal dan jumlah ikan mati

### Membuat Laporan

1. Pengguna menekan tombol tambah → Navigasi ke `/mortality-report/create`
2. Pengguna mengisi:
   - Tanggal laporan (date picker, wajib)
   - Jumlah ikan mati (angka, wajib)
   - Catatan (opsional)
   - Foto (wajib, dari kamera/galeri)
3. Pengguna menekan simpan
4. **[API]** `POST /note/mortality` (Multipart): `cycleId`, `userId`, `reportDate`, `quantity`, `notes`, `image`
5. **Jika berhasil:** snackbar sukses, kembali ke daftar
6. **Jika gagal:** snackbar error

### Mengubah Laporan

1. Pengguna membuka detail → tekan Edit → `/mortality-report/update`
2. Form terisi dengan data yang ada (foto bersifat opsional saat update)
3. **[API]** `PUT /note/mortality/{id}` (Multipart)

### Menghapus Laporan

1. **[API]** `DELETE /note/mortality/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/mortality?poolId={poolId}` |
| Detail | GET | `/note/mortality/{id}` |
| Buat | POST (Multipart) | `/note/mortality` |
| Ubah | PUT (Multipart) | `/note/mortality/{id}` |
| Hapus | DELETE | `/note/mortality/{id}` |

---

## 9. Laporan Benih

**Trigger:** Report Hub → Pilih kolam → "Laporan Benih"

### Membuat Laporan

1. Navigasi ke `/seed-report/create` (parameter: `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Jumlah benih awal (wajib)
   - Jumlah benih saat ini (wajib)
   - Berat rata-rata awal (wajib)
   - Foto (wajib)
3. **Logika peringatan overload:**
   - Sistem menghitung kapasitas kolam: `π × diameter² × 0.25 × 250`
   - Jika jumlah benih > kapasitas → tampilkan dialog konfirmasi
   - Pengguna dapat **Lanjutkan** atau **Batal**
4. **[API]** `POST /note/seed` (Multipart)
5. **Jika berhasil:** snackbar sukses, kembali ke daftar

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/seed?poolId={poolId}` |
| Detail | GET | `/note/seed/{id}` |
| Buat | POST (Multipart) | `/note/seed` |

---

## 10. Laporan Vitamin

**Trigger:** Report Hub → Pilih kolam → "Laporan Vitamin"

### Membuat Laporan

1. Navigasi ke `/vitamin-report/create` (parameter: `cycleId`, `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Inventori/vitamin (dropdown, wajib)
   - Jumlah (wajib)
   - Foto (wajib)
3. **[API]** `POST /note/vitamin` (Multipart): `cycleId`, `inventoryId`, `reportDate`, `quantity`, `image`
4. **Jika berhasil:** snackbar sukses, kembali ke daftar

### Mengubah Laporan

1. **[API]** `PUT /note/vitamin/{id}` (Multipart): foto bersifat opsional

### Menghapus Laporan

1. **[API]** `DELETE /note/vitamin/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/vitamin?poolId={poolId}` |
| Detail | GET | `/note/vitamin/{id}` |
| Buat | POST (Multipart) | `/note/vitamin` |
| Ubah | PUT (Multipart) | `/note/vitamin/{id}` |
| Hapus | DELETE | `/note/vitamin/{id}` |

---

## 11. Laporan Pakan

**Trigger:** Report Hub → Pilih kolam → "Laporan Pakan"

### Membuat Laporan

1. Navigasi ke `/feed-report/create` (parameter: `cycleId`, `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Inventori/pakan (dropdown, wajib)
   - Jumlah (wajib)
   - Foto (wajib)
3. **[API]** `POST /note/feed` (Multipart): `cycleId`, `inventoryId`, `reportDate`, `quantity`, `image`
4. **Jika berhasil:** snackbar sukses, kembali ke daftar

### Mengubah Laporan

1. **[API]** `PUT /note/feed/{id}` (Multipart): foto bersifat opsional

### Menghapus Laporan

1. **[API]** `DELETE /note/feed/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/feed?poolId={poolId}` |
| Detail | GET | `/note/feed/{id}` |
| Buat | POST (Multipart) | `/note/feed` |
| Ubah | PUT (Multipart) | `/note/feed/{id}` |
| Hapus | DELETE | `/note/feed/{id}` |

---

## 12. Laporan Pembersihan Kolam

**Trigger:** Report Hub → Pilih kolam → "Laporan Pembersihan Kolam"

### Membuat Laporan

1. Navigasi ke `/pool-cleaning-report/create` (parameter: `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Foto (wajib)
3. **[API]** `POST /note/cleaning` (Multipart): `poolId`, `reportDate`, `image`
4. **Jika berhasil:** snackbar sukses, kembali ke daftar

### Mengubah Laporan

1. **[API]** `PUT /note/cleaning/{id}` (Multipart): foto bersifat opsional

### Menghapus Laporan

1. **[API]** `DELETE /note/cleaning/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/cleanings?poolId={poolId}` |
| Detail | GET | `/note/cleaning/{id}` |
| Buat | POST (Multipart) | `/note/cleaning` |
| Ubah | PUT (Multipart) | `/note/cleaning/{id}` |
| Hapus | DELETE | `/note/cleaning/{id}` |

---

## 13. Laporan Sampling

**Trigger:** Report Hub → Pilih kolam → "Laporan Sampling"

### Membuat Laporan

1. Navigasi ke `/sampling-report/create` (parameter: `cycleId`, `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Jumlah ikan yang disampling (wajib)
   - Berat rata-rata (wajib)
   - Foto (wajib)
3. **[API]** `POST /note/sampling` (Multipart): `cycleId`, `reportDate`, `quantity`, `averageWeight`, `image`
4. **Jika berhasil:** snackbar sukses, kembali ke daftar

### Mengubah Laporan

1. **[API]** `PUT /note/sampling/{id}` (Multipart): foto bersifat opsional

### Menghapus Laporan

1. **[API]** `DELETE /note/sampling/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/samplings?poolId={poolId}` |
| Detail | GET | `/note/sampling/{id}` |
| Buat | POST (Multipart) | `/note/sampling` |
| Ubah | PUT (Multipart) | `/note/sampling/{id}` |
| Hapus | DELETE | `/note/sampling/{id}` |

---

## 14. Laporan Panen

**Trigger:** Report Hub → Pilih kolam → "Laporan Panen"

### Membuat Laporan

1. Navigasi ke `/harvest-report/create` (parameter: `cycleId`, `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Total berat panen (kg, wajib)
   - Jumlah ikan dipanen (wajib, auto-isi dengan jumlah ikan saat ini)
   - Foto (wajib)
3. **Logika akhir siklus:**
   - Jika jumlah dipanen == jumlah ikan saat ini → `endedAt` = waktu sekarang (siklus selesai)
   - Jika jumlah dipanen < jumlah saat ini → `endedAt` = null (panen parsial, siklus berlanjut)
4. **[API]** `POST /note/harvest` (Multipart): `cycleId`, `reportDate`, `totalKg`, `amount`, `image`, `endedAt` (opsional)
5. **Jika berhasil:** snackbar sukses, kembali ke daftar

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/harvest?poolId={poolId}` |
| Detail | GET | `/note/harvest/{id}` |
| Buat | POST (Multipart) | `/note/harvest` |

---

## 15. Laporan Pindah Kolam

**Trigger:** Tap kolam dari daftar kolam ATAU Report Hub → "Laporan Pindah Kolam"

### Membuat Laporan

1. Navigasi ke `/move-pool-report/create` (parameter: `cycleId`, `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Jumlah ikan yang dipindah (wajib)
   - Foto (wajib)
3. **[API]** `POST /note/move-pool` (Multipart): `poolId`, `originCycleId`, `reportDate`, `quantity`, `image`, `endedAt` (opsional)
4. **Jika berhasil:** snackbar sukses, kembali ke daftar

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/move-pool?poolId={poolId}` |
| Detail | GET | `/note/move-pool/{id}` |
| Buat | POST (Multipart) | `/note/move-pool` |

---

## 16. Laporan Ikan Sakit

**Trigger:** Report Hub → Pilih kolam → "Laporan Ikan Sakit"

### Membuat Laporan

1. Navigasi ke `/sick-report/create` (parameter: `poolId`, `poolName`)
2. Pengguna mengisi:
   - Tanggal laporan (wajib)
   - Jumlah ikan sakit (wajib)
   - Foto (wajib)
3. **[API]** `POST /note/sick` (Multipart): `poolId`, `originCycleId`, `reportDate`, `quantity`, `image`
4. **Jika berhasil:** snackbar sukses, kembali ke daftar

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar | GET | `/note/sick?poolId={poolId}` |
| Detail | GET | `/note/sick/{id}` |
| Buat | POST (Multipart) | `/note/sick` |

---

## 17. Inventori & Transaksi

**Trigger:** Tap Tab 4 (Settings) → Inventori ATAU aksi dari laporan yang membutuhkan inventori

### Melihat Daftar Inventori

1. Sistem memuat daftar inventori (`GET /inventory`)
2. Setiap item menampilkan nama dan stok

### Melihat Detail Inventori

1. Ketuk item → Navigasi ke `/inventory/detail` (parameter: `inventoryId`)
2. **[API]** `GET /inventory/{id}?inventoryType=all`
3. Ditampilkan: informasi inventori beserta seluruh riwayat transaksi

### Daftar Submission / Transaksi

1. Navigasi ke `/inventory/submissions`
2. **[API]** `GET /inventory/submissions`
3. Daftar semua transaksi inventori ditampilkan

### Membuat Submission Baru

1. Navigasi ke `/inventory/create-submission`
2. Pengguna mengisi:
   - Inventori (dropdown, wajib)
   - Jumlah (wajib)
   - Jenis transaksi (wajib, contoh: "non-grant")
   - Catatan (opsional)
3. **[API]** `POST /inventory/submission` (Multipart)
4. **Jika berhasil:** snackbar sukses

### Mengubah Submission

1. Navigasi ke `/inventory/update-submission` (parameter: `inventorySubmissionId`)
2. Form terisi dengan data yang ada
3. **[API]** `PUT /inventory/submission/{id}`

### Menghapus Submission

1. **[API]** `DELETE /inventory/submission/{id}`

### Membuat Laporan Inventori

1. Navigasi ke `/inventory/create-report`
2. Pengguna mengisi:
   - Inventori (dropdown, wajib)
   - Tanggal laporan (wajib)
   - Jumlah (wajib)
   - Foto (wajib)
   - Catatan (opsional)
3. **[API]** `POST /note/inventory` (Multipart)

### Melihat Detail Laporan Inventori

1. Navigasi ke `/inventory/report-detail` (parameter: `reportId`)
2. **[API]** `GET /note/inventory/{id}`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar inventori | GET | `/inventory` |
| Detail inventori | GET | `/inventory/{id}?inventoryType=all` |
| Daftar submission | GET | `/inventory/submissions` |
| Detail submission | GET | `/inventory/submission/{id}` |
| Buat submission | POST (Multipart) | `/inventory/submission` |
| Ubah submission | PUT | `/inventory/submission/{id}` |
| Hapus submission | DELETE | `/inventory/submission/{id}` |
| Daftar laporan | GET | `/note/inventories` |
| Detail laporan | GET | `/note/inventory/{id}` |
| Buat laporan | POST (Multipart) | `/note/inventory` |

---

## 18. Notifikasi

**Trigger:** Tap ikon notifikasi (lonceng) di header Dashboard

**Langkah-langkah:**
1. Navigasi ke halaman notifikasi (`/notification`)
2. Sistem memuat semua notifikasi (`GET /notification`)
3. Daftar notifikasi ditampilkan
4. **Tandai satu notifikasi sebagai sudah dibaca:**
   - Otomatis saat notifikasi dilihat
   - **[API]** `PUT /notification/{id}` (Multipart): `readedAt` = waktu sekarang
5. **Tandai semua sebagai sudah dibaca:**
   - Pengguna menekan tombol "Tandai Semua"
   - **[API]** `PUT /notification` (Multipart): `readedAt` = waktu sekarang

**Push Notification (Firebase):**
- FCM token didaftarkan saat login
- Notifikasi masuk tampil sebagai push notification di perangkat
- Notifikasi lokal ditampilkan via `flutter_local_notifications`

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Daftar notifikasi | GET | `/notification` |
| Detail notifikasi | GET | `/notification/{id}` |
| Tandai satu dibaca | PUT (Multipart) | `/notification/{id}` |
| Tandai semua dibaca | PUT (Multipart) | `/notification` |

---

## 19. Parameter & Status Perangkat

**Trigger:** Halaman Settings → Parameter

### Mengubah Parameter

1. Navigasi ke halaman parameter (`/parameter`)
2. Pengguna (Admin/PIC) dapat melihat dan mengubah threshold:
   - **Suhu:** Max, Normal, Min
   - **pH (Keasaman):** Max, Normal, Min
3. Bisa diatur secara **global** atau per **kolam tertentu**
4. **[API] Update global:** `PUT /pool/limit` (Multipart)
5. **[API] Update per kolam:** `PUT /pool/limit/{poolId}` (Multipart)
6. **Jika berhasil:** parameter tersimpan, mempengaruhi logika status di dashboard

### Status Perangkat

1. Navigasi ke `/status-device`
2. Menampilkan status koneksi perangkat IoT yang terpasang

**API yang digunakan:**

| Aksi | Method | Endpoint | Body |
|------|--------|----------|------|
| Update parameter global | PUT (Multipart) | `/pool/limit` | temperatureMax[], temperatureNormal[], temperatureMin[], acidityMax[], acidityNormal[], acidityMin[] |
| Update parameter kolam | PUT (Multipart) | `/pool/limit/{poolId}` | temperatureMax[], temperatureNormal[], temperatureMin[], acidityMax[], acidityNormal[], acidityMin[] |

---

## 20. Halaman Laporan (Report Hub)

**Trigger:** Tap Tab 3 bottom navigation

**Langkah-langkah:**
1. Halaman report (`/report`) dibuka
2. Pengguna memilih kolam dari dropdown
3. Sistem memuat:
   - Log aktivitas terbaru (`GET /app/activity-logs`)
   - Total laporan bulan ini (`GET /app/total-notes?month={month}`)
   - Total laporan per kolam (`GET /app/total-note/{poolId}?month={month}`) — khusus PIC
4. Ditampilkan:
   - **Tombol aksi cepat** (khusus Staff): Buat laporan Kematian, Benih, Vitamin, Pakan, Pembersihan, Sampling, Panen, Pindah Kolam, Ikan Sakit
   - **Statistik bulanan** (khusus PIC): Ringkasan jumlah laporan per jenis
   - **Log aktivitas**: Riwayat semua pembuatan laporan
5. Ketuk tombol aksi → Navigasi ke halaman buat laporan yang sesuai (membawa `cycleId`, `poolId`, `poolName`)

**API yang digunakan:**

| Aksi | Method | Endpoint |
|------|--------|----------|
| Log aktivitas | GET | `/app/activity-logs` |
| Total laporan | GET | `/app/total-notes?month={month}` |
| Total laporan per kolam | GET | `/app/total-note/{poolId}?month={month}` |

---

## Pola Error Handling Umum

Semua fitur menggunakan pola yang sama untuk menangani error:

1. API call gagal → `Either<Failure, Data>` mengembalikan `Left(Failure)`
2. Provider menangkap failure → state berubah ke `AsyncValue.error`
3. UI menampilkan **snackbar merah** dengan pesan error dari server
4. Token 401 → sistem otomatis logout (di `safeRequest()` pada `AppHttpClient`)
5. Pengguna dapat mencoba lagi via pull-to-refresh atau tekan ulang tombol aksi

## Format Tanggal

| Konteks | Format |
|---------|--------|
| Tampilan ke pengguna | `dd-MM-yyyy` |
| Tampilan dengan waktu | `dd-MM-yyyy HH:mm` |
| Dikirim ke API | ISO 8601 (via `AppFormat.toApiDateTime`) |
| Locale | `id_ID` (Indonesia) |
