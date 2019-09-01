//
//  HandleUpdate.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
  
  @objc func checkForUpdate(_ sender: NSMenuItem?) {
    
    let url = URL(string: app_urls.version_check)
    
    do {
      URLCache.shared.removeAllCachedResponses()
      var version = try String.init(contentsOf: url!)
      version = version.trimmingCharacters(in: .whitespacesAndNewlines)
      if (version.isVersion(greaterThan: Bundle.main.releaseVersionNumber!)) {
        let url = URL(string: app_urls.releases)
        NSWorkspace.shared.open(url!)
      } else {
        self.notifyUser(title: "RSwitch", text: "You are running the latest version of RSwitch.")
      }
    } catch {
      self.notifyUser(title: "Action failed", subtitle: "Update check", text: "Error: \(error)")
    }

  }
  
}
