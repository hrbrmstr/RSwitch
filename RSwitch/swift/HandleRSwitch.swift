//
//  HandleRSwitch.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
  
  struct app_dirs {
    static let macos_r_framework = "/Library/Frameworks/R.framework/Versions" // Where the official R installs go
  }
  
  // The core worker function. Receives the basename of the selected directory
  // then removes the current alias and creates the new one.
  @objc func handleRSwitch(_ sender: NSMenuItem?) {
    
    let fm = FileManager.default;
    let title = sender?.title
    
    do {
      try fm.removeItem(atPath: app_dirs.macos_r_framework + "/" + "Current")
    } catch {
      self.notifyUser(title: "Action failed", text: "Failed to remove 'Current' alias" + app_dirs.macos_r_framework + "/" + "Current")
    }
    
    do {
      try fm.createSymbolicLink(
            at: NSURL(fileURLWithPath: app_dirs.macos_r_framework + "/" + "Current") as URL,
            withDestinationURL: NSURL(fileURLWithPath: app_dirs.macos_r_framework + "/" + title!) as URL
      )
      self.notifyUser(title: "Success", text: "Current R version switched to " + title!)
    } catch {
      self.notifyUser(title: "Action failed", text: "Failed to create alias for " + app_dirs.macos_r_framework + "/" + title! + " (\(error))")
    }
      
  }

}
