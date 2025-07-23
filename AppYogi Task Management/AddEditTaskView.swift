import SwiftUI
import SwiftData

struct AddEditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    let task: TaskItem?
    var onSave: (String, String?, Date, Bool, Bool) -> Void
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var dueDate: Date = Date()
    @State private var reminderEnabled: Bool = false
    @State private var isCompleted: Bool = false
    
    init(task: TaskItem? = nil, onSave: @escaping (String, String?, Date, Bool, Bool) -> Void) {
        self.task = task
        self.onSave = onSave
        _title = State(initialValue: task?.title ?? "")
        _details = State(initialValue: task?.details ?? "")
        _dueDate = State(initialValue: task?.dueDate ?? Date())
        _reminderEnabled = State(initialValue: task?.reminderEnabled ?? false)
        _isCompleted = State(initialValue: task?.isCompleted ?? false)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Info")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $details)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                    Toggle("Enable Reminder", isOn: $reminderEnabled)
                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .navigationTitle(task == nil ? "Add Task" : "Edit Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title, details.isEmpty ? nil : details, dueDate, reminderEnabled, isCompleted)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddEditTaskView() { _,_,_,_,_ in }
} 
