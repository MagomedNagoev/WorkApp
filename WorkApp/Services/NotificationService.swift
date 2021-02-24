
import Foundation
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAuth() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { (allow, error) in
            if !allow {
                print("Пользователь отказался от уведомлений")
            }
        }
    }
    
    func sheduleNotification(orderTitle: String) {
        let content = UNMutableNotificationContent()
        
        content.title = "Создан новый заказ"
        content.body = orderTitle
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let identifier = "NewOrderNotify"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
}
