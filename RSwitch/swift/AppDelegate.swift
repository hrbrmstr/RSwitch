import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
  var mainStoryboard: NSStoryboard!
  var abtController: NSWindowController!

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
  
  func applicationDidFinishLaunching(_ aNotification: Notification) { }
    
  func applicationWillTerminate(_ aNotification: Notification) { }

}
