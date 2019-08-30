//
//  VersionsUtils.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/30/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
    
  // Show the framework dir in a new Finder window
  @objc func openFrameworksDir(_ sender: NSMenuItem?) {
    NSWorkspace.shared.openFile(app_dirs.macos_r_framework, withApplication: "Finder")
  }

  func populateRVersionsMenu(menu : NSMenu) {
    
    let fm = FileManager.default
    var targetPath:String? = nil

    do {
      
      // gets a directory listing
      let entries = try fm.contentsOfDirectory(atPath: app_dirs.macos_r_framework)
      
      // retrieves all versions (excludes hidden files and the Current alias
      let versions = entries.sorted().filter { !($0.hasPrefix(".")) && !($0 == "Current") }
      let hasCurrent = entries.filter { $0 == "Current" }
      
      // if there was a Current alias (prbly shld alert if not)
      if (hasCurrent.count > 0) {
      
        // get where Current points to
        let furl = NSURL(fileURLWithPath: app_dirs.macos_r_framework + "/" + "Current")
        
        if (furl.fileReferenceURL() != nil) {
          do {
            let fdat = try NSURL(resolvingAliasFileAt: furl as URL, options: [])
            targetPath = fdat.lastPathComponent!
          } catch {
            targetPath = furl.path
          }
        }

        // populate menu items with all installed R versions, ensuring we
        // put a checkbox next to the one that is Current
        var i = 1
        for version in versions {
          let keynum = (i < 10) ? String(i) : ""
          let item = NSMenuItem(title: version, action: #selector(handleRSwitch), keyEquivalent: keynum)
          item.isEnabled = true
          if (version == targetPath) { item.state = NSControl.StateValue.on }
          item.representedObject = version
          menu.addItem(item)
          i = i + 1
        }

      }
        
    } catch {
      AppAlerts.quitAlert("Failed to list contents of R framework directory. You either do not have R installed or have incorrect permissions set on " + app_dirs.macos_r_framework)
    }
    
  }
  
  func populateRunningApps(menu : NSMenu) {
    
    // gather running RStudio instances
    let running_rstudios = NSWorkspace.shared.runningApplications.filter {
      $0.bundleIdentifier == bundleIds.rstudio
    }
    
    // gather running R GUI instances
    let  running_rapps = NSWorkspace.shared.runningApplications.filter {
      $0.bundleIdentifier == bundleIds.r_base
    }
    
    // if we have any running instances of anything
    if ((running_rstudios.count) + (running_rapps.count) > 0) {
      
      menu.addItem(NSMenuItem.separator())

      let switchToDropdown = NSMenuItem(title: "Switch to", action: nil, keyEquivalent: "")
      let switchToSub = NSMenu()
      
      menu.addItem(switchToDropdown)
      menu.setSubmenu(switchToSub, for: switchToDropdown)
      
      // populate RStudio first (it'll be in launch order) then R GUI
      for app in running_rstudios + running_rapps {
        let args = getArgs(app.processIdentifier)!
        let title = app.localizedName! + (args.count > 1 ? " : " + (args[1] as! NSString).lastPathComponent.replacingOccurrences(of: ".Rproj", with: "") : "")
        let mi = NSMenuItem(title: title, action: #selector(switch_to), keyEquivalent: "")
        
        mi.representedObject = app
        switchToSub.addItem(mi)
      }
      
    }
    
  }

}
