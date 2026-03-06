# LoopOut
A new Flutter project.
**Discover. Join. Loop In.**
## Getting Started
LoopOut is a location-based social activity discovery app built with Flutter. It helps people in Bangalore find and join real-world activities — from sports and gaming sessions to art workshops, food meetups, photography walks, and more.
This project is a starting point for a Flutter application.
---
A few resources to get you started if this is your first Flutter project:
## ✨ Features
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
### 🏠 Discover Activities
- **Home Feed** — Browse trending and upcoming activities near you
- **Category Filters** — Filter by Sports, Gaming, Art, Music, Tech, Food, Fitness, Movies, Reading, Travel, Photography, Dance
- **Search** — Full-text search across all activities
- **Map View** — See activities pinned on Google Maps
For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
### 🎯 Create & Host
- **Multi-step Activity Creator** — Title, description, category, date/time, location picker
- **Participant Limits** — Set capacity (2–50 people)
- **Pricing Options** — Host free or paid activities (₹)
### 👤 User Profiles
- **Firebase Authentication** — Secure phone/email sign-in
- **Interest Selection** — Pick at least 3 interests during onboarding
- **Profile Customization** — Display name, bio, photo
### 💬 Chat
- **In-app Messaging** — Communicate with activity participants
### 📍 Location-Aware
- **Geolocator Integration** — Auto-detect user location
- **Bangalore-centric** — Optimized for Bangalore metro (~50 km radius)
- **Google Maps** — Interactive map view for activity discovery
---
## 🏗️ Architecture
```
lib/
├── core/
│   ├── models/           # ActivityModel, UserModel, ChatModel
│   ├── providers/        # Riverpod providers
│   ├── repositories/     # Firebase data layer
│   ├── router/           # GoRouter navigation
│   ├── services/         # Business logic services
│   └── theme/            # Material 3 theming
├── features/
│   ├── auth/             # Authentication flow
│   ├── onboarding/       # Interest selection & permissions
│   ├── home/             # Feed, search, map, activity cards
│   ├── create/           # Multi-step activity creation
│   ├── activity/         # Activity detail view
│   ├── chat/             # In-app messaging
│   ├── profile/          # User profile management
│   └── feed/             # Activity feed logic
├── shared/
│   ├── constants/        # App-wide constants
│   └── widgets/          # Reusable UI components
└── main.dart
```
---
## 🛠️ Tech Stack
| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter (Dart SDK ^3.10.4) |
| **State Management** | Riverpod + Riverpod Generator |
| **Navigation** | GoRouter |
| **Backend** | Firebase (Auth, Cloud Firestore, Storage) |
| **Maps** | Google Maps Flutter + Geolocator |
| **UI** | Material 3, Google Fonts, Flutter Animate |
| **Networking** | HTTP package |
| **Caching** | Cached Network Image |
| **Storage** | Shared Preferences |
---
## 🚀 Getting Started
### Prerequisites
- Flutter SDK `^3.10.4`
- Firebase project configured
- Google Maps API key
### Setup
```bash
# Clone the repository
git clone https://github.com/maneeshwar2923/LoopOut.git
cd LoopOut
# Install dependencies
flutter pub get
# Generate Riverpod code
dart run build_runner build --delete-conflicting-outputs
# Run the app
flutter run
```
### Firebase Configuration
1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android/iOS apps and download config files
3. Place `google-services.json` in `android/app/`
4. Place `GoogleService-Info.plist` in `ios/Runner/`
5. Enable **Authentication**, **Cloud Firestore**, and **Storage** in Firebase Console
### Google Maps API
1. Enable Maps SDK for Android/iOS in Google Cloud Console
2. Add the API key to:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/AppDelegate.swift`
---
## 📱 Screens
| Screen | Description |
|--------|-------------|
| **Onboarding** | Interest selection & permission requests |
| **Home Feed** | Trending carousel + categorized activity list |
| **Search** | Text-based activity search |
| **Map View** | Google Maps with activity markers |
| **Create Activity** | Multi-step form (details → location → limits) |
| **Activity Detail** | Full info, join/leave, participant list |
| **Chat** | Activity group messaging |
| **Profile** | User info, hosted & joined activities |
---
## 📂 Key Models
### ActivityModel
- `title`, `description`, `category`
- `hostId`, `hostName`, `hostPhotoUrl`
- `location` (GeoPoint), `locationName`
- `dateTime`, `capacity`, `price`
- `participants` list, `status` (active/completed/cancelled)
### UserModel
- `displayName`, `photoUrl`, `bio`
- `interests` list, `location` (GeoPoint)
---
## 🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request
---
## 📄 License
This project is for educational purposes.
---
<p align="center">
  Built with ❤️ using Flutter
</p>
