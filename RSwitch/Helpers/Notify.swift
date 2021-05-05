//
// This lets us annoy the user with notification center popups
//

import Foundation
import UserNotifications

func notifyUser(title: String, subtitle: String, body: String) {
    
  if (Preferences.notificationsAllowed) {

    let notificationCenter = UNUserNotificationCenter.current()
    
    let notification = UNMutableNotificationContent()
    notification.title = title
    notification.subtitle = subtitle
    notification.body = body
    notification.sound = UNNotificationSound.default
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    
    let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notification, trigger: trigger)
    
    notificationCenter.add(notificationRequest) { error in
      if let err = error {
        debugPrint("\(err)")
      }
    }
    
  }
  
}
