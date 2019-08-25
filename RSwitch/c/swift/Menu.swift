//
//  Menu.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate: NSMenuDelegate {
  
  func menuWillOpen(_ menu: NSMenu) {
    
    if (menu != self.statusMenu) { return }
    
    // clear the menu
    menu.removeAllItems()
    
    // add selection to open frameworks dir in Finder
    menu.addItem(NSMenuItem(title: "Open R Frameworks Directory", action: #selector(openFrameworksDir), keyEquivalent: ""))
    menu.addItem(NSMenuItem.separator())

    menu.addItem(NSMenuItem(title: "Current R Version:", action: nil, keyEquivalent: ""))
    
    // populate installed versions
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
          let item = NSMenuItem(title: version, action: #selector(handleSwitch), keyEquivalent: keynum)
          item.isEnabled = true
          if (version == targetPath) { item.state = NSControl.StateValue.on }
          item.representedObject = version
          menu.addItem(item)
          i = i + 1
        }

      }
        
    } catch {
      quitAlert("Failed to list contents of R framework directory. You either do not have R installed or have incorrect permissions set on " + app_dirs.macos_r_framework)
    }

    // Add items to download latest r-devel tarball and latest macOS daily
    menu.addItem(NSMenuItem.separator())
    
    let rdevelItem = NSMenuItem(title: NSLocalizedString("Download latest R-devel tarball", comment: "Download latest tarball item"), action: self.rdevel_enabled ? #selector(download_latest_tarball) : nil, keyEquivalent: "")
    rdevelItem.isEnabled = self.rdevel_enabled
    menu.addItem(rdevelItem)
    
    let rstudioItem = NSMenuItem(title: NSLocalizedString("Download latest RStudio daily build", comment: "Download latest RStudio item"), action: self.rstudio_enabled ? #selector(download_latest_rstudio) : nil, keyEquivalent: "")
    rstudioItem.isEnabled = self.rstudio_enabled
    menu.addItem(rstudioItem)
    
    // Add items to open variosu R for macOS pages
    
    menu.addItem(NSMenuItem.separator())

    let webDropdown = NSMenuItem(title: "Web resources", action: nil, keyEquivalent: "")
    let webSub = NSMenu()
    
    menu.addItem(webDropdown)
    menu.setSubmenu(webSub, for: webDropdown)
    
    webSub.addItem(NSMenuItem(title: NSLocalizedString("R for macOS Developers…", comment: "macOS Dev Page item"), action: #selector(browse_r_macos_dev_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem(title: NSLocalizedString("R for macOS CRAN…", comment: "macOS CRAN Page item"), action: #selector(browse_r_macos_cran_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem(title: NSLocalizedString("R-SIG-Mac Archives…", comment: "R-SIG-Mac Page item"), action: #selector(browse_r_sig_mac_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem(title: NSLocalizedString("R-devel News…", comment: "R-devel News Page item"), action: #selector(browse_r_devel_news_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem(title: NSLocalizedString("R Installation/Admin macOS Section…", comment: "R Install Page item"), action: #selector(browse_r_admin_macos_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem.separator())
    webSub.addItem(NSMenuItem(title: NSLocalizedString("RStudio macOS Dailies…", comment: "RStudio macOS Dailies Page item"), action: #selector(browse_rstudio_mac_dailies_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem(title: NSLocalizedString("R StackOverflow…", comment: "R StackOverflow Page item"), action: #selector(browse_r_stackoverflow_page), keyEquivalent: ""))
    webSub.addItem(NSMenuItem(title: NSLocalizedString("RStudio Community…", comment: "RStudio Community Page item"), action: #selector(browse_rstudio_community_page), keyEquivalent: ""))

    let running_rstudios = NSWorkspace.shared.runningApplications.filter {
      $0.bundleIdentifier == "org.rstudio.RStudio"
    }
    
    let  running_rapps = NSWorkspace.shared.runningApplications.filter {
      $0.bundleIdentifier == "org.R-project.R"
    }
    
    if ((running_rstudios.count) + (running_rapps.count) > 0) {
    
      menu.addItem(NSMenuItem.separator())

      let switchToDropdown = NSMenuItem(title: "Switch to", action: nil, keyEquivalent: "")
      let switchToSub = NSMenu()
      
      menu.addItem(switchToDropdown)
      menu.setSubmenu(switchToSub, for: switchToDropdown)
      
      for app in running_rstudios + running_rapps {
        let args = getArgs(app.processIdentifier)!
        let title = app.localizedName! + (args.count > 1 ? " : " + (args[1] as! NSString).lastPathComponent.replacingOccurrences(of: ".Rproj", with: "") : "")
        let mi = NSMenuItem(title: title, action: #selector(switch_to), keyEquivalent: "")
        
        mi.representedObject = app
        switchToSub.addItem(mi)
      }
      
    }
    
    // Add launchers
    menu.addItem(NSMenuItem.separator())
    
    let launch_r = "Launch R GUI" + (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control) ? " (new instance)" : "")
    let launch_rstudio = "Launch RStudio" + (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control) ? " (new instance)" : "")
    
    menu.addItem(NSMenuItem(title: NSLocalizedString(launch_r, comment: "Launch R GUI item"), action: #selector(launchRApp), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString(launch_rstudio, comment: "Launch RStudio item"), action: #selector(launchRStudio), keyEquivalent: ""))
    
    // Add a About item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("Check for update…", comment: "Check for update item"), action: #selector(checkForUpdate), keyEquivalent: ""))

    // Add a About item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("About RSwitch…", comment: "About menu item"), action: #selector(about), keyEquivalent: ""))

    // Add a Quit item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(quitItem)
    
  }
  
}
