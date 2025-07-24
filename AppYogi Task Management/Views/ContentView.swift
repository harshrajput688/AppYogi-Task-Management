//
//  ContentView.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 23/07/25.
//

import SwiftUI
import SwiftData

/// The main view of the task management application
struct ContentView: View {
    // MARK: - Environment and State Properties
    
    /// SwiftData model context for persistence operations
    @Environment(\.modelContext) private var modelContext
    
    /// ViewModel that manages task data and business logic
    @StateObject private var viewModel = TaskListViewModel(modelContext: TaskListViewModel.emptyContext)
    
    /// Controls visibility of the add task sheet
    @State private var showAddTask = false
    
    /// Holds the task being edited (nil when not editing)
    @State private var editTask: TaskItem? = nil
    
    /// Search text for filtering tasks
    @State private var searchText: String = ""
    
    /// Controls visibility of analytics view
    @State private var showAnalytics = false
    
    /// Handles notification interactions
    @ObservedObject var notificationDelegate = NotificationDelegate.shared
    
    // MARK: - Computed Properties
    
    /// Filters tasks based on search text
    var filteredTasks: [TaskItem] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) ||
                (task.details?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    // MARK: - Main View Body
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack {
                    // Search bar at the top
                    SearchBar(text: $searchText)
                    
                    // Conditional view for empty state vs task list
                    if filteredTasks.isEmpty {
                        emptyStateView
                    } else {
                        taskListView
                    }
                }
                .navigationTitle("Tasks")
                .toolbar {
                    // Add task button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddTask = true }) {
                            Image(systemName: "plus")
                        }
                    }
                    
                    // Analytics button
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showAnalytics = true }) {
                            Image(systemName: "chart.bar.xaxis")
                        }
                    }
                }
                // Sheets for presenting modal views
                .sheet(isPresented: $showAddTask) {
                    AddEditTaskView { title, details, dueDate, reminderEnabled, isCompleted in
                        viewModel.addTask(title: title, details: details, dueDate: dueDate,
                                        reminderEnabled: reminderEnabled, isCompleted: isCompleted)
                        viewModel.fetchTasks()
                    }
                }
                .sheet(item: $editTask) { task in
                    AddEditTaskView(task: task) { title, details, dueDate, reminderEnabled, isCompleted in
                        viewModel.updateTask(task, title: title, details: details, dueDate: dueDate,
                                          reminderEnabled: reminderEnabled, isCompleted: isCompleted)
                        viewModel.fetchTasks()
                    }
                }
                .sheet(isPresented: $showAnalytics) {
                    AnalyticsView(tasks: filteredTasks)
                }
                .onAppear {
                    // Initialize model context if needed
                    if viewModel.modelContext !== modelContext {
                        viewModel.modelContext = modelContext
                        viewModel.fetchTasks()
                    }
                    
                    // Auto-scroll to Today section if it exists
                    let sections = groupedFilteredTasks().map { $0.0 }
                    if sections.contains("Today") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                proxy.scrollTo("Today", anchor: .top)
                            }
                        }
                    }
                }
                .onChange(of: notificationDelegate.selectedTaskID) {
                    // Handle notification taps to edit tasks
                    if let id = notificationDelegate.selectedTaskID,
                       let task = viewModel.tasks.first(where: { $0.id.uuidString == id }) {
                        editTask = task
                    }
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    /// View shown when there are no tasks
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "tray")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(.secondary)
            Text("No tasks added yet")
                .font(.title2)
                .foregroundColor(.secondary)
            Text("Tap below to add your first task!")
                .font(.body)
                .foregroundColor(.secondary)
            Button(action: { showAddTask = true }) {
                Label("Add Task", systemImage: "plus")
                    .font(.headline)
                    .padding()
                    .background(Capsule().fill(Color.accentColor))
                    .foregroundColor(.white)
            }
            Spacer()
        }
    }
    
    /// View showing the list of tasks
    private var taskListView: some View {
        List {
            ForEach(groupedFilteredTasks(), id: \.0) { section, tasks in
                Section(header: Text(section).id(section)) {
                    ForEach(tasks) { task in
                        HStack {
                            // Completion toggle button
                            Button(action: { viewModel.toggleCompletion(task) }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            // Task details
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .strikethrough(task.isCompleted)
                                    .font(.headline)
                                if let details = task.details, !details.isEmpty {
                                    Text(details)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Text("Due: \(task.dueDate, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Edit button
                            Button(action: { editTask = task }) {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            // Delete button
                            Button(action: { viewModel.deleteTask(task) }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            editTask = task
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // MARK: - Helper Methods
    
    /// Groups filtered tasks by their due date into sections
    private func groupedFilteredTasks() -> [(String, [TaskItem])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        var pastTasks: [TaskItem] = []
        var todayTasks: [TaskItem] = []
        var tomorrowTasks: [TaskItem] = []
        var upcomingTasks: [TaskItem] = []
        
        for task in filteredTasks {
            let taskDay = calendar.startOfDay(for: task.dueDate)
            if taskDay < today {
                pastTasks.append(task)
            } else if taskDay == today {
                todayTasks.append(task)
            } else if taskDay == tomorrow {
                tomorrowTasks.append(task)
            } else if taskDay > tomorrow {
                upcomingTasks.append(task)
            }
        }
        
        var result: [(String, [TaskItem])] = []
        if !pastTasks.isEmpty { result.append(("Past Tasks", pastTasks)) }
        if !todayTasks.isEmpty { result.append(("Today", todayTasks)) }
        if !tomorrowTasks.isEmpty { result.append(("Tomorrow", tomorrowTasks)) }
        if !upcomingTasks.isEmpty { result.append(("Upcoming", upcomingTasks)) }
        return result
    }
}

// MARK: - Date Formatter

/// Shared date formatter for consistent date display
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium  // E.g., "Nov 23, 2023"
    formatter.timeStyle = .short   // E.g., "3:30 PM"
    return formatter
}()

// MARK: - Preview

#Preview {
    ContentView()
}
