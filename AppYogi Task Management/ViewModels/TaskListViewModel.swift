import Foundation
import SwiftUI
import SwiftData
import UserNotifications

extension TaskListViewModel {
    /// Provides an empty in-memory ModelContext for previews and testing
    static var emptyContext: ModelContext {
        let schema = Schema([TaskItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        return ModelContext(container)
    }
}

/// ViewModel responsible for managing task data and business logic
@MainActor
class TaskListViewModel: ObservableObject {
    // MARK: - Published Properties
    
    /// The list of tasks that will trigger UI updates when changed
    @Published private(set) var tasks: [TaskItem] = []
    
    // MARK: - Dependencies
    
    /// The SwiftData model context for persistence operations
    var modelContext: ModelContext
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a SwiftData context
    /// - Parameter modelContext: The SwiftData context to use for persistence
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTasks()
    }
    
    // MARK: - Data Operations
    
    /// Fetches tasks from the database and updates the published tasks array
    func fetchTasks() {
        let descriptor = FetchDescriptor<TaskItem>(
            sortBy: [SortDescriptor(\.dueDate)] // Sort by due date
        )
        
        do {
            tasks = try modelContext.fetch(descriptor)
            print("✅ Fetched \(tasks.count) tasks")
        } catch {
            print("❌ Failed to fetch tasks: \(error.localizedDescription)")
            tasks = []
        }
    }
    
    /// Adds a new task to the database
    /// - Parameters:
    ///   - title: The task title (required)
    ///   - details: Optional task description
    ///   - dueDate: When the task is due
    ///   - reminderEnabled: Whether to set a reminder
    ///   - isCompleted: Initial completion status
    func addTask(title: String, details: String?, dueDate: Date, reminderEnabled: Bool, isCompleted: Bool) {
        let newTask = TaskItem(
            title: title,
            details: details,
            dueDate: dueDate,
            isCompleted: isCompleted,
            reminderEnabled: reminderEnabled
        )
        
        modelContext.insert(newTask)
        
        if reminderEnabled {
            scheduleNotification(for: newTask)
        }
        
        fetchTasks() // Refresh the task list
    }
    
    /// Updates an existing task
    /// - Parameters:
    ///   - task: The task to update
    ///   - title: New title
    ///   - details: New description
    ///   - dueDate: New due date
    ///   - reminderEnabled: New reminder status
    ///   - isCompleted: New completion status
    func updateTask(_ task: TaskItem, title: String, details: String?, dueDate: Date,
                   reminderEnabled: Bool, isCompleted: Bool) {
        let oldReminder = task.reminderEnabled
        let oldDueDate = task.dueDate
        
        // Update task properties
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.reminderEnabled = reminderEnabled
        task.isCompleted = isCompleted
        
        // Handle notification updates
        if oldReminder && (!reminderEnabled || dueDate != oldDueDate) {
            removeNotification(for: task)
        }
        if reminderEnabled {
            scheduleNotification(for: task)
        }
        
        fetchTasks() // Refresh the task list
    }
    
    /// Deletes a task from the database
    /// - Parameter task: The task to delete
    func deleteTask(_ task: TaskItem) {
        if task.reminderEnabled {
            removeNotification(for: task)
        }
        
        modelContext.delete(task)
        fetchTasks() // Refresh the task list
    }
    
    /// Toggles the completion status of a task
    /// - Parameter task: The task to modify
    func toggleCompletion(_ task: TaskItem) {
        task.isCompleted.toggle()
        fetchTasks() // Refresh the task list
    }
    
    // MARK: - Task Grouping
    
    /// Groups tasks by their due date into sections
    /// - Returns: An array of tuples containing section titles and their tasks
    func tasksGroupedByDueDate() -> [(String, [TaskItem])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        var sections: [(String, [TaskItem])] = []
        var todayTasks: [TaskItem] = []
        var tomorrowTasks: [TaskItem] = []
        var upcomingTasks: [TaskItem] = []
        
        // Categorize each task
        for task in tasks {
            let taskDay = calendar.startOfDay(for: task.dueDate)
            
            if taskDay == today {
                todayTasks.append(task)
            } else if taskDay == tomorrow {
                tomorrowTasks.append(task)
            } else if taskDay > tomorrow {
                upcomingTasks.append(task)
            }
        }
        
        // Only include non-empty sections
        if !todayTasks.isEmpty { sections.append(("Today", todayTasks)) }
        if !tomorrowTasks.isEmpty { sections.append(("Tomorrow", tomorrowTasks)) }
        if !upcomingTasks.isEmpty { sections.append(("Upcoming", upcomingTasks)) }
        
        return sections
    }
    
    // MARK: - Notification Handling
    
    /// Schedules a local notification for a task
    /// - Parameter task: The task to schedule a notification for
    private func scheduleNotification(for task: TaskItem) {
        let center = UNUserNotificationCenter.current()
        
        // Request notification permissions if needed
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
                return
            }
            
            guard granted else {
                print("⚠️ Notification permission denied")
                return
            }
            
            // Configure notification content
            let content = UNMutableNotificationContent()
            content.title = "Task Reminder: \(task.title)"
            content.body = task.details ?? "No additional details"
            content.sound = .default
            content.userInfo = ["taskID": task.id.uuidString]
            
            // Set notification trigger
            let triggerDate = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: task.dueDate
            )
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: triggerDate,
                repeats: false
            )
            
            // Create and schedule the request
            let request = UNNotificationRequest(
                identifier: task.id.uuidString,
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("❌ Failed to schedule notification: \(error.localizedDescription)")
                } else {
                    print("✅ Scheduled notification for task: \(task.title)")
                }
            }
        }
    }
    
    /// Removes a pending notification for a task
    /// - Parameter task: The task whose notification should be removed
    private func removeNotification(for task: TaskItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [task.id.uuidString]
        )
        print("🗑 Removed notification for task: \(task.title)")
    }
}
