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

Kippy memisahkan logic bisnis dan UI secara tegas:
