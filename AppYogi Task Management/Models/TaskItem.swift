import Foundation
import SwiftData

/// A model class representing a task item that conforms to SwiftData's `@Model` macro
/// and `Identifiable` protocol for unique identification in SwiftUI views.
@Model
final class TaskItem: Identifiable {
    
    // MARK: - Properties
    
    /// A unique identifier for the task, marked with SwiftData's `@Attribute(.unique)`
    /// to ensure no duplicate IDs in the database.
    @Attribute(.unique) var id: UUID
    
    /// The title or name of the task. This is required and should not be empty.
    var title: String
    
    /// Optional additional details or description about the task.
    var details: String?
    
    /// The due date and time for the task.
    var dueDate: Date
    
    /// Completion status flag indicating whether the task is done.
    var isCompleted: Bool
    
    /// Flag indicating whether a reminder should be set for this task.
    var reminderEnabled: Bool
    
    // MARK: - Initializer
    
    /// Creates a new TaskItem instance.
    /// - Parameters:
    ///   - title: The title/name of the task (required)
    ///   - details: Additional description or notes (optional)
    ///   - dueDate: The date and time when the task is due
    ///   - isCompleted: Initial completion status (defaults to false)
    ///   - reminderEnabled: Whether to enable reminders (defaults to false)
    init(
        title: String,
        details: String? = nil,
        dueDate: Date,
        isCompleted: Bool = false,
        reminderEnabled: Bool = false
    ) {
        self.id = UUID()  // Automatically generate a unique identifier
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.reminderEnabled = reminderEnabled
    }
    
    // MARK: - Helper Methods
    
    /// Convenience method to toggle the completion status
    func toggleCompletion() {
        isCompleted.toggle()
    }
    
    /// Returns a string representation of the due date in a user-friendly format
    func formattedDueDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dueDate)
    }
}
