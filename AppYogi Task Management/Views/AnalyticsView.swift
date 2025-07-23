//
//  AnalyticsView.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 24/07/25.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {
    let tasks: [TaskItem]
    
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    var pendingCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    var totalCount: Int {
        tasks.count
    }

    var todayCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }.count
    }

    var upcomingCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            $0.dueDate > today
        }.count
    }

    var overdueCount: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return tasks.filter {
            $0.dueDate < today && !$0.isCompleted
        }.count
    }

    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(spacing: 20) {
                    // Summary Cards
                    
                    VStack {
                        AnalyticsCard(
                            title: "Todays Tasks",
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

struct AnalyticsCard: View {
    let title: String
    let count: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            Text("\(count)")
                .font(.largeTitle.bold())
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    AnalyticsView(tasks: [])
}


