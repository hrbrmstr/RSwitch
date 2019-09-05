//
//  WebViewController.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController, NSTextFieldDelegate {

  @IBOutlet weak var rstudioServerView: WKWebView!
  
  var url = ""
  var nickname = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear() {
    
    super.viewDidAppear()
    self.view.window?.title = url
    
    let wc = self.view.window?.windowController as! SessionWindowController
    
    wc.titleField.stringValue = url
    wc.nickField.stringValue = nickname
    
    rstudioServerView.configuration.preferences.javaScriptEnabled = true
    rstudioServerView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
    
    let request = URLRequest(url: URL(string: url)!)
    rstudioServerView.load(request)
    
  }
  
  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
    
}
