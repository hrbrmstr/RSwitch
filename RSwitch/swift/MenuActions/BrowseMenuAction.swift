//
//  MenuAction.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/30/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {
  
  @objc func browseFromMenu(_ sender: NSMenuItem) {
    let url = (sender.representedObject as! BrowseMenuAction).url
    NSWorkspace.shared.open(url)
  }
  
}

class BrowseMenuAction {
  
  public var title : String
  public var selector : Selector
  public var keyEquivalent : String
  public var url : URL

  private static let webItemsR = [
    BrowseMenuAction(title: "R for macOS Developer's…", url: "https://mac.r-project.org/"),
    BrowseMenuAction(title: "R for macOS CRAN…", url: "https://cran.rstudio.org/bin/macosx/"),
    BrowseMenuAction(title: "R-SIG-Mac Archives…", url: "https://stat.ethz.ch/pipermail/r-sig-mac/"),
    BrowseMenuAction(title: "R-devel News…", url: "https://developer.r-project.org/blosxom.cgi/R-devel/NEWS"),
    BrowseMenuAction(title: "R Installation/Admin macOS Section…", url: "https://cran.rstudio.org/doc/manuals/R-admin.html#Installing-R-under-macOS"),
  ]

  private static let webItemsExt = [
    BrowseMenuAction(title: "RStudio macOS Dailies…", url: "https://dailies.rstudio.com/rstudio/oss/mac/"),
    BrowseMenuAction(title: "R StackOverflow…", url: "https://stackoverflow.com/questions/tagged/r"),
    BrowseMenuAction(title: "RStudio Community…", url: "https://community.rstudio.com/")
  ]

  init(title: String, url: String, selector: String = "browseFromMenu", keyEquivalent: String = "") {
    self.title = title
    self.url = URL(string: url)!
    self.selector = Selector((selector+":"))
    self.keyEquivalent = keyEquivalent
    print(self.selector)
  }
  
  public func asMenuItem() -> NSMenuItem {
    let mi = NSMenuItem(title: title, action: selector, keyEquivalent: keyEquivalent)
    mi.representedObject = self
    return(mi)
  }
  
  public static func populateWebItems(menu : NSMenu) {
    
    menu.addItem(NSMenuItem.separator())

    let webDropdown = NSMenuItem(title: "Web resources", action: nil, keyEquivalent: "")
    let webSub = NSMenu()
    
    menu.addItem(webDropdown)
    menu.setSubmenu(webSub, for: webDropdown)
    for item in webItemsR { webSub.addItem(item.asMenuItem()) }
    
    webSub.addItem(NSMenuItem.separator())
    for item in webItemsExt { webSub.addItem(item.asMenuItem()) }
    
  }

  
}

