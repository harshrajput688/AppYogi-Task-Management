import Foundation
import SwiftData

@Model
final class TaskItem: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var details: String?
    var dueDate: Date
    var isCompleted: Bool
    var reminderEnabled: Bool
    
    init(title: String, details: String? = nil, dueDate: Date, isCompleted: Bool = false, reminderEnabled: Bool = false) {
        self.id = UUID()
        self.title = title
        self.details = details
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.reminderEnabled = reminderEnabled
    }
} 