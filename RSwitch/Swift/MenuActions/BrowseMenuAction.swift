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
  
  @objc func rswitch_help(_ sender: NSMenuItem) {
    NSWorkspace.shared.open(URL(string: "https://rud.is/rswitch/guide/")!)
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
    BrowseMenuAction(title: "R-Forge macOS Subversion…", url: "http://svn.rforge.net/osx/trunk/"),
    BrowseMenuAction(title: "R-Project R GUI Subversion…", url: "https://svn.r-project.org/R-packages/trunk/Mac-GUI/"),
    BrowseMenuAction(title: "Bioconductor…", url: "https://www.bioconductor.org/")
  ]

  private static let webItemsExt = [
    BrowseMenuAction(title: "R Package Documentation (rdrr.io)…", url: "https://rdrr.io/"),
    BrowseMenuAction(title: "R Compiler Tools for RCpp on macOS…", url: "https://thecoatlessprofessor.com/programming/cpp/r-compiler-tools-for-rcpp-on-macos/"),
    BrowseMenuAction(title: "Rseek…", url: "https://rseek.org"),
    BrowseMenuAction(title: "R StackOverflow…", url: "https://stackoverflow.com/questions/tagged/r"),
    BrowseMenuAction(title: "ROpenSci Discuss…", url: "https://discuss.ropensci.org/"),
    BrowseMenuAction(title: "RStudio Community…", url: "https://community.rstudio.com/"),
    BrowseMenuAction(title: "RStudio macOS Dailies…", url: "https://dailies.rstudio.com/rstudio/oss/mac/"),
    BrowseMenuAction(title: "Unofficial R-O GitHub CRAN Mirror…", url: "https://github.com/cran"),
    BrowseMenuAction(title: "XQuartz (X11 for macOS)…", url: "https://www.xquartz.org/"),
    BrowseMenuAction(title: "Homebrew (macOS Package Manager)…", url: "https://brew.sh/"),
    BrowseMenuAction(title: "Apple Developer Portal…", url: "https://developer.apple.com/")
  ]

  private static let webItemsMan = [
    BrowseMenuAction(title: "An Introduction to R…", url: "file:///Library/Frameworks/R.framework/Versions/3.6/Resources/doc/manual/R-intro.html"),
    BrowseMenuAction(title: "R Data Import/Export…", url: "file:///Library/Frameworks/R.framework/Versions/3.6/Resources/doc/manual/R-data.html"),
    BrowseMenuAction(title: "R Installation and Administration…", url: "file:///Library/Frameworks/R.framework/Versions/3.6/Resources/doc/manual/R-admin.html"),
    BrowseMenuAction(title: "Writing R Extensions…", url: "file:///Library/Frameworks/R.framework/Versions/3.6/Resources/doc/manual/"),
    BrowseMenuAction(title: "The R language definition…", url: "file:///Library/Frameworks/R.framework/Versions/3.6/Resources/doc/manual/R-exts.html"),
    BrowseMenuAction(title: "R Internals…", url: "file:///Library/Frameworks/R.framework/Versions/3.6/Resources/doc/manual/R-ints.html")
  ]
  
  private static let webItemsBook = [
    BrowseMenuAction(title: "A moderndive into R and the tidyverse…", url: "https://moderndive.com/"),
    BrowseMenuAction(title: "Advanced R…", url: "https://adv-r.hadley.nz/"),
    BrowseMenuAction(title: "bookdown: Authoring Books and Technical Documents with R Markdown…", url: "https://bookdown.org/yihui/bookdown/"),
    BrowseMenuAction(title: "Data Visualization: A practical introduction…", url: "https://socviz.co/"),
    BrowseMenuAction(title: "Efficient R programming…", url: "https://csgillespie.github.io/efficientR/"),
    BrowseMenuAction(title: "Forecasting: Principles and Practice…", url: "https://otexts.com/fpp2/"),
    BrowseMenuAction(title: "Fundamentals of Data Visualization…", url: "https://serialmentor.com/dataviz/"),
    BrowseMenuAction(title: "Geocomputation with R…", url: "https://geocompr.robinlovelace.net/"),
    BrowseMenuAction(title: "ggplot2: Elegant Graphics for Data Analysis…", url: "https://ggplot2-book.org/"),
    BrowseMenuAction(title: "Hands-On Programming with R…", url: "https://rstudio-education.github.io/hopr/"),
    BrowseMenuAction(title: "Happy Git and GitHub with R…", url: "https://happygitwithr.com/"),
    BrowseMenuAction(title: "Modern R with the tidyverse", url: "https://b-rodrigues.github.io/modern_R/"),
    BrowseMenuAction(title: "R for Data Science…", url: "https://r4ds.had.co.nz"),
    BrowseMenuAction(title: "R Gaphics Cookbook…", url: "https://r-graphics.org/"),
    BrowseMenuAction(title: "R Markdown: The Definitive Guide…", url: "https://bookdown.org/yihui/rmarkdown/"),
    BrowseMenuAction(title: "R Packages…", url: "http://r-pkgs.had.co.nz/"),
    BrowseMenuAction(title: "Rcpp for Everyone…", url: "https://teuder.github.io/rcpp4everyone_en/"),
    BrowseMenuAction(title: "Spatio-Temporal Statistics with R…", url: "http://spacetimewithr.org/"),
    BrowseMenuAction(title: "Text Mining with R…", url: "https://www.tidytextmining.com/")
  ]

  init(title: String, url: String, selector: String = "browseFromMenu", keyEquivalent: String = "") {
    self.title = title
    self.url = URL(string: url)!
    self.selector = Selector((selector+":"))
    self.keyEquivalent = keyEquivalent
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
  
  public static func populateLocalRManualsItems(menu : NSMenu) {

    let manDropdown = NSMenuItem(title: "R Manuals (local)", action: nil, keyEquivalent: "")
    let manSub = NSMenu()
    
    menu.addItem(manDropdown)
    menu.setSubmenu(manSub, for: manDropdown)
    for item in webItemsMan { manSub.addItem(item.asMenuItem()) }
    
  }
  
  public static func populateRBooksItems(menu : NSMenu) {

    let bookDropdown = NSMenuItem(title: "R Books", action: nil, keyEquivalent: "")
    let bookSub = NSMenu()
    
    menu.addItem(bookDropdown)
    menu.setSubmenu(bookSub, for: bookDropdown)
    for item in webItemsBook { bookSub.addItem(item.asMenuItem()) }
    
  }
  
}

