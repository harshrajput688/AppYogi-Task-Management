//
//  AnalyticsView.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 24/07/25.
//

import SwiftUI
import SwiftData

/// A view that displays task analytics and statistics
struct AnalyticsView: View {
    // MARK: - Properties
    let tasks: [TaskItem]  // The list of tasks to analyze
    
    // MARK: - Computed Properties
    
    /// Count of completed tasks
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    
    /// Count of pending (incomplete) tasks
    var pendingCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    /// Total count of all tasks
    var totalCount: Int {
        tasks.count
    }

    /// Count of tasks due today
    var todayCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }.count
    }

    /// Count of upcoming tasks (future due dates)
    var upcomingCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            $0.dueDate > today
        }.count
    }

    /// Count of overdue incomplete tasks
    var overdueCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            $0.dueDate < today && !$0.isCompleted
        }.count
    }

    // MARK: - View Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // First column of analytics cards
                    VStack {
                        AnalyticsCard(
                            title: "Today's Tasks",
                            count: todayCount,
                            icon: "calendar",
                            color: .blue
                        )
                        AnalyticsCard(
                            title: "Upcoming Tasks",
                            count: upcomingCount,
                            icon: "calendar",
                            color: .blue
                        )
                        AnalyticsCard(
                            title: "Overdue Tasks",
                            count: overdueCount,
                            icon: "calendar",
                            color: .red
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Second row with completion stats
                    HStack(spacing: 16) {
                        AnalyticsCard(
                            title: "Completed",
                            count: completedCount,
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        AnalyticsCard(
                            title: "Pending",
                            count: pendingCount,
                            icon: "clock.fill",
                            color: .orange
                        )
                    }
                    
                    // Total tasks card
                    AnalyticsCard(
                        title: "Total Tasks",
                        count: totalCount,
                        icon: "calendar",
                        color: .blue
                    )
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Analytics")
            }
        }
    }
}


// MARK: - Preview
#Preview {
    AnalyticsView(tasks: [])
}
