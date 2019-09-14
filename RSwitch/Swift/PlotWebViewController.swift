//
//  PlotWebViewController.swift
//  wktest
//
//  Created by hrbrmstr on 9/9/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa

class PlotWebViewController: NSWindowController {

  override func windowDidLoad() {
    
    shouldCascadeWindows = false
    window?.setFrameAutosaveName(window!.title)
    
    super.windowDidLoad()
    
  }

}
