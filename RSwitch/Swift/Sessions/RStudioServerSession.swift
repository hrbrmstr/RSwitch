//
//  RStudioServerSession.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

class RStudioServerSession {
  
  var url : String
  var menuTitle : String
  var wk : NSWindowController?
  var wv : WebViewController?
  
  init(url: String, title: String) {
    self.url = url
    self.menuTitle = title
  }
  
  func show() {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let mainStoryboard = appDelegate.mainStoryboard!
    
    if (wk == nil) {
      wk = (mainStoryboard.instantiateController(withIdentifier: "wkPanelController") as! NSWindowController)
      wv = wk!.window?.contentViewController as? WebViewController
      wv!.url = url
    }
    
    wk?.window?.orderFront(appDelegate)
    wk?.showWindow(appDelegate)
    wk?.window?.orderFront(appDelegate)
    
    NSApp.activate(ignoringOtherApps: true)

  }
  
}
