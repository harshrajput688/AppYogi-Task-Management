//
//  AppYogi_Task_ManagementApp.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 23/07/25.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct AppYogi_Task_ManagementApp: App {
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskItem.self)
    }
}
