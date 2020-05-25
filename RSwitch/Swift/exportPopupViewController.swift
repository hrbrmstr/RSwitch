//
//  exportPopupViewController.swift
//  RSwitch
//
//  Created by hrbrmstr on 5/24/20.
//  Copyright © 2020 Bob Rudis. All rights reserved.
//

import Cocoa
import WebKit

// EXPORT

class exportPopupViewController: NSViewController {

  var webView: WKWebView!
  var urlPath: String = ""
  
  open override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func setupWebView(configuration: WKWebViewConfiguration) {
    
    webView = WKWebView(frame: view.bounds, configuration: configuration)
    webView.autoresizingMask = [.width, .height]
    webView.uiDelegate = self
    webView.navigationDelegate = self
    
    view.addSubview(webView)
    
  }

  func loadWebView(urlIn: String) {
    
    urlPath = urlIn
    
    NSLog("loadWebView: \(urlPath)")
    
    // Check for "/export/"
    // If export, then get bring up a Save Panel and then download the file to that location

    if let url = URL(string: urlPath) {
      
      NSLog("URL path: \(url.path)")
      
      if (url.path.starts(with: "/export")) {
        
        NSLog("  Name: " + url.queryParameters["name"]!)
        
        let savePanel = NSSavePanel()
        
        savePanel.canCreateDirectories = true
        savePanel.nameFieldStringValue = url.queryParameters["name"]!
        savePanel.beginSheetModal(for:self.view.window!) { (response) in
          if (response == NSApplication.ModalResponse.OK) {
                        
            download_from_studio_server(fromRS: url.absoluteString, toFS: savePanel.url!.absoluteString)
            
          } else {
            
            NSLog("Don't do anything!")
          }
          savePanel.close()
        }

        
      }
      
    }
    
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
    
}

extension exportPopupViewController: WKUIDelegate {
  
  func webViewDidClose(_ webView: WKWebView) {
    self.view.window?.close()
  }
  

}

extension exportPopupViewController: WKNavigationDelegate {
  
  open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    print("Export DID START \(String(describing: webView.url))")
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("Export DID FINISH \(String(describing: webView.url))")
  }
  
}

