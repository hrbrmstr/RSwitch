//
//  DownloadTarball.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

let tarballURL = "https://mac.r-project.org/el-capitan/R-devel/R-devel-el-capitan-sa-x86_64.tar.gz"
let tarballFile = NSString(string: tarballURL).lastPathComponent as String

extension AppDelegate {
  
  // Download latest r-devel tarball
  @objc func download_latest_tarball(_ sender: NSMenuItem?) {
    
    self.rdevel_enabled = false
    
    let dlurl = URL(string: tarballURL)!
    let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    var dlfile = dldir
    
    dlfile.appendPathComponent(tarballFile)
  
    if (FileManager.default.fileExists(atPath: dlfile.relativePath)) {
      
      self.notifyUser(title: "Action required", subtitle: "r-devel Download", text: "R-devel tarball already exists. Please remove or rename it before downloading.")
      
      NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
      NSWorkspace.shared.activateFileViewerSelecting([dlfile])
      
      self.rdevel_enabled = true
      
    } else {
      
      let task = URLSession.shared.downloadTask(with: dlurl) {
        tempURL, response, error in
        
        if (error != nil) {
          self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error: " + error!.localizedDescription)
        } else if (response != nil) {
          
          let status = (response as? HTTPURLResponse)!.statusCode
          if (status < 300) {
            
            guard let fileURL = tempURL else {
              DispatchQueue.main.async { [weak self] in  self?.rdevel_enabled = true }
              return
            }
            
            do {
              try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
              try FileManager.default.moveItem(at: fileURL, to: dlfile)
              self.notifyUser(title: "Success", subtitle: "r-devel Download", text: "Download of latest r-devel (" + dlurl.lastPathComponent + ") successful.")
              NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
              NSWorkspace.shared.activateFileViewerSelecting([dlfile])
            } catch {
              self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error: \(error)")
            }
            
          } else {
            self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error downloading latest r-devel. Status code: " + String(status))
          }
        }
        
        DispatchQueue.main.async { [weak self] in self?.rdevel_enabled = true }
        
      }
      
      task.resume()
    }
    
  }
  
}
