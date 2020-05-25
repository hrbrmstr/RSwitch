//
//  DownloadFromRStudioServer.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

func download_from_studio_server(fromRS : String, toFS : String) {
    
  let rsURL = URL(string: fromRS)!
  let fsURL = URL(string: toFS)!
  
  URLSession.shared.configuration.timeoutIntervalForRequest = 300.0
  
  
  let task = URLSession.shared.downloadTask(with: rsURL) {
    localURL, urlResponse, error in
    
    if (error != nil) {
      
       NSLog("Error exporting from RStudio Server; \(String(describing: error))")

    } else {
    
      if let localURL = localURL {
        
        if (FileManager.default.fileExists(atPath: fsURL.path)) {
          
          do {
            try FileManager.default.removeItem(at: fsURL)
          } catch {
            NSLog("Error removing file during RStudio Server export; \(error)")
          }
          
        }
        
        do {
          try FileManager.default.moveItem(at: localURL, to: fsURL)
          NSWorkspace.shared.openFile(fsURL.deletingLastPathComponent().absoluteString, withApplication: "Finder")
          NSWorkspace.shared.activateFileViewerSelecting([fsURL])
        } catch {
          NSLog("Error moving RStudio Server export file; \(error)")
        }
        
      }
      
    }
    
  }
  
  task.resume()
}

