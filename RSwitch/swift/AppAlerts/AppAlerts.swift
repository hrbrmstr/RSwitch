//
//  AppAlerts.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/30/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

public class AppAlerts {
  // Show an informational alert
  public static func infoAlert(_ message: String, _ extra: String? = nil, style: NSAlert.Style = NSAlert.Style.informational) {
    let alert = NSAlert()
    alert.messageText = message
    if extra != nil { alert.informativeText = extra! }
    alert.alertStyle = style
    alert.runModal()
  }

  // Show an informational alert and then quit
  public static func quitAlert(_ message: String, _ extra: String? = nil) {
    infoAlert(message, "The application will now quit.", style: NSAlert.Style.critical)
    NSApp.terminate(nil)
  }
}
