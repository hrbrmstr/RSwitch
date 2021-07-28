//
//  main.swift
//  rswitch-cmd
//
//  Created by boB Rudis on 4/25/20.
//  Copyright © 2020 Bob Rudis. All rights reserved.
//

import Foundation
import ArgumentParser
import AppKit

final class StandardErrorOutputStream: TextOutputStream {
  func write(_ string: String) {
    FileHandle.standardError.write(Data(string.utf8))
  }
}

func downloadAndUnpack(source : String, what : String) -> Bool {
    
  let tarballURL = URL(string: source)!

  let done = DispatchSemaphore(value: 0)
  var err = true

  let task = URLSession.shared.downloadTask(with: tarballURL) {
    fileURL, response, error in
    
    if (error != nil) {
      print("Error downloading \(what) \(String(describing: error))")
    } else if (response != nil) {
      
      let status = (response as? HTTPURLResponse)!.statusCode
      
      if (status < 300) {
        
        if (!(fileURL == nil) || (fileURL?.absoluteString != "")) {
                    
          print("Installing \(what)")
          
          do {
            let _ = try exec(program: "/usr/bin/tar", arguments: ["xzf", fileURL!.path, "-C", "/"])
            try FileManager.default.removeItem(at: fileURL!)
            err = false
          } catch {
            do {
              try FileManager.default.removeItem(at: fileURL!)
              err = false
            } catch {
              print("Error removing \(what) at: \(fileURL?.absoluteString ?? "")")
            }
          }

        } else {
          print("Error downloading \(what) \(String(describing: error))")
        }
        
      }
      
    }
    
    done.signal()
    
  }
  
  print("Starting download of \(what)")
  
  task.resume()
  done.wait()
  
  return(err)

}

func downloadMountAndCopyRStudio() -> Bool {
    
  let what = "RStudio Desktop Latest Daily"
  let source = "https://www.rstudio.org/download/latest/daily/desktop/mac/RStudio-latest.dmg"
  let rsURL = URL(string: source)!

  let done = DispatchSemaphore(value: 0)
  var err = true

  let task = URLSession.shared.downloadTask(with: rsURL) {
    fileURL, response, error in
    
    if (error != nil) {
      print("Error downloading \(what) \(String(describing: error))")
    } else if (response != nil) {
      
      let status = (response as? HTTPURLResponse)!.statusCode
      
      if (status < 300) {
        
        if (!(fileURL == nil) || (fileURL?.absoluteString != "")) {
                    
          print("Installing \(what)")
          
          do {
            
            let path = fileURL!.path
            let res = try exec(program: "/usr/bin/hdiutil", arguments: ["attach", "-plist", path])
            
            var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
            let x = try PropertyListSerialization.propertyList(from: (res.stdout?.data(using: String.Encoding.utf8))!, options: .mutableContainersAndLeaves, format: &propertyListFormat) as? [String : AnyObject]
            
            let y = x?["system-entities"] as? [Dictionary<String, AnyObject>]
            let vol = ((y?[0].keys.contains("mount-point"))! ? y?[0]["mount-point"] : y?[1]["mount-point"]) as? String ?? ""
            
            let user = ProcessInfo.processInfo.environment["SUDO_USER"] ?? ""
            
            let _ = try exec(program: "/bin/mv", arguments: ["/Applications/RStudio.app", "/Users/\(user)/.Trash"])
            let _ = try exec(program: "/bin/cp", arguments: ["-R", "\(vol)/RStudio.app", "/Applications"])
            let _ = try exec(program: "/usr/bin/hdiutil", arguments: ["detach", vol])
          
            err = false
            
          } catch {
             print("Error downloading/mounting/installing \(what) : \(error)")
          }

        } else {
          print("Error downloading/mounting/installing \(what) : \(String(describing: error))")
        }
        
      }
      
    }
    
    done.signal()
    
  }
  
  print("Starting download of \(what)")
  
  task.resume()
  done.wait()
  
  return(err)

}


struct RSwitch: ParsableCommand {
  
  static var configuration = CommandConfiguration(
    abstract: "Switch R versions.",
    version: "1.1.0"
  )
  
  @Option(name: .shortAndLong, help: "List R versions.")
  var list: Bool
  
  @Option(name: .long, help: "Install latest R-devel.")
  var installRDevel: Bool
  
  @Option(name: .long,  help: "Install R-release daily build.")
  var installR: Bool
  
  @Option(name: .long,  help: "Install latest RStudio Daily Build (Requires 'sudo'.")
  var installRStudio: Bool

  @Argument(help: "The R version to switch to.")
  var rversion: String?
    
  func run() throws {
    
    var outputStream = StandardErrorOutputStream()

    let targetPath = RVersions.currentVersionTarget()
    let versions = try RVersions.reloadVersions()
    
    if (installRDevel) {

      Darwin.exit(downloadAndUnpack(source: "https://mac.r-project.org/high-sierra/R-devel/x86_64/R-devel.tar.gz", what: "R-devel") ? 4 : 0)

    } else if (installR) {

      Darwin.exit(downloadAndUnpack(source: "https://mac.r-project.org/high-sierra/R-4.0-branch/x86_64/R-4.0-branch.tar.gz", what: "R-release") ? 5 : 0)
      
    } else if (installRStudio) {
      
      let sudo = !((ProcessInfo.processInfo.environment["SUDO_GID"] ?? "") == "")
      
      if (!sudo) {
        print("Installing RStudio requires elevated privileges. You must run this command with 'sudo'")
        Darwin.exit(6)
      }
      
      let running_rstudios = NSWorkspace.shared.runningApplications.filter {
        $0.bundleIdentifier == "org.rstudio.RStudio"
      }
      
      if (running_rstudios.count > 0) {
        print("Please close all running RStudio applications before attempting to update RStudio.")
        Darwin.exit(7)
      }
      
      Darwin.exit(downloadMountAndCopyRStudio() ? 8 : 0)
      
    } else if (list || (rversion == nil)) {
      
      for version in versions {
        let complete = RVersions.hasRBinary(versionPath: version)
        var v = version
        if (version == targetPath) { v = v + " *" }
        if (!complete) { v = version + " (incomplete)" }
        print(v)
      }
      
      Darwin.exit(0)
      
    } else {
      
      if (!versions.contains(rversion!)) {
        
        print("R version " + rversion! + " not found.", to: &outputStream)
        Darwin.exit(3)
        
      } else {
        
        if (rversion! == targetPath) {
          print("Current R version already points to " + targetPath)
        } else {
          
          let fm = FileManager.default
          let rm_link = (RVersions.macos_r_framework as NSString).appendingPathComponent("Current")
          let new_link = (RVersions.macos_r_framework as NSString).appendingPathComponent(rversion!)
          
          do {
            try fm.removeItem(atPath: rm_link)
          } catch {
            print("Failed to remove existing R version symlink. Check file/directory permissions.", to: &outputStream)
            Darwin.exit(1)
          }
          
          do {
            try fm.createSymbolicLink(
              at: NSURL(fileURLWithPath: rm_link) as URL,
              withDestinationURL: NSURL(fileURLWithPath: new_link) as URL
            )
          } catch {
            print("Failed to create a symlink to the chosen R version. Check file/directory permissions.", to: &outputStream)
            Darwin.exit(2)
          }
          
          Darwin.exit(0)
          
        }
        
      }
      
    }
    
  }
  
}

RSwitch.main()
