//
//  NewSessionViewController.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa

extension String {
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}

class NewSessionViewController: NSViewController {
  
  let appDelegate = NSApplication.shared.delegate as! AppDelegate

  @IBOutlet weak var nickname: NSTextField!
  @IBOutlet weak var serverURL: NSTextField!
  
  @IBOutlet weak var okButton: NSButton!
  
  @IBAction func okPressed(_ sender: Any) {
    appDelegate.sess.newSession(url: serverURL.stringValue, title: nickname.stringValue)
    self.view.window?.windowController?.close()
  }
  
  @IBAction func cancelPressed(_ sender: Any) {
    self.view.window?.windowController?.close()
  }

  override func viewWillAppear() {
    
    nickname.stringValue = ""
    serverURL.stringValue = "https://"
    
    super.viewDidAppear()
    
  }
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
  
    nickname.delegate = self
    serverURL.delegate = self
    
    okButton.isEnabled = false
    // Do view setup here.
  }
    
}

extension NewSessionViewController : NSTextFieldDelegate {
  
  func controlTextDidEndEditing(_ notification: Notification) {

    let nick = nickname.stringValue
    let sURL = serverURL.stringValue
    
    let currNames = appDelegate.sess.sessions!.map {
      $0.menuTitle
    }
        
    let nickUnique = !(currNames.firstIndex(of: nick) != nil)
    
    okButton.isEnabled = ((nick.count > 0) && nickUnique && sURL.isValidURL)
  }

}

