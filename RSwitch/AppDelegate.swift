import Cocoa

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
class AppDelegate: NSObject, NSApplicationDelegate {
    
  var mainStoryboard: NSStoryboard!
  var abtController: NSWindowController!


  // Where the official R installs go
  let macos_r_framework_dir = "/Library/Frameworks/R.framework/Versions"
  
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

  // The core worker function. Receives the basename of the selected directory
  // then removes the current alias and creates the new one.
  @objc func handleSwitch(_ sender: NSMenuItem?) {
    
    let fm = FileManager.default;
    let title = sender?.title
    
    do {
      try fm.removeItem(atPath: macos_r_framework_dir + "/" + "Current")
    } catch {
      infoAlert("Failed to remove 'Current' alias", macos_r_framework_dir + "/" + "Current")
    }
    
    do {
      try fm.createSymbolicLink(
            at: NSURL(fileURLWithPath: macos_r_framework_dir + "/" + "Current") as URL,
            withDestinationURL: NSURL(fileURLWithPath: macos_r_framework_dir + "/" + title!) as URL
      )
    } catch {
      infoAlert("Failed to create alias for " + macos_r_framework_dir + "/" + title!)
    }
      
  }
  
  //
  @objc func about(_ sender: NSMenuItem?) {
    abtController.showWindow(self)
  }

  // Show the framework dir in a new Finder window
  @objc func openFrameworksDir(_ sender: NSMenuItem?) {
    NSWorkspace.shared.openFile(macos_r_framework_dir, withApplication: "Finder")
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
            
      // if there was a Current alias (prbly shld alert if not)
      if ((entries.filter { $0 == "Current" })[0] == "Current") {
      
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
        for version in versions {
          let item = NSMenuItem(title: version, action: #selector(handleSwitch), keyEquivalent: "")
          item.isEnabled = true
          if (version == targetPath) { item.state = NSControl.StateValue.on }
          item.representedObject = version
          menu.addItem(item)
        }

      }
        
    } catch {
      quitAlert("Failed to list contents of R framework directory. You either do not have R installed or have incorrect permissions set on " + macos_r_framework_dir)
    }
    
    // Add a About item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(NSMenuItem(title: NSLocalizedString("About RSwitch…", comment: "About menu item"), action: #selector(about), keyEquivalent: ""))

    // Add a Quit item
    menu.addItem(NSMenuItem.separator())
    menu.addItem(quitItem)
    
  }
  
}
