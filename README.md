Task Management App

Overview
A modern task management application built with SwiftUI and SwiftData, following MVVM architecture. The app helps users organize their tasks with features like reminders, task grouping, search functionality, and analytics.

Features
Core Functionality
✅ Add, edit, and delete tasks

✅ Mark tasks as complete

✅ Persistent storage using SwiftData

✅ Clean MVVM architecture

Task Management
📝 Task fields:

Title (required)

Description (optional)

Due date (required)

Completion status

🔔 Reminders with local notifications

🔍 Search tasks by title or description

Organized Views
📅 Tasks automatically grouped by:

Past Tasks

Today

Tomorrow

Upcoming

Analytics Dashboard
📊 Visual statistics showing:

Today's tasks

Upcoming tasks

Overdue tasks

Completed tasks

Pending tasks

Total tasks count

Screenshots
Add/Edit task screen (First time)
<img width="1125" height="2436" alt="IMG_0586" src="https://github.com/user-attachments/assets/103d161f-d3d3-4e94-9c76-bb57013b5150" />
<img width="1125" height="2436" alt="IMG_0595" src="https://github.com/user-attachments/assets/bcf695e0-54b7-4396-994a-01f549ac509a" />
Group by
<img width="1125" height="2436" alt="IMG_0597" src="https://github.com/user-attachments/assets/72790c32-c36c-4cba-ba18-07d86b2ec88b" />
<img width="1125" height="2436" alt="IMG_0598" src="https://github.com/user-attachments/assets/710017e1-7b11-4416-8833-b7804ec45ba7" />
Tasks
<img width="1125" height="2436" alt="IMG_0597" src="https://github.com/user-attachments/assets/678051d6-fc12-45c0-85cb-7555b758ef87" />
<img width="1125" height="2436" alt="IMG_0598" src="https://github.com/user-attachments/assets/33026e4b-5d34-462e-a22d-12a7ea88378d" />
Searching	
<img width="1125" height="2436" alt="IMG_0594" src="https://github.com/user-attachments/assets/b99b3d42-ff6e-4058-8850-7c5116fa363d" />
Analytics Dashboard
<img width="1125" height="2436" alt="IMG_0592" src="https://github.com/user-attachments/assets/e035b0ca-ad9f-4922-a55d-93e9e706f369" />
Notification
![IMG_0596](https://github.com/user-attachments/assets/bc7215fd-0b28-460a-92f3-bafe338b9f24)

Technical Details
Architecture
MVVM Pattern (Model-View-ViewModel)

Clear separation of concerns

Modular and reusable components

Technologies Used
Component	Technology
UI Framework	SwiftUI
Data Storage	SwiftData
Notifications	UserNotifications
Architecture	MVVM
File Structure
text
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
    ├── TaskListViewModel.swift        # Main view model
    └── NotificationDelegate.swift     # Notification handler

    
Getting Started
Requirements
iOS 17.0+

Xcode 15+

Swift 5.9+

Installation
Clone the repository

Open the project in Xcode

Build and run on simulator or device

Future Enhancements
Cloud sync across devices

Task categories/tags

Recurring tasks

More detailed analytics

Widget support

Developed with ❤️ using SwiftUI and SwiftData
