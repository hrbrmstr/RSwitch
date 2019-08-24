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
    static let browse_r_admin_macos = "https://cran.rstudio.org/doc/manuals/R-admin.html#Installing-R-under-macOS"
    static let version_check = "https://rud.is/rswitch/releases/current-version.txt"
    static let releases = "https://git.rud.is/hrbrmstr/RSwitch/releases"
  }
  
  // browse macOS dev page
  @objc func browse_r_macos_dev_page(_ sender: NSMenuItem?) { browse(app_urls.mac_r_project) }
  
  // browse macOS dev page
  @objc func browse_r_macos_cran_page(_ sender: NSMenuItem?) { browse(app_urls.macos_cran) }
  
  // browse macOS dev page
  @objc func browse_r_sig_mac_page(_ sender: NSMenuItem?) { browse(app_urls.r_sig_mac) }
  
  // browse RStudio macOS Dailies
  @objc func browse_rstudio_mac_dailies_page(_ sender: NSMenuItem?) { browse(app_urls.rstudio_dailies) }
    
  // browse R Install/Admin macOS section
  @objc func browse_r_admin_macos_page(_ sender: NSMenuItem?) { browse(app_urls.browse_r_admin_macos) }
  
  // Show about dialog
  @objc func about(_ sender: NSMenuItem?) { abtController.showWindow(self) }

  // Show the framework dir in a new Finder window
  @objc func openFrameworksDir(_ sender: NSMenuItem?) { NSWorkspace.shared.openFile(app_dirs.macos_r_framework, withApplication: "Finder") }
  
  // Launch RStudio
  @objc func launchRStudio(_ sender: NSMenuItem?) { NSWorkspace.shared.launchApplication("RStudio.app") }

  // Launch R.app
  @objc func launchRApp(_ sender: NSMenuItem?) { NSWorkspace.shared.launchApplication("R.app") }

}
