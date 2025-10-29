# 🧾 Order Management

A simple Flutter app demonstrating **Firestore CRUD (Create, Read, Update, Delete)** functionality with a clean, single-screen UI.  
This app helps manage food orders stored in **Firebase Firestore**, with real-time updates.

---

## 📱 Features

- **🔥 Firebase Firestore Integration**
  - Real-time data sync using Firestore Streams.
- **🧩 CRUD Operations**
  - **Create** – Add new orders using a modal bottom sheet.  
  - **Read** – View all orders live in a list.  
  - **Update** – Edit any order from the list using a bottom sheet.  
  - **Delete** – Remove orders after confirmation through a dialog.
- **🎨 Simple & Clean UI**
  - Each order appears as a **Card** with **Edit ✏️** and **Delete 🗑️** icons.
  - A **Floating Action Button ➕** opens the order creation form.
- **💡 Real-Time Updates**
  - Any changes in Firestore reflect instantly in the UI.

---

## 🧱 Tech Stack

| Technology | Description |
|-------------|-------------|
| **Flutter** | UI framework |
| **Dart** | Programming language |
| **Firebase Firestore** | Real-time cloud database |


---

## 📸 App Flow

| Action | Description |
|--------|--------------|
| **Read** | Orders shown in real time from Firestore |
| **Create** | ➕ FAB → Modal bottom sheet to add a dish |
| **Update** | ✏️ Edit icon → Modal bottom sheet to edit dish |
| **Delete** | 🗑️ Delete icon → Confirmation dialog |

---

## 📦 APK Download

You can download the latest APK file here:  
👉 [**Download Order Management APK**](https://github.com/Zaminur151/Order-Management/releases/download/v1.0/app-release.apk)

---

## ⚙️ Setup Instructions

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/yourusername/order_management.git
cd order_management
```

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).  
2. Enable **Cloud Firestore**.  
3. Add Firebase to your Flutter app:
   - Download `google-services.json` and place it in `android/app/`.
   - (Optional for iOS) Download `GoogleService-Info.plist` and place it in `ios/Runner/`.

### 4️⃣ Run the App
```bash
flutter run
```


---

## 🧑‍💻 Author

**MD. Zaminur Hasan**  
Flutter Developer  
📧 Email: _[zaminurprof@gmail.com]_  

---
