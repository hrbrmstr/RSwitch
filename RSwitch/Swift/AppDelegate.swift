//
//  AppDelegate.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @objc func showAbout(_ sender: NSMenuItem?) {
    abtController.showWindow(self)
    abtController.window?.orderFront(self)
    NSApp.activate(ignoringOtherApps: true)
  }
  
  @objc func performTimer(_ sender: Timer) { print("timer fired") }

  var mainStoryboard: NSStoryboard!
  var abtController: NSWindowController!
  var rsController: NSWindowController!

  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let statusMenu = NSMenu(title: "RSwitch")

  var rdevel_enabled: Bool!
  var rstudio_enabled: Bool!
  var timer: Timer? = nil;
  
  var sess : RStudioServerSessionManager!

  override init() {
    
    super.init()
    
    statusMenu.delegate = self
    
    rdevel_enabled = true
    rstudio_enabled = true
    
    sess = RStudioServerSessionManager()
    sess.newSession(url: "https://rstudio.hrbrmstr.de", title: "One")
    sess.newSession(url: "https://rud.is/b", title: "Two")
    
    sess.debugSessions()
    
    URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
  }
  
  func applicationWillFinishLaunching(_ aNotification: Notification) {
    
    if Preferences.firstRunGone == false {
      Preferences.firstRunGone = true
      Preferences.restore()
    }

    DockIcon.standard.setVisibility(Preferences.showDockIcon)
    
  }

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    // dial by IconMark from the Noun Project
    statusItem.button?.image =  #imageLiteral(resourceName: "RSwitch")
    statusItem.menu = statusMenu
    
    mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
    
    abtController = (mainStoryboard.instantiateController(withIdentifier: "aboutPanelController") as! NSWindowController)
    
    timer = Timer.scheduledTimer(
        timeInterval: 3600,
        target: self,
        selector: #selector(performTimer),
        userInfo: nil,
        repeats: true
    )
    
  }
    
  func applicationWillTerminate(_ aNotification: Notification) { }

}
