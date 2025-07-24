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
                        .onChange(of: dueDate) {
                            if dueDate < Date() {
                                reminderEnabled = false
                            }
                        }

                    Toggle("Enable Reminder", isOn: $reminderEnabled)
                        .disabled(dueDate < Date())

                    if dueDate < Date() {
                        Text("Reminders can't be set for past dates and times.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }

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
        .onAppear {
            // Ensure correct state when view loads
            if dueDate < Date() {
                reminderEnabled = false
            }
        }
    }
}

#Preview {
    AddEditTaskView { _, _, _, _, _ in }
}
