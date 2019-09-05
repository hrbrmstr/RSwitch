//
//  RStudioServerSessionManager.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class RStudioServerSessionManager {

  var sessions = [ RStudioServerSession ]()
  
  func newSession(url: String, title: String) {
    sessions.append(RStudioServerSession(url: url, title: title))
  }
  
  func debugSessions() {
    
    for s in sessions {
      print(s.menuTitle)
    }
    
  }
  
}
