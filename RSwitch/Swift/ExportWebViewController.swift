//
//  ExportWebViewController.swift
//  RSwitch
//
//  Created by hrbrmstr on 5/24/20.
//  Copyright © 2020 Bob Rudis. All rights reserved.
//

import Cocoa

class ExportWebViewController: NSWindowController {

  override func windowDidLoad() {
    
    shouldCascadeWindows = false
    window?.setFrameAutosaveName(window!.title)
    
    super.windowDidLoad()
    
  }

}
