//
//  HandleSwitchTo.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/25/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation


import Foundation
import Cocoa

extension AppDelegate {
  
  @objc func switch_to(_ sender: NSMenuItem?) {
    (sender!.representedObject as! NSRunningApplication).activate(options: NSApplication.ActivationOptions.activateIgnoringOtherApps)
  }

}
