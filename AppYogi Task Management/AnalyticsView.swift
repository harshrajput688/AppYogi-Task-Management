//
//  AnalyticsView.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 24/07/25.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {
    @Environment(\.colorScheme) private var colorScheme
    let tasks: [TaskItem]
    
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    var pendingCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Summary Cards
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
                
//                AnalyticsCard(
//                    title: "Upcoming",
//                    count: vm.upcomingCount,
//                    icon: "calendar",
//                    color: .blue
//                )
//                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Analytics")
            .background(colorScheme == .dark ? Color.black : Color(.systemGray6))
//            .background(colorScheme == .dark ? Color.black : Color(.systemGray6))
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


