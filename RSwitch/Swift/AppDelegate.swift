//
//  AppDelegate.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa
import Just

class DeleteSessionViewController : NSViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSToolbarDelegate {

  @objc func showAbout(_ sender: NSMenuItem?) {
    abtController.showWindow(self)
    abtController.window?.orderFront(self)
    NSApp.activate(ignoringOtherApps: true)
  }
  
  @objc func performRStudioCheck(_ sender: NSObject) {
    if (currentReachabilityStatus != .notReachable) {
      let v = RStudioUtils.latestVersionNumber()
      if (!Preferences.lastVersionNotified.isVersion(equalTo: v)) {
        Preferences.lastVersionNotified = v
        notifyUserWithDL(title: "New RStudio Daily version available", text: ("Version: " + v))
      }
    }
  }
  
  @objc func performTimer(_ sender: Timer) {
    if (Preferences.hourlyRStudioCheck) { performRStudioCheck(sender) }
    if (Preferences.ensureFileHandlers) { FileAssociationUtils.setHandlers()  }
  }

  var mainStoryboard: NSStoryboard!
  var abtController: NSWindowController!
  var rsController: NSWindowController!
  var newSessController: NSWindowController!
  
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
    
    newSessController = (mainStoryboard.instantiateController(withIdentifier: "newSessPanel") as! NSWindowController)

    sess = RStudioServerSessionManager()
            
    if (Preferences.ensureFileHandlers) { FileAssociationUtils.setHandlers()  }

    timer = Timer.scheduledTimer(
        timeInterval: 3600,
        target: self,
        selector: #selector(performTimer),
        userInfo: nil,
        repeats: true
    )
    
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    sess.saveSessions()
  }

}
