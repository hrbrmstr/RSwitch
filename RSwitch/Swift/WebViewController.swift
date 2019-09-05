//
//  WebViewController.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/5/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa
import WebKit

class WebViewController: NSViewController {

  @IBOutlet weak var rstudioServerView: WKWebView!
  
  var url = "https://rstudio.hrbrmstr.de/"
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    self.view.window?.title = url
    let request = URLRequest(url: URL(string: url)!)
    rstudioServerView.load(request)
  }
    
}
