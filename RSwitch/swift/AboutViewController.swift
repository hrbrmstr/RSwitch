
import Cocoa

extension AppDelegate {
  
  // Show about dialog
  @objc func about(_ sender: NSMenuItem?) { abtController.showWindow(self) }
  
}

class AboutViewController: NSViewController {
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
    
}
