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

  var sessions : [ RStudioServerSession ]?
  
  init() {
    loadSessions()
  }
  
  func newSession(url: String, title: String) {
    let s = RStudioServerSession(url: url, title: title)
    sessions!.append(s)
    saveSessions()
    s.show()
  }
  
  func deleteSession(title: String) {
    sessions = sessions!.filter { $0.menuTitle != title }
    saveSessions()
  }

  func saveSessions() {
    let sessionsData = try! JSONEncoder().encode(sessions)
    UserDefaults.standard.set(sessionsData, forKey: "rstudioServerSessions")
  }
  
  func loadSessions() {
    let sessionsData = UserDefaults.standard.data(forKey: "rstudioServerSessions")
    if (sessionsData != nil) {
      sessions = try! JSONDecoder().decode([RStudioServerSession].self, from: sessionsData!)
    } else {
      sessions = [ RStudioServerSession ]()
    }
  }
    
}
