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
    RVersions.populateRVersionsMenu(menu: menu, handler: #selector(handleRSwitch))

    // Add items to download latest r-devel tarball and latest macOS daily
    menu.addItem(NSMenuItem.separator())
    
    let rdevelItem = NSMenuItem(title: NSLocalizedString("Download latest R-devel tarball", comment: "Download latest tarball item"), action: self.rdevel_enabled ? #selector(download_latest_tarball) : nil, keyEquivalent: "")
    rdevelItem.isEnabled = self.rdevel_enabled
    menu.addItem(rdevelItem)
    
    let rstudioItem = NSMenuItem(title: NSLocalizedString("Download latest RStudio daily build", comment: "Download latest RStudio item"), action: self.rstudio_enabled ? #selector(download_latest_rstudio) : nil, keyEquivalent: "")
    rstudioItem.isEnabled = self.rstudio_enabled
    menu.addItem(rstudioItem)
    
    // Add items to open variosu R for macOS pages
    BrowseMenuAction.populateWebItems(menu: menu)

    // Add running apps
    populateRunningApps(menu: menu)
    
    // Add launchers
    populateLaunchers(menu: menu)
    
    // Add a Check for update
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("Check for update…", comment: "Check for update item"), action: #selector(checkForUpdate), keyEquivalent: ""))

    // Add an About item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("About RSwitch…", comment: "About menu item"), action: #selector(about), keyEquivalent: ""))

    // Add a Quit item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q"))
    
  }
  
}
