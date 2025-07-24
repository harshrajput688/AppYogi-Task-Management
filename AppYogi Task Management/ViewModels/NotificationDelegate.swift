import Foundation
import UserNotifications

/// Handles notification interactions and delegates notification events
class NotificationDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    // MARK: - Shared Instance
    
    /// Singleton shared instance for global access
    static let shared = NotificationDelegate()
    
    // MARK: - Published Properties
    
    /// The ID of the task associated with the tapped notification
    @Published var selectedTaskID: String?
    
    // MARK: - Notification Center Delegate Methods
    
    /// Called when user interacts with a notification (taps on it)
    /// - Parameters:
    ///   - center: The notification center
    ///   - response: The user's response to the notification
    ///   - completionHandler: Callback to execute when handling is complete
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Extract task ID from notification userInfo if present
        if let taskID = response.notification.request.content.userInfo["taskID"] as? String {
            DispatchQueue.main.async {
                // Update selectedTaskID on main thread to trigger UI updates
                self.selectedTaskID = taskID
            }
        }
        // Call completion handler to indicate we're done processing
        completionHandler()
    }
    
    /// Called when a notification is delivered while the app is in foreground
    /// - Parameters:
    ///   - center: The notification center
    ///   - notification: The notification being presented
    ///   - completionHandler: Callback with presentation options
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Always show banner, play sound, and update badge when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }
}
