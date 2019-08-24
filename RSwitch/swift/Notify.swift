//
//  Notify.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate : NSUserNotificationCenterDelegate {
  
  func notifyUser(title: String? = nil, subtitle: String? = nil, text: String? = nil) -> Void {
    
    let notification = NSUserNotification()
    
    notification.title = title
    notification.subtitle = subtitle
    notification.informativeText = text
    
    notification.soundName = NSUserNotificationDefaultSoundName
    
    NSUserNotificationCenter.default.delegate = self
    NSUserNotificationCenter.default.deliver(notification)
    
  }

  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }
  
}
