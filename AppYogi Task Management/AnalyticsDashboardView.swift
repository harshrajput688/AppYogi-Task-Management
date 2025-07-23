import SwiftUI

struct AnalyticsDashboardView: View {
    let tasks: [TaskItem]
    
    var completedCount: Int {
        tasks.filter { $0.isCompleted }.count
    }
    var pendingCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Analytics Dashboard")
                .font(.title2)
                .bold()
            HStack(spacing: 32) {
                VStack {
                    Text("\(completedCount)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                    Text("Completed")
                        .font(.headline)
                }
                VStack {
                    Text("\(pendingCount)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.orange)
                    Text("Pending")
                        .font(.headline)
                }
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    AnalyticsDashboardView(tasks: [])
} 