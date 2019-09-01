//
//  RUtils.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/1/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

struct versionInfo {
  var path : String
  var current: Bool
}

class RVersions {
  
  static let macos_r_framework = "/Library/Frameworks/R.framework/Versions" // Where the official R installs go

  static let replRegex = try!NSRegularExpression(pattern: "[[:alpha:][:space:]\"#_]+", options: NSRegularExpression.Options.caseInsensitive)
  
  static func currentVersionTarget() -> String {
        
    // get where Current points to
    let furl = NSURL(fileURLWithPath: RVersions.macos_r_framework + "/" + "Current")
    
    if (furl.fileReferenceURL() != nil) {
      do {
        let fdat = try NSURL(resolvingAliasFileAt: furl as URL, options: [])
        return(fdat.lastPathComponent!)
      } catch {
        return(furl.path!)
      }
    } else {
      return("")
    }

  }
  
  static func preciseVersion(versionPath : String) -> String {

    let actualPath = (versionPath.starts(with: "/") ? "" : RVersions.macos_r_framework + "/" ) +
    versionPath + "/Headers/Rversion.h"
    var out = ""
    
    if (FileManager.default.fileExists(atPath:actualPath)) {
     
        do {
          
          let versionHeader = (try NSString(contentsOfFile: actualPath, encoding: String.Encoding.utf8.rawValue)) as String

          let majMin = versionHeader
                .split(separator: "\n")
                .filter{
                  $0.contains("R_MAJOR") || $0.contains("R_MINOR")
                }
                .map{
                  replRegex.stringByReplacingMatches(in: String($0),
                                                     options: [],
                                                     range: NSMakeRange(0, $0.count),
                                                     withTemplate: "")
                }
          
          out = " (" + majMin[0] + "." + majMin[1] + ")"
                
      } catch {
      }

    }
    
    return(out)
    
  }
  
  static func hasRBinary(versionPath : String) -> Bool {
    return(
      FileManager.default.fileExists(
        atPath: (versionPath.starts(with: "/") ? "" : RVersions.macos_r_framework + "/" ) +
          versionPath + "/Resources/bin/R"
      )
    )
  }
  
  static func reloadVersions() throws -> [String] {
    
    // gets a directory listing
    let entries = try FileManager.default.contentsOfDirectory(atPath: RVersions.macos_r_framework)
    
    // retrieves all versions (excludes hidden files and the Current alias
    return(entries.sorted().filter { !($0.hasPrefix(".")) && !($0 == "Current") })
    
  }
  
  static func populateRVersionsMenu(menu : NSMenu, handler : Selector) {

    do {
      
      let targetPath = RVersions.currentVersionTarget()
      let versions = try RVersions.reloadVersions()
      
      // populate menu items with all installed R versions, ensuring we
      // put a checkbox next to the one that is Current
      
      var i = 1
      for version in versions {
        let complete = RVersions.hasRBinary(versionPath: version)
        let keynum = (i < 10) ? String(i) : ""
        let item = NSMenuItem(
          title: complete ? version + RVersions.preciseVersion(versionPath: version) : version + " (incomplete)",
          action: complete ? handler : nil,
          keyEquivalent: complete ? keynum : ""
        )
        item.isEnabled = complete
        if (version == targetPath) { item.state = NSControl.StateValue.on }
        item.representedObject = version
        menu.addItem(item)
        i = complete ? i + 1 : i
      }
        
    } catch {
      AppAlerts.quitAlert("Failed to list contents of R framework directory. You either do not have R installed or have incorrect permissions set on " + RVersions.macos_r_framework)
    }
    
  }
}

