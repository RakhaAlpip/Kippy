# 🐸 Kippy (Keep Happy) - Photo Sharing App

[![Video Demo](https://img.shields.io/badge/YouTube-Watch_Demo-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtu.be/pJ1bkkJKyr8)

**Kippy** adalah aplikasi *mobile photo sharing* yang ceria dan berbasis komunitas, bertujuan untuk menyebarkan kebahagiaan melalui foto dan foto lucu. Dibangun sebagai **Final Project Bootcamp Mobile Apps Dibimbing.id**, Kippy mengedepankan performa yang solid dengan antarmuka yang modern dan interaktif.

Aplikasi ini dikembangkan menggunakan **Flutter** dengan penerapan **Clean Architecture** (Feature-First) dan **BLoC State Management** untuk memastikan kode yang mudah dikelola, diuji, dan diskalakan.

---

## 🎥 Video Demo & Simulasi
Penasaran bagaimana Kippy bekerja? Lihat video simulasi penggunaan aplikasinya di sini:
👉 **[Tonton Demo Kippy di YouTube](https://youtu.be/pJ1bkkJKyr8)**

---

## 🚀 Fitur Utama (Core Features)

Sesuai dengan spesifikasi *Photo Sharing API* & objektif tugas:

* **🔐 Authentication:** Login & Register pengguna baru secara aman.
* **🏠 Dynamic Feed:** *Infinite scrolling* (Lazy Loading) untuk melihat postingan foto/meme terbaru dari pengguna lain di beranda.
* **🔍 Explore & Search:** Halaman *grid view* untuk menemukan konten baru dan inspirasi.
* **📸 Post & Story Creation:** Bagikan momen atau meme lucu dengan *caption* menarik.
* **❤️ Social Interactions:** Berikan *Like*, hapus *Like*, dan berikan komentar pada postingan favoritmu dengan animasi yang *smooth*.
* **👻 Robust Data Handling:** Custom "Ghost" placeholders untuk link gambar yang rusak/mati (404 resilience), memastikan tampilan aplikasi tetap premium.
* **👥 Connect:** Fitur *Follow* dan *Unfollow* antar pengguna.
* **👤 Profile Management:** Kustomisasi detail profil dan lihat galeri foto pribadimu.
* **💾 Offline Bookmark (Local Storage):** Simpan sesi *login* secara otomatis sehingga tidak perlu *login* berulang kali.

---

## 🛠️ Tech Stack & Tools

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** `flutter_bloc`, `equatable`
* **Architecture:** Clean Architecture (Domain, Data, Presentation Layer)
* **Dependency Injection:** `get_it`
* **Networking & API:** `dio` (dengan *Custom Interceptors*)
* **Local Storage:** `shared_preferences`, `hive`
* **Backend Services:** REST API Dibimbing (Utama) & Firebase (FCM/Crashlytics/Auth)
* **UI/UX & Assets:** `cached_network_image`, `lottie` (untuk animasi kodok 🐸), `Google Fonts`.

---

## 🎨 Design & UI/UX

Kippy menggunakan tema warna yang *fresh*, ceria, dan modern:
* 🤍 **Background:** *Broken White* (`#F5F5F0`) dan *Card White* (`#FAFAF8`) agar konten foto/meme lebih menonjol.
* 💚 **Accent/Primary:** *Lime Green* (`#8DEE10`), memberikan nuansa energik, ramah, dan khas "Kippy" si Kodok.
* ✨ **Interactions:** Dilengkapi dengan transisi *swipe* yang mulus, *bottom-sheet UI* untuk komentar, dan *shimmer loading effect*.

---

## 📂 Struktur Proyek (Clean Architecture)

Proyek ini dipisahkan berdasarkan fitur (*feature-driven*) dengan lapisan *Clean Architecture* di dalamnya:

```text
lib/
├── config/             # App routing dan tema global
├── core/               # Shared utilities, error handling, network base (Dio)
├── features/           # Modul fitur aplikasi
│   ├── auth/           # Login & Register (Domain, Data, Presentation)
│   ├── explore/        # Halaman Explore & pencarian
│   ├── home/           # Feed utama dan Stories
│   ├── profile/        # Manajemen profil pengguna
│   └── social/         # Interaksi (Like, Comment, Follow)
└── main.dart           # App entry point
```

## ⚙️ Cara Menjalankan (Getting Started)

### Prasyarat (Prerequisites)

* Flutter SDK (>=3.9.0)
* Dart SDK

### Instalasi (Installation)

1. **Clone repository ini:**
```bash
git clone git@github.com:RakhaAlpip/Kippy.git
cd Kippy
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate files (Jika diperlukan untuk Model/JSON):**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Jalankan aplikasi:**
```bash
flutter run
```

---

## 📸 Screenshots

| Login Screen | Home Feed | Explore Page | Profile |
| --- | --- | --- | --- |
| *<img src=assets/Screenshot/login.png>* | *<img src=assets/Screenshot/home.png>* | *<img src=assets/Screenshot/explore.png>* | *<img src=assets/Screenshot/profile.png>* |


---

## 📝 Credits

Dibuat dengan ❤️ dan ☕ oleh **Rakha Alghifary** untuk Final Project Bootcamp Dibimbing.id.
API Backend disediakan oleh Tim Dibimbing.

*Keep Happy with Kippy!* 🐸✨

