# ⏱️ ChronoLift  

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/badge/Drift-FF6F00?style=for-the-badge&logo=sqlite&logoColor=white" />
  <img src="https://img.shields.io/badge/Supabase-3FCF8E?style=for-the-badge&logo=supabase&logoColor=white" />
  <img src="https://img.shields.io/badge/License-GPLv3-blue.svg?style=for-the-badge" />
</p>  

ChronoLift - Your Personal Workout Tracker App.  
Track your lifts, measure your progress, crush your goals.

ChronoLift is a **local-first workout tracker** built with Flutter, Drift, and Supabase. It’s designed to give you full control of your training data while still allowing seamless syncing across devices when you sign in.  


## ✨ Features  
- 📊 **Track workouts** – Create workouts, add exercises, log sets, and monitor progress.  
- 🔒 **Local-first** – All data is stored locally on your device first (using Drift/SQLite).  
- ☁️ **Cloud sync (in-progress)** – Sign in with Supabase to sync your workouts across devices.    
- 📈 **Workout insights** – View advanced stats such as total sets completed this week, top 3 most performed exercises this month, bench press volume per workout over time, and more.  
- 🛠️ **Custom routines** – Add your own exercises and design training plans.  


## 🏗️ Tech Stack  
- **Flutter** – Cross-platform app framework for both iOS and Android 
- **Drift** – Local SQLite ORM with DAOs and type-safe queries  
- **Supabase** – Cloud backend for authentication and optional data sync  

## 🚀 Getting Started  

### Prerequisites  
- [Flutter](https://docs.flutter.dev/get-started/install) (latest stable version)  
- [Dart](https://dart.dev/get-dart)  
- A Supabase project (for auth + sync, optional)  

### Setup  
1. Fork and Clone the repo:  
   ```bash
   git clone https://github.com/YOUR_USERNAME/chronolift.git
   cd chronolift
2. Install dependencies:
    ```bash
    flutter pub get
3. Generate Drift code:
    ```bash
    dart run build_runner build
4. Run the app
    ```bash
    flutter run

## 🤝 Contributing

Pull requests and feature ideas are welcome! Please fork the repo and submit a PR.

## 📜 License

GPL v3 License © 2025