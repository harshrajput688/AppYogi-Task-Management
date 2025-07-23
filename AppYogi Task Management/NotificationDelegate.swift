import Foundation
import UserNotifications

class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationDelegate()
    @Published var selectedTaskID: String?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let taskID = response.notification.request.content.userInfo["taskID"] as? String {
            DispatchQueue.main.async {
                self.selectedTaskID = taskID
            }
        }
        completionHandler()
    }
} 