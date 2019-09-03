//
//  AboutViewController.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa

extension AppDelegate {
  
  // Show about dialog
  @objc func about(_ sender: NSMenuItem?) { abtController.showWindow(self) }
  
  @objc
  func updateTimer(_ sender: Timer) {  print("timer fired") }

}

class AboutViewController: NSViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
}
