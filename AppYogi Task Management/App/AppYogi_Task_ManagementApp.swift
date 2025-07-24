//
//  AppYogi_Task_ManagementApp.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 23/07/25.
//
import SwiftUI
import SwiftData
import UserNotifications

/// The main entry point for the Task Management application
@main
struct AppYogi_Task_ManagementApp: App {
    
    // MARK: - Initialization
    
    /// Sets up notification handling during app launch
    init() {
        // Configure notification center delegate
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
        
        // Request notification permissions from user
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
            // Note: 'granted' value could be used for additional handling if needed
        }
    }
    
    // MARK: - App Scene Configuration
    
    var body: some Scene {
        WindowGroup {
            // Main app content view
            ContentView()
        }
        // Configure SwiftData model container for TaskItem persistence
        .modelContainer(for: TaskItem.self)
    }
}
