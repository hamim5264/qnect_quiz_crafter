# Qnect Quiz Crafter 🎓📚

**Qnect Quiz Crafter** is a full-featured, role-based EdTech mobile application built with **Flutter** and **Firebase**, designed to connect **Students**, **Teachers**, and **Admins** on a single scalable learning platform.

The app focuses on **course management, quiz creation, real-time attempts, analytics, and role-specific dashboards**, following clean architecture and modern Flutter best practices.

> ⚠️ **Current Status:**  
> This project is finished for testing and **not published on Google Play Store yet**.  
> Users can download the **APK directly from the official website**.

---

## 🚀 App Overview

Qnect Quiz Crafter is designed as a **multi-role educational ecosystem**:

- 👨‍🎓 **Students** learn, enroll in courses, attempt quizzes, and track progress  
- 👨‍🏫 **Teachers** create courses, manage quizzes, monitor performance, and interact with students  
- 🛠️ **Admin** controls approvals, users, analytics, and platform governance  

The app is optimized for **performance, scalability, and clean UI/UX**, with a strong focus on real-world educational workflows.

---

## 🧩 Core Features

### 🔐 Authentication & Onboarding
- Email & Password authentication
- Google Sign-In support
- Firebase Phone OTP verification (6-digit)
- Secure password setup & reset
- Role-based onboarding flow
- Blocked user handling

---

### 👨‍🎓 Student Features
- Browse approved courses
- Enroll in free or paid courses
- Attempt quizzes within valid time windows
- Real-time countdown timer during quiz
- Auto-submission on timeout
- Quiz result calculation
- Course feedback system
- Student dashboard with stats
- Practice quizzes & learning flow

---

### 👨‍🏫 Teacher Features
- Create and manage courses
- Set course start & end dates
- Course enrollment timelines
- Create quizzes under courses
- Quiz scheduling within course duration
- Publish course requests (Admin approval)
- Course & quiz analytics
- Student performance overview
- Teacher dashboard with insights

---

### 🛠️ Admin Features
- Approve / reject teacher course requests
- Manage all users (Students & Teachers)
- Block / unblock users
- Platform-wide analytics (Pulseboard)
- Course approval statistics
- Revenue & enrollment overview
- Feedback monitoring
- Full system access

---

### 📊 Analytics & Dashboard
- Pulseboard analytics
- Course status distribution (Pending / Approved)
- Enrollment count & sales metrics
- Role-based dashboard UI
- Real-time Firestore streams

---

### 🔔 Notifications System
- Teacher publish request notifications to Admin
- Admin decision notifications to Teacher
- Role-specific notification visibility
- Secure per-user notification isolation

---

## 🧱 Architecture & Tech Stack

### 📱 Frontend
- **Flutter (Latest Stable)**
- **Dart**
- Material & Cupertino widgets
- Custom Design System (Colors, Typography, Tokens)

### 🔄 State Management
- **Riverpod 3.x**
- NotifierProvider & StateNotifier
- Immutable state with `Equatable`

### 🔥 Backend & Services
- **Firebase Authentication**
- **Cloud Firestore**
- Firebase Storage
- Firebase Phone Auth (OTP)

### 🧠 Architecture
- Clean Architecture principles
- Feature-based folder structure
- Separation of:
  - Presentation
  - Controller
  - Widgets
  - Data & Services



---

## 📦 APK Distribution

This app is **not deployed to Play Store yet**.

### 📥 How Users Install
1. Visit the official website
2. Download the APK file
3. Enable **“Install from unknown sources”**
4. Install and start using the app

> This method is used for **testing, demo, and controlled distribution**.

---

## 🛡️ Security & Best Practices
- Firebase Authentication security rules
- Firestore role-based access control
- Secure OTP verification
- Input validation & form safety
- Blocked user redirection
- No sensitive keys committed

---

## 🧪 Testing Status
- ✅ Feature complete
- ✅ Manual testing done
- ⏳ Play Store release planned
- ⏳ Automated tests (future scope)

---

## 🛠️ Setup & Run Locally

```bash
git clone https://github.com/your-username/qnect_quiz_crafter.git
cd qnect_quiz_crafter
flutter pub get
flutter run
```
## 📌 Future Improvements

- Google Play Store deployment  
- iOS build release  
- Push notifications using Firebase Cloud Messaging (FCM)  
- Performance optimizations for large-scale usage  
- Automated unit & integration testing  
- AI-powered quiz generation and smart suggestions  
- Offline quiz attempt mode with sync support  

---

## 👨‍💻 Author & Contributors

### 🏢 Project Developed Under  
**DevEngine – Fueling Your Startup with Custom Software**  
🌐 Website: https://devengine-three.vercel.app/  

🎨 **Design (Figma):**  
https://www.figma.com/design/gPrEizwgiEtO5Bao98qIck/QuizCrafter-Defense-Project---V1.0.0

---

### 👤 Project Author  
**MD. ABDUL HAMIM LEON**  
Software Developer  
**BeUp In Tech**  
*A concern of Betopia Group*  
📍 Dhaka, Bangladesh  

**Education:**  
Daffodil International University  
Bachelor of Science in Computer Science & Engineering  

---

### 🎨 Co-Author  
**MD. RAFIUL ISLAM**  
UI/UX Designer  
**BeUp In Tech**  
*A concern of Betopia Group*  
📍 Dhaka, Bangladesh  

**Education:**  
Daffodil International University  
Bachelor of Science in Computer Science & Engineering  

---

## 🖼️ App Mockups & Screenshots

Below are selected mockups and UI previews of **Qnect Quiz Crafter**, created during the design and development phases.

<img width="1920" height="1080" alt="Template Purchase Statement" src="https://github.com/user-attachments/assets/52de4ed3-7bf5-4465-9da4-a6d2d87a4726" />
<img width="2564" height="2991" alt="Quiz Crafter — Copyright   Ip Report (ui Design)" src="https://github.com/user-attachments/assets/e6b4aacd-651d-48fd-8d94-24553defdb6e" />
<img width="1920" height="1080" alt="On Boarding" src="https://github.com/user-attachments/assets/ef173892-54ee-4aa8-bd14-260619a960d9" />
<img width="1920" height="1080" alt="AUTHENTICATION" src="https://github.com/user-attachments/assets/7fd8f2b7-c2d4-4d61-89b2-d09010bdf63c" />
<img width="1920" height="1080" alt="ADMIN" src="https://github.com/user-attachments/assets/241b667a-ec53-4bba-8470-db6effbfd34e" />
<img width="1920" height="1080" alt="TEACHER   STUNDET" src="https://github.com/user-attachments/assets/fe2dd13e-1a41-4771-8245-16fc1eacbf91" />
<img width="1920" height="1080" alt="COURSES" src="https://github.com/user-attachments/assets/b89b3f19-2eaf-4a51-8a76-eec60359cbcd" />
<img width="1920" height="1080" alt="QuizGenie" src="https://github.com/user-attachments/assets/0cb2fdcd-b2ca-464c-bb7a-3b10a0d274b6" />
<img width="1920" height="1080" alt="Certificates" src="https://github.com/user-attachments/assets/ed0ee43f-4324-4354-9a11-15eff5333732" />
<img width="1920" height="1080" alt="Payments" src="https://github.com/user-attachments/assets/3b7e5e80-535a-45d5-a14d-f6594d657398" />

---

## ⚠️ Design & Copyright Notice

⚠️ **Important Notice**

All **UI/UX designs, mockups, purchase flow screens, and visual assets** associated with this project are **copyright protected**.

- The **Figma design** linked above is the **original intellectual property** of the project team under **DevEngine**.
- Any **reuse, resale, redistribution, or reproduction** of the design (in whole or in part) **without written permission** is strictly prohibited.
- This notice also applies to **purchase-related mockups and payment UI representations**, which are included for **demonstration and testing purposes only**.

---

## © Copyright

© 2025 **DevEngine**. All rights reserved.

This project, its source code, UI designs, mockups, and related assets are proprietary and intended for **testing, demonstration, and internal evaluation purposes only**.

Unauthorized copying, distribution, modification, or commercial use of this software or its designs, without explicit permission from the authors and organization, is strictly prohibited.





