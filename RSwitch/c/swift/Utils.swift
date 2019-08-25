//
//  Utils.swift
//  RSwitch
//
//  Created by hrbrmstr on 8/24/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Cocoa

public func browse(_ urlString : String) {
  let url = URL(string: urlString)!
  NSWorkspace.shared.open(url)
}

extension AppDelegate {
  
  struct app_urls {
    static let mac_r_project = "https://mac.r-project.org/"
    static let macos_cran = "https://cran.rstudio.org/bin/macosx/"
    static let r_sig_mac = "https://stat.ethz.ch/pipermail/r-sig-mac/"
    static let rstudio_dailies = "https://dailies.rstudio.com/rstudio/oss/mac/"
    static let latest_rstudio_dailies = "https://www.rstudio.org/download/latest/daily/desktop/mac/RStudio-latest.dmg"
    static let r_admin_macos = "https://cran.rstudio.org/doc/manuals/R-admin.html#Installing-R-under-macOS"
    static let r_devel_news = "https://developer.r-project.org/blosxom.cgi/R-devel/NEWS"
    static let r_stackoverflow = "https://stackoverflow.com/questions/tagged/r"
    static let rstudio_community = "https://community.rstudio.com/"
    static let version_check = "https://rud.is/rswitch/releases/current-version.txt"
    static let releases = "https://git.rud.is/hrbrmstr/RSwitch/releases"
  }
  
  @objc func browse_r_macos_dev_page(_ sender: NSMenuItem?) { browse(app_urls.mac_r_project) }
  @objc func browse_r_macos_cran_page(_ sender: NSMenuItem?) { browse(app_urls.macos_cran) }
  @objc func browse_r_sig_mac_page(_ sender: NSMenuItem?) { browse(app_urls.r_sig_mac) }
  @objc func browse_rstudio_mac_dailies_page(_ sender: NSMenuItem?) { browse(app_urls.rstudio_dailies) }
  @objc func browse_r_admin_macos_page(_ sender: NSMenuItem?) { browse(app_urls.r_admin_macos) }
  @objc func browse_r_devel_news_page(_ sender: NSMenuItem?) { browse(app_urls.r_devel_news) }
  @objc func browse_r_stackoverflow_page(_ sender: NSMenuItem?) { browse(app_urls.r_stackoverflow) }
  @objc func browse_rstudio_community_page(_ sender: NSMenuItem?) { browse(app_urls.rstudio_community) }

  // Show about dialog
  @objc func about(_ sender: NSMenuItem?) { abtController.showWindow(self) }

  // Show the framework dir in a new Finder window
  @objc func openFrameworksDir(_ sender: NSMenuItem?) { NSWorkspace.shared.openFile(app_dirs.macos_r_framework, withApplication: "Finder") }
  
  // Launch RStudio
  @objc func launchRStudio(_ sender: NSMenuItem?) {
    if (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control)) {
      NSWorkspace.shared.launchApplication(withBundleIdentifier: "org.rstudio.RStudio", options: NSWorkspace.LaunchOptions.newInstance, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    } else {
      NSWorkspace.shared.launchApplication("RStudio.app")
    }
  }

  // Launch R.app
  @objc func launchRApp(_ sender: NSMenuItem?) {
    if (NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.control)) {
      NSWorkspace.shared.launchApplication(withBundleIdentifier: "org.R-project.R", options: NSWorkspace.LaunchOptions.newInstance, additionalEventParamDescriptor: nil, launchIdentifier: nil)
    } else {
      NSWorkspace.shared.launchApplication("R.app")
    }
  }

}
