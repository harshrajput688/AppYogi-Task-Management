import SwiftUI
import SwiftData

/// A view for adding or editing tasks with form inputs
struct AddEditTaskView: View {
    // MARK: - Environment Properties
    @Environment(\.dismiss) private var dismiss  // For dismissing the view
    
    // MARK: - Properties
    let task: TaskItem?  // Optional task for editing (nil when adding new)
    var onSave: (String, String?, Date, Bool, Bool) -> Void  // Callback when saving
    
    // MARK: - State Properties
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var dueDate: Date = Date()
    @State private var reminderEnabled: Bool = false
    @State private var isCompleted: Bool = false
    
    // MARK: - Initializer
    /// Initializes the view with an optional task and save handler
    /// - Parameters:
    ///   - task: The task to edit (nil when creating new)
    ///   - onSave: Callback when saving with parameters: (title, details, dueDate, reminderEnabled, isCompleted)
    init(task: TaskItem? = nil, onSave: @escaping (String, String?, Date, Bool, Bool) -> Void) {
        self.task = task
        self.onSave = onSave
        
        // Initialize state with task values if editing
        _title = State(initialValue: task?.title ?? "")
        _details = State(initialValue: task?.details ?? "")
        _dueDate = State(initialValue: task?.dueDate ?? Date())
        _reminderEnabled = State(initialValue: task?.reminderEnabled ?? false)
        _isCompleted = State(initialValue: task?.isCompleted ?? false)
    }
    
    // MARK: - View Body
    var body: some View {
        NavigationView {
            Form {
                // Task information section
                Section(header: Text("Task Info")) {
                    // Title text field
                    TextField("Title", text: $title)
                    
                    // Description text field
                    TextField("Description", text: $details)
                    
                    // Date picker for due date with date and time
                    DatePicker("Due Date",
                             selection: $dueDate,
                             displayedComponents: [.date, .hourAndMinute])
                    .onChange(of: dueDate) {
                        // Disable reminders if date is in past
                        if dueDate < Date() {
                            reminderEnabled = false
                        }
                    }
                    
                    // Toggle for reminder enable/disable
                    Toggle("Enable Reminder", isOn: $reminderEnabled)
                        .disabled(dueDate < Date())  // Disable if date is past
                    
                    // Warning message for past dates
                    if dueDate < Date() {
                        Text("Reminders can't be set for past dates and times.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    // Toggle for completion status
                    Toggle("Completed", isOn: $isCompleted)
                }
            }
            .navigationTitle(task == nil ? "Add Task" : "Edit Task")  // Dynamic title
            .toolbar {
                // Cancel button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                // Save button
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // Call save handler with all parameters
                        onSave(title,
                              details.isEmpty ? nil : details,  // Send nil if empty
                              dueDate,
                              reminderEnabled,
                              isCompleted)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)  // Disable if title empty
                }
            }
        }
        .onAppear {
            // Ensure correct state when view appears
            if dueDate < Date() {
                reminderEnabled = false
            }
        }
    }
}

// MARK: - Preview
#Preview {
    AddEditTaskView { _, _, _, _, _ in }
}
