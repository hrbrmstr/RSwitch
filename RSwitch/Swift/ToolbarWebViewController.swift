//
//  ToolbarWebViewController.swift
//  wktest
//
//  Created by hrbrmstr on 9/9/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa

class ToolbarWebViewController: NSWindowController {

  @IBOutlet weak var nicknname: NSTextField!
  @IBOutlet weak var url: NSTextField!
  @IBOutlet weak var deleteSession: NSButton!

  @IBAction func performDeleteSession(_ sender: Any) {
    
    let appDelegate = NSApp.delegate as! AppDelegate
    appDelegate.sess.deleteSession(title: nicknname.stringValue)
    
    super.close()
    
  }
  
  override func windowWillLoad() {
    super.windowWillLoad()
    shouldCascadeWindows = false
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
  }
  
  override func showWindow(_ sender: Any?) {
    super.showWindow(sender)
    window?.setFrameAutosaveName(nicknname.stringValue)
  }

}
