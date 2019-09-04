//
//  VersionsUtils.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/30/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
  
  // Show about dialog
  @objc func about(_ sender: NSMenuItem?) { abtController.showWindow(self) }
  
  @objc func updateTimer(_ sender: Timer) {  print("timer fired") }
  
  // Show the framework dir in a new Finder window
  @objc func openFrameworksDir(_ sender: NSMenuItem?) {
    NSWorkspace.shared.openFile(RVersions.macos_r_framework, withApplication: "Finder")
  }
  
  func populateRunningApps(menu : NSMenu) {
    
    // gather running RStudio instances
    let running_rstudios = NSWorkspace.shared.runningApplications.filter {
      $0.bundleIdentifier == "org.rstudio.RStudio"
    }
    
    // gather running R GUI instances
    let running_rapps = NSWorkspace.shared.runningApplications.filter {
      $0.bundleIdentifier == "org.R-project.R"
    }
    
    // if we have any running instances of anything
    if ((running_rstudios.count) + (running_rapps.count) > 0) {
      
      menu.addItem(NSMenuItem.separator())

      let switchToDropdown = NSMenuItem(title: "Switch to", action: nil, keyEquivalent: "")
      let switchToSub = NSMenu()
      
      menu.addItem(switchToDropdown)
      menu.setSubmenu(switchToSub, for: switchToDropdown)
      
      // populate RStudio first (it'll be in launch order) then R GUI
      for app in running_rstudios + running_rapps {
        let args = getArgs(app.processIdentifier)!
        let title = app.localizedName! + (args.count > 1 ? " : " + (args[1] as! NSString).lastPathComponent.replacingOccurrences(of: ".Rproj", with: "") : "")
        let mi = NSMenuItem(title: title, action: #selector(switch_to), keyEquivalent: "")
        mi.representedObject = app
        switchToSub.addItem(mi)
      }
      
    }
    
  }

}
