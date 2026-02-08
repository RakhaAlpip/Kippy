# 🐸 Kippy (Keep Happy)

**Kippy** adalah aplikasi *mobile photo sharing* yang bertujuan untuk menyebarkan kebahagiaan melalui foto dan meme lucu. Terinspirasi dari platform komunitas seperti Lahelu, Kippy dibangun sebagai *Final Project Checkpoint 1* bootcamp Dibimbing.id.

Aplikasi ini dikembangkan menggunakan **Flutter** dengan penerapan **Clean Architecture** dan **BLoC State Management** untuk memastikan performa yang solid dan kode yang mudah dikelola.

## 📱 Fitur Utama (Features)

Sesuai dengan spesifikasi *Photo Sharing API*, Kippy memiliki fitur lengkap:

* **🔐 Authentication:** Login & Register pengguna baru.
* **🏠 Feed Timeline:** Melihat postingan foto/meme terbaru dari pengguna lain.
* **📸 Upload:** Membagikan momen atau meme lucu (Post) dan cerita sesaat (Story).
* **❤️ Interaction:** Memberikan *Like* dan melihat komentar.
* **👥 Social:** Fitur *Follow* dan *Following* antar pengguna.
* **👤 User Profile:** Kustomisasi profil dan galeri postingan pribadi.
* **💾 Local Storage:** Penyimpanan sesi login otomatis.

## 🛠️ Tech Stack & Tools

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **State Management:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc)
* **Architecture:** Clean Architecture (Domain, Data, Presentation Layer)
* **Networking:** [Dio](https://pub.dev/packages/dio) (dengan Interceptors)
* **Local Storage:** [Shared Preferences](https://pub.dev/packages/shared_preferences)
* **UI/UX:** Custom Widgets, Animations, Google Fonts.

## 📂 Struktur Proyek (Clean Architecture)

Kippy memisahkan logic bisnis dan UI secara tegas agar mudah di-maintain:

```text
lib/
├── core/               # Konfigurasi dasar, error handling, utils, constants
├── data/               # Layer Data
│   ├── datasources/    # Remote (API) & Local (SharedPref) data sources
│   ├── models/         # Model data (JSON parsing)
│   └── repositories/   # Implementasi repository
├── domain/             # Layer Bisnis (Murni dart, tanpa flutter UI)
│   ├── entities/       # Objek bisnis utama
│   ├── repositories/   # Interface repository (kontrak)
│   └── usecases/       # Logika bisnis per fitur
├── presentation/       # Layer UI
│   ├── bloc/           # State Management (LoginBloc, FeedBloc, dll)
│   ├── pages/          # Halaman Screen (Login, Home, Profile, Upload)
│   └── widgets/        # Widget reusable (Button, Input, Card)
└── main.dart           # Entry point

## 🚀 Cara Menjalankan (Installation)

1.  **Clone repository ini:**
    ```bash
    git clone git@github.com:RakhaAlpip/Kippy.git
    ```

2.  **Masuk ke direktori project:**
    ```bash
    cd Kippy
    ```

3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

4.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

## 📸 Screenshots

| Login Screen | Home Feed | Upload Meme | Profile |
|:---:|:---:|:---:|:---:|
| *(Coming Soon)* | *(Coming Soon)* | *(Coming Soon)* | *(Coming Soon)* |

## 📝 Credits

Dibuat oleh **Rakha Alghifary** untuk Final Project Bootcamp Dibimbing.id.
API disediakan oleh Tim Dibimbing.

---
*Keep Happy with Kippy!* 🐸✨

## 🚧 Development Roadmap

Status pengerjaan fitur aplikasi Kippy:

- [x] **Project Setup** (Flutter init, Folder Structure, Dependencies)
- [ ] **Authentication**
  - [ ] Login Page UI & Integration
  - [ ] Register Page UI & Integration
  - [ ] Logout Logic
- [ ] **Home Feed**
  - [ ] Menampilkan List Foto (API GET Posts)
  - [ ] Menampilkan Story (API GET Stories)
- [ ] **Post Interaction**
  - [ ] Like Feature
  - [ ] Comment UI
- [ ] **Create Content**
  - [ ] Image Picker (Camera/Gallery)
  - [ ] Upload Post (API POST)
- [ ] **User Profile**
  - [ ] Get User Detail
  - [ ] Show User Posts
- [ ] **Optimization**
  - [ ] Local Storage (Auto Login)
  - [ ] Animations (Hero, Loading Shimmer)
