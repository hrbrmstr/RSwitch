//
// The main app delegate b/c AppKit isn't smart enough to deal with status bar apps yet
//

// ~/Library/Preferences/is.rud.rswitch.plist

import Cocoa
import SwiftUI
import UserNotifications

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  
  var popover = NSPopover.init()
  var statusBar: StatusBarController?
  var timer: Timer? = nil;
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error { debugPrint("\(error)") }
      DispatchQueue.main.async { Preferences.notificationsAllowed = granted }
    }
    
    let contentView = ContentView()
    
    popover.contentViewController = MainViewController()
    popover.contentSize = NSSize(width: 300, height: 200)
    popover.contentViewController?.view = NSHostingView(rootView: contentView)
    
    statusBar = StatusBarController.init(popover)
    
    URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
    
    timer = Timer.scheduledTimer(
      timeInterval: 3600,
      target: self,
      selector: #selector(performTimer),
      userInfo: nil,
      repeats: true
    )
    
    performTimer(nil)
    
  }
  
  func applicationWillFinishLaunching(_ aNotification: Notification) {
    if Preferences.firstRunGone == false { Preferences.firstRunGone = true }
    DockIcon.standard.setVisibility(Preferences.showDockIcon)
  }
  
  func applicationWillTerminate(_ aNotification: Notification) {
    timer?.invalidate()
  }
  
}

extension AppDelegate {
  
  static let targetSize = NSSize(width: 20.0, height: 20.0)
  static let rlogo = #imageLiteral(resourceName: "RLogo").resized(to: targetSize)
  
  @objc func performTimer(_ sender: Timer?) {
  }
  
}
