# Calley Personal – Flutter Mobile Application

A Flutter-based mobile application developed as part of the **Flutter Mobile App Developer Machine Test** for CSTech Infosolutions Private Limited.

The application follows the provided Figma UI designs and integrates with the Calley Mock REST API V2.

## 🚀 Project Overview

- **Project Name:** Calley Personal
- **Platform:** Android
- **Framework:** Flutter
- **Language:** Dart
- **State Management:** Provider
- **Architecture:** MVVM
- **API Integration:** Dio
- **Navigation:** GoRouter

## ✨ Features

### Authentication
- Language selection
- User registration
- User login
- WhatsApp OTP verification
- Forgot password

### Dashboard
- User welcome screen
- Calling list overview
- Call statistics
- Pending calls
- Completed calls
- Rescheduled calls

### Calling Lists
- Fetch calling lists from REST API
- View calling list details
- Display contact information
- View call statuses

### Profile & Settings
- User profile
- Language settings
- Account settings
- Navigation drawer

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Mobile application development |
| Dart | Programming language |
| Provider | State management |
| Dio | REST API integration |
| GoRouter | Application navigation |
| SharedPreferences | Local preferences |

## 🌐 API Integration

**Base URL:**
```text
https://mock-api.calleyacd.com/api
```

### Authentication APIs

| Method | Endpoint | Description |
|---|---|---|
| POST | `/auth/register` | Register user |
| POST | `/auth/login` | User login |
| POST | `/auth/send-otp` | Send OTP |
| POST | `/auth/verify-otp` | Verify OTP |

### Calling List APIs

| Method | Endpoint | Description |
|---|---|---|
| GET | `/list?userId={userId}` | Get user calling lists |
| GET | `/list/{listId}` | Get calling list details |

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── routes/
│   └── theme/
│
├── models/
├── services/
├── viewmodels/
├── views/
│   ├── auth/
│   ├── dashboard/
│   ├── calling_list/
│   ├── profile/
│   └── settings/
│
├── widgets/
└── main.dart
```

## ⚙️ Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android Emulator or Android Device

### Installation

1. Clone the repository:

```bash
git clone <your-github-repository-url>
```

2. Navigate to the project directory:

```bash
cd calley_personal
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

### Build Debug APK

```bash
flutter build apk --debug
```

APK location:

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 📦 Assignment Deliverables

- Video recording of the application running on an Android device.
- Debug APK for testing.
- Complete Flutter source code hosted on GitHub.

## 👨‍💻 Developer

**Harsh Gandhi**

Flutter Developer

Developed as part of the Flutter Mobile App Developer Machine Test for **CSTech Infosolutions Private Limited**.

---

*This project is currently under development.*
