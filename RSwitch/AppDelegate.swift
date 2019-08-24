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
  
  // Get the bar setup
  let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
  let statusMenu = NSMenu()
  
  let quitItem = NSMenuItem(title: NSLocalizedString("Quit", comment: "Quit menu item"), action: #selector(NSApp.terminate), keyEquivalent: "q")

  var rdevel_enabled: Bool!
  var rstudio_enabled: Bool!

  override init() {
    
    super.init()
    
    statusMenu.delegate = self
    
    // dial by IconMark from the Noun Project
    statusItem.button?.image =  #imageLiteral(resourceName: "RSwitch")
    statusItem.menu = statusMenu
    
    mainStoryboard = NSStoryboard(name: "Main", bundle: nil)
    abtController = (mainStoryboard.instantiateController(withIdentifier: "aboutPanelController") as! NSWindowController)
    
    rdevel_enabled = true
    rstudio_enabled = true
    
    URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
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
    let url = URL(string: app_urls.mac_r_project)!
    NSWorkspace.shared.open(url)
  }
  
  // browse macOS dev page
  @objc func browse_r_macos_cran_page(_ sender: NSMenuItem?) {
    let url = URL(string: app_urls.macos_cran)!
    NSWorkspace.shared.open(url)
  }
  
  // browse macOS dev page
  @objc func browse_r_sig_mac_page(_ sender: NSMenuItem?) {
    let url = URL(string: app_urls.r_sig_mac)!
    NSWorkspace.shared.open(url)
  }
  
  // browse RStudio macOS Dailies
  @objc func browse_rstudio_mac_dailies_page(_ sender: NSMenuItem?) {
    let url = URL(string: app_urls.rstudio_dailies)!
    NSWorkspace.shared.open(url)
  }
  
  
  // browse R Install/Admin macOS section
  @objc func browse_r_admin_macos_page(_ sender: NSMenuItem?) {
    let url = URL(string: app_urls.browse_r_admin_macos)!
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
  
  // Launch RStudio
  @objc func launchRStudio(_ sender: NSMenuItem?) {
    NSWorkspace.shared.launchApplication("RStudio.app")
  }

  // Launch R.app
  @objc func launchRApp(_ sender: NSMenuItem?) {
    NSWorkspace.shared.launchApplication("R.app")
  }

  // Launch R.app
  @objc func checkForUpdate(_ sender: NSMenuItem?) {
    
    let url = URL(string: app_urls.version_check)
    
    do {
      URLCache.shared.removeAllCachedResponses()
      var version = try String.init(contentsOf: url!)
      version = version.trimmingCharacters(in: .whitespacesAndNewlines)
      if (version.isVersion(greaterThan: Bundle.main.releaseVersionNumber!)) {
        let url = URL(string: app_urls.releases)
        NSWorkspace.shared.open(url!)
      } else {
        self.notifyUser(title: "RSwitch", text: "You are running the latest version of RSwitch.")
      }
    } catch {
      self.notifyUser(title: "Action failed", subtitle: "Update check", text: "Error: \(error)")
    }

    
  }
  
  // Download latest rstudio daily build
  @objc func download_latest_rstudio(_ sender: NSMenuItem?) {
    
    self.rstudio_enabled = false

    let url = URL(string: app_urls.rstudio_dailies)
    
    do {
      
      let html = try String.init(contentsOf: url!)
      let document = try SwiftSoup.parse(html)
      
      let link = try document.select("td > a").first!
      let href = try link.attr("href")
      let dlurl = URL(string: href)!
      let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
      var dlfile = dldir
      
      dlfile.appendPathComponent(dlurl.lastPathComponent)
      
      print("RStudio href: " + href)
      
      if (FileManager.default.fileExists(atPath: dlfile.relativePath)) {
        
        self.notifyUser(title: "Action required", subtitle: "RStudio Download", text: "A local copy of the latest RStudio daily already exists. Please remove or rename it if you wish to re-download it.")
        
        NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
        NSWorkspace.shared.activateFileViewerSelecting([dlfile])

        self.rstudio_enabled = true
        
      } else {
        
        print("Timeout value: ", URLSession.shared.configuration.timeoutIntervalForRequest)
        
        let task = URLSession.shared.downloadTask(with: dlurl) {
          tempURL, response, error in
          
          if (error != nil) {
            self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error: " + error!.localizedDescription)
          } else if (response != nil) {
            
            let status = (response as? HTTPURLResponse)!.statusCode
            if (status < 300) {
              
              guard let fileURL = tempURL else {
                DispatchQueue.main.async { [weak self] in  self?.rstudio_enabled = true }
                return
              }
              
              do {
                try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                try FileManager.default.moveItem(at: fileURL, to: dlfile)
                self.notifyUser(title: "Success", subtitle: "RStudio Download", text: "Download of latest RStudio daily (" + dlurl.lastPathComponent + ") successful.")
                NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
                NSWorkspace.shared.activateFileViewerSelecting([dlfile])
              } catch {
                self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error: \(error)")
              }
              
            } else {
              self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error downloading latest RStudio daily. Status code: " + String(status))

            }
          }
          
          DispatchQueue.main.async { [weak self] in  self?.rstudio_enabled = true }
          
        }
        
        task.resume()
      }
      
    } catch {
      self.notifyUser(title: "Action failed", subtitle: "RStudio Download", text: "Error downloading and saving latest RStudio daily.")
    }
    
  }
  
  // Download latest r-devel tarball
  @objc func download_latest_tarball(_ sender: NSMenuItem?) {
    
    self.rdevel_enabled = false
    
    let dlurl = URL(string: "https://mac.r-project.org/el-capitan/R-devel/R-devel-el-capitan-sa-x86_64.tar.gz")!
    let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
    var dlfile = dldir
    
    dlfile.appendPathComponent("R-devel-el-capitan-sa-x86_64.tar.gz")
  
    if (FileManager.default.fileExists(atPath: dlfile.relativePath)) {
      
      self.notifyUser(title: "Action required", subtitle: "r-devel Download", text: "R-devel tarball already exists. Please remove or rename it before downloading.")
      
      NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
      NSWorkspace.shared.activateFileViewerSelecting([dlfile])
      
      self.rdevel_enabled = true
    } else {
      
      let task = URLSession.shared.downloadTask(with: dlurl) {
        tempURL, response, error in
        
        if (error != nil) {
          self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error: " + error!.localizedDescription)
        } else if (response != nil) {
          
          let status = (response as? HTTPURLResponse)!.statusCode
          if (status < 300) {
            
            guard let fileURL = tempURL else {
              DispatchQueue.main.async { [weak self] in  self?.rdevel_enabled = true }
              return
            }
            
            do {
              try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
              try FileManager.default.moveItem(at: fileURL, to: dlfile)
              self.notifyUser(title: "Success", subtitle: "r-devel Download", text: "Download of latest r-devel (" + dlurl.lastPathComponent + ") successful.")
              NSWorkspace.shared.openFile(dldir.path, withApplication: "Finder")
              NSWorkspace.shared.activateFileViewerSelecting([dlfile])
            } catch {
              self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error: \(error)")
            }
            
          } else {
            self.notifyUser(title: "Action failed", subtitle: "r-devel Download", text: "Error downloading latest r-devel. Status code: " + String(status))
          }
        }
        
        DispatchQueue.main.async { [weak self] in  self?.rdevel_enabled = true }
        
      }
      
      task.resume()
    }
  }
  
}

extension Bundle {
  var releaseVersionNumber: String? {
    return infoDictionary?["CFBundleShortVersionString"] as? String
  }
  var buildVersionNumber: String? {
    return infoDictionary?["CFBundleVersion"] as? String
  }
  var releaseVersionNumberPretty: String {
    return "v\(releaseVersionNumber ?? "1.0.0")"
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
    
    let rdevelItem = NSMenuItem(title: NSLocalizedString("Download latest R-devel tarball", comment: "Download latest tarball item"), action: self.rdevel_enabled ? #selector(download_latest_tarball) : nil, keyEquivalent: "")
    rdevelItem.isEnabled = self.rdevel_enabled
    menu.addItem(rdevelItem)
    
    let rstudioItem = NSMenuItem(title: NSLocalizedString("Download latest RStudio daily build", comment: "Download latest RStudio item"), action: self.rstudio_enabled ? #selector(download_latest_rstudio) : nil, keyEquivalent: "")
    rstudioItem.isEnabled = self.rstudio_enabled
    menu.addItem(rstudioItem)

    
    // Add items to open variosu R for macOS pages
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R for macOS Developers Page…", comment: "Open macOS Dev Page item"), action: #selector(browse_r_macos_dev_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R for macOS CRAN Page…", comment: "Open macOS CRAN Page item"), action: #selector(browse_r_macos_cran_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R-SIG-Mac Archives Page…", comment: "Open R-SIG-Mac Page item"), action: #selector(browse_r_sig_mac_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open R Installation/Admin macOS Section…", comment: "Open R Install Page item"), action: #selector(browse_r_admin_macos_page), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Open RStudio macOS Dailies Page…", comment: "Open RStudio macOS Dailies Page item"), action: #selector(browse_rstudio_mac_dailies_page), keyEquivalent: ""))

    // Add launchers
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("Launch R GUI", comment: "Launch R GUI item"), action: #selector(launchRApp), keyEquivalent: ""))
    menu.addItem(NSMenuItem(title: NSLocalizedString("Launch RStudio", comment: "Launch RStudio item"), action: #selector(launchRStudio), keyEquivalent: ""))
    
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
