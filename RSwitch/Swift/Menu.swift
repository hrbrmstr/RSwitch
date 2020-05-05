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
  
  @objc func toggle_hourly_rstudio_check(_ sender: NSMenuItem) {
  
    Preferences.hourlyRStudioCheck = !Preferences.hourlyRStudioCheck
    
    if (Preferences.hourlyRStudioCheck) { performRStudioCheck(sender) }
    
    if let menu = statusItem.menu, let item = menu.item(withTag: 98) {
      item.state = Preferences.hourlyRStudioCheck.stateValue
    }
    
  }
  
  @objc func toggle_ensure_file_handlers(_ sender: NSMenuItem) {
    
    Preferences.ensureFileHandlers = !Preferences.ensureFileHandlers
      
    if (Preferences.ensureFileHandlers) { FileAssociationUtils.setHandlers()  }
      
    if let menu = statusItem.menu, let item = menu.item(withTag: 98) {
      item.state = Preferences.ensureFileHandlers.stateValue
    }
    
  }

  @objc func subscribeToMailingList(_ sender: NSMenuItem) {
    NSWorkspace.shared.open(URL(string: "https://lists.sr.ht/~hrbrmstr/rswitch")!)
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

    let refsDropdown = NSMenuItem(title: "Reference Desk", action: nil, keyEquivalent: "")
    let refsSub = NSMenu()
    menu.addItem(refsDropdown)
    menu.setSubmenu(refsSub, for: refsDropdown)

    // Add items to open various R for macOS pages
    BrowseMenuAction.populateWebItems(menu: refsSub)

    menu.addItem(NSMenuItem.separator())

    // Add links to local copies of the R Manuals
    BrowseMenuAction.populateLocalRManualsItems(menu: refsSub)
    
    // Add links to free R online books
    BrowseMenuAction.populateRBooksItems(menu: refsSub)
    
    // Add running apps
    populateRunningApps(menu: menu)
    
    // Add launchers
    AppMenuAction.populateLaunchers(menu: menu)
    
    RStudioServerMenuAction.populateRStudioServerSessions(menu: menu, manager: sess)
    
    menu.addItem(NSMenuItem.separator())
      
    // Toggle Dock Icon
    menu.addItem(NSMenuItem.separator())
    
    let prefsDropdown = NSMenuItem(title: "Preferences", action: nil, keyEquivalent: "")
    let prefSub = NSMenu()
    
    menu.addItem(prefsDropdown)
    menu.setSubmenu(prefSub, for: prefsDropdown)
    
    let dockItem = NSMenuItem(title: "Show Dock Icon", action: #selector(toggle_dock_icon), keyEquivalent: "")
    dockItem.tag = 99
    dockItem.target = self
    dockItem.state = Preferences.showDockIcon.stateValue
    prefSub.addItem(dockItem)

    let rstudioCheckItem = NSMenuItem(title: "Notify me when a new RStudio Daily is available", action: #selector(toggle_hourly_rstudio_check), keyEquivalent: "")
    rstudioCheckItem.tag = 98
    rstudioCheckItem.target = self
    rstudioCheckItem.state = Preferences.hourlyRStudioCheck.stateValue
    prefSub.addItem(rstudioCheckItem)
    
    let fileHandlersCheckItem = NSMenuItem(title: "Ensure RStudio opens R/Rmd files", action: #selector(toggle_ensure_file_handlers), keyEquivalent: "")
    fileHandlersCheckItem.tag = 97
    fileHandlersCheckItem.target = self
    fileHandlersCheckItem.state = Preferences.ensureFileHandlers.stateValue
    prefSub.addItem(fileHandlersCheckItem)

    menu.addItem(NSMenuItem(title: "Check for update…", action: #selector(checkForUpdate), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "Subscribe to mailing list…", action: #selector(subscribeToMailingList), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "About RSwitch…", action: #selector(showAbout), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: "RSwitch Help…", action: #selector(rswitch_help), keyEquivalent: ""))

    // Add a Quit item
    menu.addItem(NSMenuItem.separator())
    let quitItem = NSMenuItem(title: "Quit", action: #selector(NSApp.terminate), keyEquivalent: "q")
    quitItem.keyEquivalentModifierMask = NSEvent.ModifierFlags.option
    menu.addItem(quitItem)
    
  }
  
}
