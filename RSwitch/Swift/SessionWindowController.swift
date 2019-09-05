//
//  SessionWindowController.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa
import WebKit

class SessionWindowController: NSWindowController {
  
  let appDelegate = NSApplication.shared.delegate as! AppDelegate

  @IBOutlet weak var titleField: NSTextField!
  @IBOutlet weak var nickField: NSTextField!
  
  @IBAction func deletePressed(_ sender: Any) {
    
    appDelegate.sess.deleteSession(title: nickField.stringValue)
    self.window?.windowController = nil
    self.window?.close()
    
  }
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  }

}
