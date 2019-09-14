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
  var wk : ToolbarWebViewController?
  var wv : RstudioServerSessionWebViewController?
  
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
    
    if (wk == nil) {
      
      wk = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "windowWithWkViewAndToolbar") as? ToolbarWebViewController
          
      wk?.nicknname.stringValue = menuTitle
      wk?.url.stringValue = url
      
      wv = (wk?.contentViewController as! RstudioServerSessionWebViewController)

    }

    wk?.showWindow(self)
    wv?.loadWebView(urlIn: url)
    
    NSApp.activate(ignoringOtherApps: true)

  }
  
}
