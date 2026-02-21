# Kalpa Yatra - Spiritual & Heritage Travel Portal

Kalpa Yatra is a premium travel platform designed for organizing and showcasing spiritual and heritage journeys, specifically tailored for ancient destinations like Varanasi. It features a public-facing portal for travelers and a robust admin dashboard for agencies.

## 🚀 Live Demo
**Public Portal:** [https://kalpa-yatra.web.app](https://kalpa-yatra.web.app)

---

## ✨ Features

### Public Portal
- **Service Catalog**: Explore spiritual services (Boat rides, Temple Darshans, Heritage walks) with detailed descriptions and pricing.
- **Interactive Itineraries**: Multi-day spiritual journey timelines with custom steps.
- **Quick Inquiry**: Direct integration for lead generation with WhatsApp and form support.
- **Adaptive Branding**: Dynamic theme colors and logos based on tenant configuration.

### Admin Dashboard
- **Analytics Overview**: Quick view of active leads and service stats.
- **Lead Tracker**: Manage customer inquiries and track booking statuses.
- **Service Management**: Full CRUD support for travel services.
- **Itinerary Management**: Customizable multi-step itineraries for signature experiences.
- **Tenant Settings**: Control branding colors, logos, and contact information without code changes.

---

## 🛠️ Tech Stack
- **Frontend**: Flutter (3.x) - High performance, single-codebase web application.
- **State Management**: Riverpod - For scalable and testable state control.
- **Backend/Database**: Cloud Firestore - Real-time NoSQL database.
- **Authentication**: Firebase Auth - Secure admin login.
- **Hosting**: Firebase Hosting - Global CDN deployment.
- **Design**: Google Fonts (Poppins & Inter), Material Design 3.

---

## 📦 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Firebase CLI](https://firebase.google.com/docs/cli)
- Node.js (for seeding scripts)

### Installation
1.  **Clone the repo:**
    ```bash
    git clone https://github.com/rahulguptacsedev/kalpa-yatra.git
    cd kalpa-yatra
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Configure Firebase:**
    Generate your own `firebase_options.dart` using:
    ```bash
    flutterfire configure
    ```
4.  **Run Locally:**
    ```bash
    flutter run -d chrome
    ```

---

## 📜 License
This project is licensed under the MIT License.
