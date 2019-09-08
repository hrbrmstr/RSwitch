//
//  RStudioServerAction.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
  
  @objc func newRstudioServerSession(_ sender: NSMenuItem) {
      newSessController.showWindow(self)
      newSessController.window?.orderFront(self)
      NSApp.activate(ignoringOtherApps: true)
  }

  @objc func activateServerSession(_ sender: NSMenuItem) {
    let sess = (sender.representedObject as! RStudioServerSession)
    sess.show()
  }

}

class RStudioServerMenuAction {
  
  public static func populateRStudioServerSessions(menu: NSMenu, manager : RStudioServerSessionManager) {
    
    menu.addItem(NSMenuItem.separator())
    
    let rsDropdown = NSMenuItem(title: "RStudio Server Sessions", action: nil, keyEquivalent: "")
    let rsSub = NSMenu()
    
    menu.addItem(rsDropdown)
    menu.setSubmenu(rsSub, for: rsDropdown)
    
    let newRStudioSessItem = NSMenuItem(title: "New RStudio Server Connection…", action: Selector(("newRstudioServerSession:")), keyEquivalent: "")
    
    rsSub.addItem(newRStudioSessItem)
    rsSub.addItem(NSMenuItem.separator())
    
    for sess in manager.sessions! {
      
      let sessItem = NSMenuItem(title: sess.menuTitle, action: Selector(("activateServerSession:")), keyEquivalent: "")
      sessItem.representedObject = sess
      rsSub.addItem(sessItem)
      
    }
    
  }
  
}
