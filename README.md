# 📋 Task Management App

A modern task management application built with **SwiftUI** and **SwiftData**, following **MVVM architecture**. The app helps users organize their tasks with features like reminders, task grouping, search functionality, and analytics.

---

## ✨ Features

### ✅ Core Functionality
- Add, edit, and delete tasks
- Mark tasks as complete
- Persistent storage using SwiftData
- Clean MVVM architecture

### 📝 Task Management
- **Fields:**
  - Title (required)
  - Description (optional)
  - Due date (required)
  - Completion status
- 🔔 Reminders with local notifications
- 🔍 Search tasks by title or description

### 📅 Organized Views
- Tasks automatically grouped by:
  - Past Tasks
  - Today
  - Tomorrow
  - Upcoming

### 📊 Analytics Dashboard
- Visual stats for:
  - Today's tasks
  - Upcoming tasks
  - Overdue tasks
  - Completed tasks
  - Pending tasks
  - Total tasks

---

## 📸 Screenshots

### ➕ Add / Edit Task Screen

<img src="https://github.com/user-attachments/assets/103d161f-d3d3-4e94-9c76-bb57013b5150" width="250" />
<img src="https://github.com/user-attachments/assets/bcf695e0-54b7-4396-994a-01f549ac509a" width="250" />

---

### 🗂 Grouped Tasks

<img src="https://github.com/user-attachments/assets/72790c32-c36c-4cba-ba18-07d86b2ec88b" width="250" />
<img src="https://github.com/user-attachments/assets/710017e1-7b11-4416-8833-b7804ec45ba7" width="250" />

---

### 📋 Task List

<img src="https://github.com/user-attachments/assets/678051d6-fc12-45c0-85cb-7555b758ef87" width="250" />
<img src="https://github.com/user-attachments/assets/33026e4b-5d34-462e-a22d-12a7ea88378d" width="250" />

---

### 🔍 Search

<img src="https://github.com/user-attachments/assets/b99b3d42-ff6e-4058-8850-7c5116fa363d" width="250" />

---

### 📈 Analytics Dashboard

<img src="https://github.com/user-attachments/assets/e035b0ca-ad9f-4922-a55d-93e9e706f369" width="250" />

---

### 🔔 Notification

<img src="https://github.com/user-attachments/assets/bc7215fd-0b28-460a-92f3-bafe338b9f24" width="250" />

---

## 🛠 Technical Details

### 🧱 Architecture
- MVVM pattern
- Clear separation of concerns
- Modular and reusable components

### 💡 Technologies Used

| Component        | Technology     |
|------------------|----------------|
| UI Framework     | SwiftUI        |
| Data Storage     | SwiftData      |
| Notifications    | UserNotifications |
| Architecture     | MVVM           |

---

## 📁 File Structure

```text
TaskManagementApp/
├── App/
│   └── TaskManagementApp.swift        # App entry point
│
├── Model/
│   └── TaskItem.swift                 # Data model
│
├── View/
│   ├── ContentView.swift              # Main view
│   ├── AddEditTaskView.swift          # Task form
│   ├── AnalyticsView.swift            # Analytics dashboard
│   └── Components/
│       ├── SearchBar.swift            # Search component
│       └── AnalyticsCard.swift        # Stats card
│
├── ViewModel/
│   ├── TaskListViewModel.swift        # Main view model
│   └── NotificationDelegate.swift     # Notification handler
```


---

## 🚀 Getting Started

### ✅ Requirements
- iOS 17.0+
- Xcode 15+
- Swift 5.9+

### 🔧 Installation
1. Clone the repository
2. Open the project in Xcode
3. Build and run on a simulator or device

---

## 🔮 Future Enhancements
- 🌥 Cloud sync across devices
- 🏷 Task categories/tags
- 🔁 Recurring tasks
- 📊 More detailed analytics
- 📱 Widget support

---

Developed with ❤️ using **SwiftUI** and **SwiftData**
