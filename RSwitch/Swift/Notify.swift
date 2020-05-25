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

  
  func notifyUserWithDL(title: String? = nil, subtitle: String? = nil, text: String? = nil) -> Void {
    
    let notification = NSUserNotification()
    
//    notification.identifier = "RSwitch"
    notification.title = title
    notification.subtitle = subtitle
    notification.informativeText = text
    notification.hasActionButton = true
    notification.otherButtonTitle = "Dismiss"
    notification.actionButtonTitle = "Download"
    
    notification.soundName = NSUserNotificationDefaultSoundName 
    
    NSUserNotificationCenter.default.delegate = self
    NSUserNotificationCenter.default.deliver(notification)
    
  }

  
  func notifyUser(title: String? = nil, subtitle: String? = nil, text: String? = nil) -> Void {
    
    let notification = NSUserNotification()
    
//    notification.identifier = "RSwitch"
    notification.title = title
    notification.subtitle = subtitle
    notification.informativeText = text
    
    notification.soundName = NSUserNotificationDefaultSoundName
    
    NSUserNotificationCenter.default.delegate = self
    NSUserNotificationCenter.default.deliver(notification)
    
  }

  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return(true)
  }
  
  func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
  }
  
}
