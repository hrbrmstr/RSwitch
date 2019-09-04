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
  
  @objc func toggle_dock_icon(_ sender: NSMenuItem) {
  
    Preferences.showDockIcon = !Preferences.showDockIcon
    
    DockIcon.standard.setVisibility(Preferences.showDockIcon)
    
    if let menu = statusItem.menu, let item = menu.item(withTag: 99) {
      item.state = Preferences.showDockIcon.stateValue
    }
    
  }

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
    
    menu.addItem(NSMenuItem.separator())

    // Add items to open various R for macOS pages
    BrowseMenuAction.populateWebItems(menu: menu)

    menu.addItem(NSMenuItem.separator())

    // Add links to local copies of the R Manuals
    BrowseMenuAction.populateLocalRManualsItems(menu: menu)
    
    // Add links to free R online books
    BrowseMenuAction.populateRBooksItems(menu: menu)
    
    // Add running apps
    populateRunningApps(menu: menu)
    
    // Add launchers
    AppMenuAction.populateLaunchers(menu: menu)
    
    // Add a Check for update
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Check for update…", action: #selector(checkForUpdate), keyEquivalent: ""))

    // Add an About item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "About RSwitch…", action: #selector(about), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "RSwitch Help…", action: #selector(rswitch_help), keyEquivalent: ""))
      
    // Toggle Dock Icon
    menu.addItem(NSMenuItem.separator())
    let item = NSMenuItem(title: "Toggle Dock Icon", action: #selector(toggle_dock_icon), keyEquivalent: "")
    item.tag = 99
    item.target = self
    item.state = Preferences.showDockIcon.stateValue
    menu.addItem(item)

    // Add a Quit item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q"))
    
  }
  
}
