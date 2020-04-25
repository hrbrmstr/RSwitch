//
//  main.swift
//  rswitch-cmd
//
//  Created by boB Rudis on 4/25/20.
//  Copyright © 2020 Bob Rudis. All rights reserved.
//

import Foundation
import ArgumentParser

final class StandardErrorOutputStream: TextOutputStream {
    func write(_ string: String) {
        FileHandle.standardError.write(Data(string.utf8))
    }
}

struct RSwitch: ParsableCommand {
  
  static var configuration = CommandConfiguration(
    abstract: "Switch R versions.",
    version: "1.0.0"
  )
  
  @Flag(name: .shortAndLong, help: "List R versions.")
  var list: Bool
  
  @Argument(help: "The R version to switch to.")
  var rversion: String?
  
  func run() throws {
    
    var outputStream = StandardErrorOutputStream()

    let targetPath = RVersions.currentVersionTarget()
    let versions = try RVersions.reloadVersions()

    if (list || (rversion == nil)) {
      
      for version in versions {
        let complete = RVersions.hasRBinary(versionPath: version)
        var v = version
        if (version == targetPath) { v = v + " *" }
        if (!complete) { v = version + " (incomplete)" }
        print(v)
      }
      
    } else {
      
      if (!versions.contains(rversion!)) {
        print("R version " + rversion! + " not found.", to: &outputStream)
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

