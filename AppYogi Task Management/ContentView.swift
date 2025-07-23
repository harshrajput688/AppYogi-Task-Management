//
//  ContentView.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 23/07/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = TaskListViewModel(modelContext: TaskListViewModel.emptyContext)
    @State private var showAddTask = false
    @State private var editTask: TaskItem? = nil
    @State private var searchText: String = ""
    @State private var showAnalytics = false
    @ObservedObject var notificationDelegate = NotificationDelegate.shared
    
    var filteredTasks: [TaskItem] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return viewModel.tasks
        } else {
            return viewModel.tasks.filter { task in
                task.title.localizedCaseInsensitiveContains(searchText) || (task.details?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                VStack {
                    SearchBar(text: $searchText)
                    if filteredTasks.isEmpty {
                        emptyStateView
                    } else {
                        taskListView
                    }
                }
                .navigationTitle("Tasks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddTask = true }) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { showAnalytics = true }) {
                            Image(systemName: "chart.bar.xaxis")
                        }
                    }
                }
                .sheet(isPresented: $showAddTask) {
                    AddEditTaskView { title, details, dueDate, reminderEnabled, isCompleted in
                        viewModel.addTask(title: title, details: details, dueDate: dueDate, reminderEnabled: reminderEnabled, isCompleted: isCompleted)
                        viewModel.fetchTasks()
                    }
                }
                .sheet(item: $editTask) { task in
                    AddEditTaskView(task: task) { title, details, dueDate, reminderEnabled, isCompleted in
                        viewModel.updateTask(task, title: title, details: details, dueDate: dueDate, reminderEnabled: reminderEnabled, isCompleted: isCompleted)
                        viewModel.fetchTasks()
                    }
                }
                .sheet(isPresented: $showAnalytics) {
                    AnalyticsDashboardView(tasks: filteredTasks)
                }
                .onAppear {
                    if viewModel.modelContext !== modelContext {
                        viewModel.modelContext = modelContext
                        viewModel.fetchTasks()
                    }
                    // Scroll to Today section if it exists
                    let sections = groupedFilteredTasks().map { $0.0 }
                    if sections.contains("Today") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                proxy.scrollTo("Today", anchor: .top)
                            }
                        }
                    }
                }
                .onChange(of: notificationDelegate.selectedTaskID) { newID in
                    if let id = newID, let task = viewModel.tasks.first(where: { $0.id.uuidString == id }) {
                        editTask = task
                    }
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        return VStack(spacing: 16) {
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
    
    private var taskListView: some View {
        return List {
            ForEach(groupedFilteredTasks(), id: \.0) { section, tasks in
                Section(header: Text(section).id(section)) {
                    ForEach(tasks) { task in
                        HStack {
                            Button(action: { viewModel.toggleCompletion(task) }) {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .green : .gray)
                            }
                            .buttonStyle(PlainButtonStyle())
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
                            Button(action: { editTask = task }) {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(BorderlessButtonStyle())
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
    
    private func groupedFilteredTasks() -> [(String, [TaskItem])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        var overdueTasks: [TaskItem] = []
        var todayTasks: [TaskItem] = []
        var tomorrowTasks: [TaskItem] = []
        var upcomingTasks: [TaskItem] = []
        for task in filteredTasks {
            let taskDay = calendar.startOfDay(for: task.dueDate)
            if taskDay < today {
                overdueTasks.append(task)
            } else if taskDay == today {
                todayTasks.append(task)
            } else if taskDay == tomorrow {
                tomorrowTasks.append(task)
            } else if taskDay > tomorrow {
                upcomingTasks.append(task)
            }
        }
        var result: [(String, [TaskItem])] = []
        if !overdueTasks.isEmpty { result.append(("Overdue", overdueTasks)) }
        if !todayTasks.isEmpty { result.append(("Today", todayTasks)) }
        if !tomorrowTasks.isEmpty { result.append(("Tomorrow", tomorrowTasks)) }
        if !upcomingTasks.isEmpty { result.append(("Upcoming", upcomingTasks)) }
        return result
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView()
}
