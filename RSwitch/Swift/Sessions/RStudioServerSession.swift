//
//  RStudioServerSession.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

class RStudioServerSession : Codable {
  
  var url : String
  var menuTitle : String
  var wk : NSWindowController?
  var wv : WebViewController?
  
  private enum CodingKeys: String, CodingKey {
    case url
    case menuTitle
  }
  
  init(url: String, title: String) {
    self.url = url
    self.menuTitle = title
    self.wk = nil
    self.wv = nil
  }
  
  func show() {
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    let mainStoryboard = appDelegate.mainStoryboard!
    
    if (wk == nil) {
      print("wk was nil")
      wk = (mainStoryboard.instantiateController(withIdentifier: "wkPanelController") as! NSWindowController)
      wv = wk!.window?.contentViewController as? WebViewController
      wv!.url = url
    }
    
    wk?.window?.orderFront(appDelegate)
    wk?.showWindow(appDelegate)
    
    NSApp.activate(ignoringOtherApps: true)

  }
  
}
