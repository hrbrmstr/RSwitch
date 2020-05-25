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
  
  NSLog("download from rstudio server")
    
  let rsURL = URL(string: fromRS)!
  let fsURL = URL(string: toFS)!
  
  URLSession.shared.configuration.timeoutIntervalForRequest = 300.0
  
  //URLSession.shared.downloadTask(with: <#T##URLRequest#>)

  
  let task = URLSession.shared.downloadTask(with: rsURL) {
    localURL, urlResponse, error in
    
    if (error != nil) {
      
       NSLog("dler \(String(describing: error))")

    } else {
    
      if let localURL = localURL {
        
        NSLog("We've got the data");
        
        if (FileManager.default.fileExists(atPath: fsURL.path)) {
          
          NSLog("Deleting old file")
          do {
            try FileManager.default.removeItem(at: fsURL)
          } catch {
            NSLog("error deleting old file")
          }
          
        }
        
        do {
          NSLog("Trying to move the data from \(localURL) to \(fsURL)");
          try FileManager.default.moveItem(at: localURL, to: fsURL)
          NSWorkspace.shared.openFile(
            fsURL.deletingLastPathComponent().absoluteString, withApplication: "Finder"
          )
          NSWorkspace.shared.activateFileViewerSelecting([fsURL])
        } catch {
          NSLog("Move Error \(error)")
        }
        
      }
      
    }
    
  }
  
  task.resume()
}

