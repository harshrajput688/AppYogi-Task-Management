//
//  AnalyticsCard.swift
//  AppYogi Task Management
//
//  Created by Harsh Rajput on 24/07/25.
//

import SwiftUI

/// A reusable card component for displaying analytics metrics
struct AnalyticsCard: View {
    // MARK: - Properties
    let title: String      // The title of the metric
    let count: Int        // The numeric value to display
    let icon: String      // SF Symbol name for the icon
    let color: Color      // The accent color for the card
    
    // MARK: - View Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header row with icon and title
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.headline)
                Spacer()
            }
            
            // The count value in large bold text
            Text("\(count)")
                .font(.largeTitle.bold())
        }
        .padding()
        .background(Color(.secondarySystemBackground))  // Light gray background
        .cornerRadius(12)  // Rounded corners
    }
}


#Preview {
    AnalyticsCard(title: "Todays Tasks", count: 5, icon: "calendar", color: .blue)
}
