//
//  DownloadRStudio.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa
import SwiftSoup

extension AppDelegate {
  
  // Download latest rstudio daily build
  @objc func download_latest_rstudio(_ sender: NSMenuItem?) {
    
    self.rstudio_enabled = false

    let url = URL(string: app_urls.rstudio_dailies)
    
    do {
      
      let html = try String.init(contentsOf: url!)
      let document = try SwiftSoup.parse(html)
      
      let link = try document.select("td > a").first!
      let href = try link.attr("href")
      let dlurl = URL(string: href)!
      let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
      var dlfile = dldir
      
      dlfile.appendPathComponent(dlurl.lastPathComponent)
      
      print("RStudio href: " + href)
      
      if (FileManager.default.fileExists(atPath: dlfile.relativePath)) {
        
        self.notifyUser(title: "Action required", subtitle: "RStudio Download", text: "A local copy of the latest RStudio daily already exists. Please remove or rename it if you wish to re-download it.")
        
        NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
        NSWorkspace.shared.activateFileViewerSelecting([dlfile])

        self.rstudio_enabled = true
        
      } else {
        
        print("Timeout value: ", URLSession.shared.configuration.timeoutIntervalForRequest)
        
        let task = URLSession.shared.downloadTask(with: dlurl) {
          tempURL, response, error in
          
          if (error != nil) {
            self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error: " + error!.localizedDescription)
          } else if (response != nil) {
            
            let status = (response as? HTTPURLResponse)!.statusCode
            if (status < 300) {
              
              guard let fileURL = tempURL else {
                DispatchQueue.main.async { [weak self] in  self?.rstudio_enabled = true }
                return
              }
              
              do {
                try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                try FileManager.default.moveItem(at: fileURL, to: dlfile)
                self.notifyUser(title: "Success", subtitle: "RStudio Download", text: "Download of latest RStudio daily (" + dlurl.lastPathComponent + ") successful.")
                NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
                NSWorkspace.shared.activateFileViewerSelecting([dlfile])
              } catch {
                self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error: \(error)")
              }
              
            } else {
              self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error downloading latest RStudio daily. Status code: " + String(status))

            }
          }
          
          DispatchQueue.main.async { [weak self] in self?.rstudio_enabled = true }
          
        }
        
        task.resume()
      }
      
    } catch {
      self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error downloading and saving latest RStudio daily.")
    }
    
  }
  
}
