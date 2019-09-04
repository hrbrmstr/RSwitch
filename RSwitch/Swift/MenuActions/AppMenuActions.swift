//
//  App.swift
//  RSwitch
//
//  Created by boB Rudis on 9/3/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
  
  @objc func launchFromMenu(_ sender: NSMenuItem) {
    (sender.representedObject as! AppMenuAction).launch()
  }
  
}

class AppMenuAction {
  
  private var name : String
  private var bundleId : String
  private var title : String
  private var selector : Selector
  private var keyEquivalent : String
  
  private static let appItems = [
    AppMenuAction(name: "RStudio.app", bundleId: "org.rstudio.RStudio", title: "Launch RStudio"),
    AppMenuAction(name: "R.app", bundleId: "org.R-project.R", title: "Launch R GUI")
  ]
  
  init(name : String, bundleId : String, title : String, selector: String = "launchFromMenu", keyEquivalent: String = "") {
    self.name = name
    self.bundleId = bundleId
    self.title = title
    self.selector = Selector((selector+":"))
    self.keyEquivalent = keyEquivalent

  }
  
  public func asMenuItem() -> NSMenuItem {
    let mi = NSMenuItem(title: title + (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control) ? " (new instance)" : ""), action: selector, keyEquivalent: keyEquivalent)
    mi.representedObject = self
    return(mi)
  }
  
  public func launch() {
    if (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control)) {
      NSWorkspace.shared.launchApplication(withBundleIdentifier: bundleId, options: NSWorkspace.LaunchOptions.newInstance, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    } else {
      NSWorkspace.shared.launchApplication(name)
    }
  }
  
  public static func populateLaunchers(menu : NSMenu) {
    menu.addItem(NSMenuItem.separator())
    for item in appItems { menu.addItem(item.asMenuItem()) }
  }
  
}
