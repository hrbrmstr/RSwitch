import Foundation
import ArgumentParser
import CoreServices

struct RSwitch: ParsableCommand {
  
  @Argument(help: "R version. e.g. 4.1")
  var vers: String?
  
  @Option(name: [.customShort("a"), .long], help: "Architecture. arm64|x86_64. Defaults to system architecture.")
  var arch: String?
  
  @Flag(name: [.customShort("s"), .long], help: "No output after performing the switch.")
  var silent: Bool = false

  func platform() -> String {
    
    var size = 0
    sysctlbyname("hw.machine", nil, &size, nil, 0)
    
    var machine = [CChar](repeating: 0,  count: size)
    sysctlbyname("hw.machine", &machine, &size, nil, 0)
    
    return String(cString: machine)
    
  }
  
  func shell(command: String) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = ["bash", "-c", command]
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
  }
  
  func handleRSwitch(vers: String, arch: String) {
    
    let fm = FileManager.default
    let rmLink = (RVersions.macosRFramework as NSString).appendingPathComponent("Current")

    var isDir: ObjCBool = true

    let archComponent = arch == "x86_64" ? "" : "-\(arch)"
    var versComponent: String = ""

    let versComponents = vers.split(separator: ".")
    if (versComponents.count >= 2) {
      versComponent = "\(versComponents[0]).\(versComponents[1])"
    } else {
      let msg = "Bad version string."
      print(msg)
      return()
    }
    
    let newLink = (RVersions.macosRFramework as NSString).appendingPathComponent("\(versComponent)\(archComponent)")

    if (fm.fileExists(atPath: newLink, isDirectory: &isDir)) {
      if (!isDir.boolValue) {
        let msg = "Path exists but is not a directory."
        print(msg)
        return()
      }
    }
    
    do {
      try fm.removeItem(atPath: rmLink)
    } catch  {
      let msg = "Could not remove `Current` symlink. Check permissions in the `R.framework` folder and make sure the RSwitch CLI utility has Full Disk Access permissions."
      print(msg)
      return()
    }
    
    do {
      try fm.createSymbolicLink(
        at: NSURL(fileURLWithPath: rmLink) as URL,
        withDestinationURL: NSURL(fileURLWithPath: newLink) as URL
      )
    } catch {
      let msg = "Could not create new `Current` symlink. Check permissions in the `R.framework` folder and make sure RSwitch has Full Disk Access permissions."
      print(msg)
      return()
    }
    
    if (!silent) {
      let _ = shell(command: "R --version")
    }
    
  }
  
  mutating func run() throws {
    
    if let vers = vers  {
      
      if let arch = arch {
        handleRSwitch(vers: vers, arch: arch)
      } else {
        handleRSwitch(vers: vers, arch: platform())
      }
      
    } else {
      
      let versions = RVersions.enumerateVersions()
      
      if (versions.count > 0) {
        versions.forEach { vers in
          print("- \(vers)")
        }
      } else {
        print("No R installations found.")
      }
      
    }

  }
  
}

RSwitch.main()
