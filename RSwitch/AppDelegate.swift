import Cocoa
import SwiftSoup

// Show an informational alert
public func infoAlert(_ message: String, _ extra: String? = nil, style: NSAlert.Style = NSAlert.Style.informational) {
  let alert = NSAlert()
  alert.messageText = message
  if extra != nil { alert.informativeText = extra! }
  alert.alertStyle = style
  alert.runModal()
}

// Show an informational alert and then quit
public func quitAlert(_ message: String, _ extra: String? = nil) {
  infoAlert(message, "The application will now quit.", style: NSAlert.Style.critical)
  NSApp.terminate(nil)
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
  var mainStoryboard: NSStoryboard!
  var abtController: NSWindowController!

  let macos_r_framework_dir = "/Library/Frameworks/R.framework/Versions" // Where the official R installs go
  let mac_r_project_url = "https://mac.r-project.org/"
  let macos_cran_url = "https://cran.rstudio.org/bin/macosx/"
  let r_sig_mac_url = "https://stat.ethz.ch/pipermail/r-sig-mac/"
  let rstudio_dailies_url = "https://dailies.rstudio.com/rstudio/oss/mac/"
  let latest_rstudio_dailies_url = "https://www.rstudio.org/download/latest/daily/desktop/mac/RStudio-latest.dmg"
  
  // Get the bar setup
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let statusMenu = NSMenu()
  
  let quitItem = NSMenuItem(title: NSLocalizedString("Quit", comment: "Quit menu item"), action: #selector(NSApp.terminate), keyEquivalent: "q")

  override init() {
    super.init()
    
    statusMenu.delegate = self
    
    // dial by IconMark from the Noun Project
    statusItem.button?.image =  #imageLiteral(resourceName: "RSwitch")
    statusItem.menu = statusMenu
    
    mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
    abtController = (mainStoryboard.instantiateController(withIdentifier: "aboutPanelController") as! NSWindowController)
        
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
  }
    
  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down app
  }
  
  func notifyUser(title: String? = nil, subtitle: String? = nil, text: String? = nil) -> Void {
    
    let notification = NSUserNotification()
    
    notification.title = title
    notification.subtitle = subtitle
    notification.informativeText = text
    
    notification.soundName = NSUserNotificationDefaultSoundName
    
    NSUserNotificationCenter.default.delegate = self
    NSUserNotificationCenter.default.deliver(notification)
    
  }


  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }
  
  // The core worker function. Receives the basename of the selected directory
  // then removes the current alias and creates the new one.
  @objc func handleSwitch(_ sender: NSMenuItem?) {
    
    let fm = FileManager.default;
    let title = sender?.title
    
    do {
      try fm.removeItem(atPath: macos_r_framework_dir + "/" + "Current")
    } catch {
      self.notifyUser(title: "Action failed", text: "Failed to remove 'Current' alias" + macos_r_framework_dir + "/" + "Current")
    }
    
    do {
      try fm.createSymbolicLink(
            at: NSURL(fileURLWithPath: macos_r_framework_dir + "/" + "Current") as URL,
            withDestinationURL: NSURL(fileURLWithPath: macos_r_framework_dir + "/" + title!) as URL
      )
      self.notifyUser(title: "Success", text: "Current R version switched to " + title!)
    } catch {
      self.notifyUser(title: "Action failed", text: "Failed to create alias for " + macos_r_framework_dir + "/" + title!)
    }
      
  }
  
  // browse macOS dev page
  @objc func browse_r_macos_dev_page(_ sender: NSMenuItem?) {
    let url = URL(string: mac_r_project_url)!
    NSWorkspace.shared.open(url)
  }
  
  // browse macOS dev page
  @objc func browse_r_macos_cran_page(_ sender: NSMenuItem?) {
    let url = URL(string: macos_cran_url)!
    NSWorkspace.shared.open(url)
  }
  
  // browse macOS dev page
  @objc func browse_r_sig_mac_page(_ sender: NSMenuItem?) {
    let url = URL(string: r_sig_mac_url)!
    NSWorkspace.shared.open(url)
  }
  
  // browse RStudio macOS Dailies
  @objc func browse_rstudio_mac_dailies_page(_ sender: NSMenuItem?) {
    let url = URL(string: rstudio_dailies_url)!
    NSWorkspace.shared.open(url)
  }

  // Show about dialog
  @objc func about(_ sender: NSMenuItem?) {
    abtController.showWindow(self)
  }

  // Show the framework dir in a new Finder window
  @objc func openFrameworksDir(_ sender: NSMenuItem?) {
    NSWorkspace.shared.openFile(macos_r_framework_dir, withApplication: "Finder")
  }

  // Download latest rstudio daily build
  @objc func download_latest_rstudio(_ sender: NSMenuItem?) {
    
    let url = URL(string: rstudio_dailies_url)
    
    do {
      let html = try String.init(contentsOf: url!)
      let document = try SwiftSoup.parse(html)
      
      let link = try document.select("td > a").first!
      let href = try link.attr("href")
      let dlurl = URL(string: href)!
      let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
      var dlfile = dldir
      
      dlfile.appendPathComponent(dlurl.lastPathComponent)
      
      if (FileManager.default.fileExists(atPath: dlfile.relativePath)) {
        self.notifyUser(title: "Action required", subtitle: "RStudio Download", text: "A local copy of the latest RStudio daily already exists. Please remove or rename it if you wish to re-download it.")
      } else {
        let task = URLSession.shared.downloadTask(with: dlurl) { (tempURL, response, error) in
          if let tempURL = tempURL, error == nil {
            if ((response as? HTTPURLResponse)?.statusCode == 200) {
              do {
                try FileManager.default.copyItem(at: tempURL, to: dlfile)
                NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
                self.notifyUser(title: "Success", subtitle: "RStudio Download", text: "Download of latest RStudio daily (" + dlurl.lastPathComponent + ") successful.")
              } catch {
                self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Failed to successfully save latest RStudio daily.")
              }
            } else {
              self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Received unsuccessful status code from RStudio's site.")
            }
          } else {
            self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "System error when attempting to download file.")
          }
        }
        task.resume()
      }
    } catch {
      self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error downloading and saving latest RStudio daily.")
    }
    
  }
  
  // Download latest r-devel tarball
  @objc func download_latest_tarball(_ sender: NSMenuItem?) {
    
    let url = URL(string: "https://mac.r-project.org/el-capitan/R-devel/R-devel-el-capitan-sa-x86_64.tar.gz")!
    let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    var dlfile = dldir
    
    dlfile.appendPathComponent("R-devel-el-capitan-sa-x86_64.tar.gz")
  
    if (FileManager.default.fileExists(atPath: dlfile.relativePath)) {
      self.notifyUser(title: "Action required", subtitle: "r-devel Download", text: "R-devel tarball already exists. Please remove or rename it before downloading.")
    } else {
        let task = URLSession.shared.downloadTask(with: url) { (tempURL, response, error) in
          if let tempURL = tempURL, error == nil {
            if ((response as? HTTPURLResponse)?.statusCode == 200) {
              do {
                try FileManager.default.copyItem(at: tempURL, to: dlfile)
                NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
                self.notifyUser(title: "Success", subtitle: "r-devel Download", text: "Download of latest r-devel successful.")
              } catch {
                self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Failed to save latest r-devel.")
              }
            } else {
              self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Received unsuccessful status code from macOS r-devel site.")
            }
          } else {
            self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error downloading and saving latest r-devel .")
          }
        }
      task.resume()
    }
  }
  
}

extension AppDelegate: NSMenuDelegate {
  
  func menuWillOpen(_ menu: NSMenu) {
    
    if (menu != self.statusMenu) { return }
    
    // clear the menu
    menu.removeAllItems()
    
    // add selection to open frameworks dir in Finder
    menu.addItem(NSMenuItem(title: "Open R Frameworks Directory", action: #selector(openFrameworksDir), keyEquivalent: "" ))
    menu.addItem(NSMenuItem.separator())

    // populate installed versions
    let fm = FileManager.default
    var targetPath:String? = nil

    do {
      
      // gets a directory listing
      let entries = try fm.contentsOfDirectory(atPath: macos_r_framework_dir)
      
      // retrieves all versions (excludes hidden files and the Current alias
      let versions = entries.sorted().filter { !($0.hasPrefix(".")) && !($0 == "Current") }
      let hasCurrent = entries.filter { $0 == "Current" }
      
      // if there was a Current alias (prbly shld alert if not)
      if (hasCurrent.count > 0) {
      
        // get where Current points to
        let furl = NSURL(fileURLWithPath: macos_r_framework_dir + "/" + "Current")
        
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
      quitAlert("Failed to list contents of R framework directory. You either do not have R installed or have incorrect permissions set on " + macos_r_framework_dir)
    }

    // Add items to download latest r-devel tarball and latest macOS daily
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("Download latest R-devel tarball", comment: "Download latest tarball item"), action: #selector(download_latest_tarball), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Download latest RStudio daily build", comment: "Download latest RStudio item"), action: #selector(download_latest_rstudio), keyEquivalent: ""))

    
    // Add items to open variosu R for macOS pages
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R for macOS Developers Page…", comment: "Open macOS Dev Page item"), action: #selector(browse_r_macos_dev_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R for macOS CRAN Page…", comment: "Open macOS CRAN Page item"), action: #selector(browse_r_macos_cran_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R-SIG-Mac Archives Page…", comment: "Open R-SIG-Mac Page item"), action: #selector(browse_r_sig_mac_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open RStudio macOS Dailies Page…", comment: "Open RStudio macOS Dailies Page item"), action: #selector(browse_rstudio_mac_dailies_page), keyEquivalent: ""))

    // Add a About item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("About RSwitch…", comment: "About menu item"), action: #selector(about), keyEquivalent: ""))

    // Add a Quit item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(quitItem)
    
  }
  
}
