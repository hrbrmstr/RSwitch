//
//  plotPopupViewController.swift
//  wktest
//
//  Created by hrbrmstr on 9/9/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Cocoa
import WebKit

class plotPopupViewController: NSViewController {

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
    
    
    if let url = URL(string: urlPath) {
      
      let urlRequest = URLRequest(url: url)
      
      if (url.path.starts(with: "/export")) {
        
      } else {
        
        webView.load(urlRequest)

      }
    }
    
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
    
}

extension plotPopupViewController: WKUIDelegate {
  
  func webViewDidClose(_ webView: WKWebView) {
    self.view.window?.close()
  }
  
  
  func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
    
  }

}

extension plotPopupViewController: WKNavigationDelegate {
  
  open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {  }
  
}

