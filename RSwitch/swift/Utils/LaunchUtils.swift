//
//  LaunchUtils.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/30/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {

  struct bundleIds {
    static let rstudio = "org.rstudio.RStudio"
    static let r_base = "org.R-project.R"
  }
  
  struct appNames {
    static let R = "R.app"
    static let RStudio = "RStudio.app"
  }
  
  // Launch R.app
  @objc func launchRApp(_ sender: NSMenuItem?) {
    if (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control)) {
      NSWorkspace.shared.launchApplication(withBundleIdentifier: bundleIds.r_base, options: NSWorkspace.LaunchOptions.newInstance, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    } else {
      NSWorkspace.shared.launchApplication(appNames.R)
    }
  }
  // Launch RStudio
  @objc func launchRStudio(_ sender: NSMenuItem?) {
    if (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control)) {
      NSWorkspace.shared.launchApplication(withBundleIdentifier: bundleIds.rstudio, options: NSWorkspace.LaunchOptions.newInstance, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    } else {
      NSWorkspace.shared.launchApplication(appNames.RStudio)
    }
  }

  func populateLaunchers(menu : NSMenu) {
    menu.addItem(NSMenuItem.separator())
    
    let launch_r = "Launch R GUI" + (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control) ? " (new instance)" : "")
    let launch_rstudio = "Launch RStudio" + (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control) ? " (new instance)" : "")
    
    menu.addItem(NSMenuItem(title: launch_r, action: #selector(launchRApp), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: launch_rstudio, action: #selector(launchRStudio), keyEquivalent: ""))
  }

}
