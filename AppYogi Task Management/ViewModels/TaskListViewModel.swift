import Foundation
import SwiftUI
import SwiftData
import UserNotifications

extension TaskListViewModel {
    static var emptyContext: ModelContext {
        let schema = Schema([TaskItem.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [config])
        return ModelContext(container)
    }
}

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItem] = []
    var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTasks()
    }
    
    func fetchTasks() {
        let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\TaskItem.dueDate)])
        do {
            tasks = try modelContext.fetch(descriptor)
        } catch {
            print("❌ Failed to fetch tasks: \(error)")
            tasks = []
        }
    }
    
    func addTask(title: String, details: String?, dueDate: Date, reminderEnabled: Bool, isCompleted: Bool) {
        let newTask = TaskItem(title: title, details: details, dueDate: dueDate, isCompleted: isCompleted, reminderEnabled: reminderEnabled)
        
            modelContext.insert(newTask)
            if reminderEnabled {
                scheduleNotification(for: newTask)
            }
            fetchTasks()
        
    }
    
    func updateTask(_ task: TaskItem, title: String, details: String?, dueDate: Date, reminderEnabled: Bool, isCompleted: Bool) {
        let oldReminder = task.reminderEnabled
        let oldDueDate = task.dueDate
        
        task.title = title
        task.details = details
        task.dueDate = dueDate
        task.reminderEnabled = reminderEnabled
        task.isCompleted = isCompleted
        
        if oldReminder && (!reminderEnabled || dueDate != oldDueDate) {
            removeNotification(for: task)
        }
        if reminderEnabled {
            scheduleNotification(for: task)
        }
        
        // Fetch to refresh UI
        fetchTasks()
    }
    
    func deleteTask(_ task: TaskItem) {
        
            if task.reminderEnabled {
                removeNotification(for: task)
            }
            modelContext.delete(task)
            fetchTasks()
        
    }
    
    func toggleCompletion(_ task: TaskItem) {
        task.isCompleted.toggle()
        fetchTasks()
    }
    
    func tasksGroupedByDueDate() -> [(String, [TaskItem])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        var todayTasks: [TaskItem] = []
        var tomorrowTasks: [TaskItem] = []
        var upcomingTasks: [TaskItem] = []
        
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
        
        var result: [(String, [TaskItem])] = []
        if !todayTasks.isEmpty { result.append(("Today", todayTasks)) }
        if !tomorrowTasks.isEmpty { result.append(("Tomorrow", tomorrowTasks)) }
        if !upcomingTasks.isEmpty { result.append(("Upcoming", upcomingTasks)) }
        return result
    }
    
    private func scheduleNotification(for task: TaskItem) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default
        content.userInfo = ["taskID": task.id.uuidString]
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: task.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: task.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule notification for \(task.title): \(error.localizedDescription)")
            } else {
                print("✅ Notification scheduled for task: \(task.title)")
            }
        }
    }
    
    private func removeNotification(for task: TaskItem) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [task.id.uuidString])
        print("🗑 Removed notification with ID: \(task.id.uuidString)")
    }
}
