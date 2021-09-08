//
// The three download buttons
//

import Foundation
import SwiftUI

struct DownloadButtonView : View {
  
  let title: String
  
  var body: some View {
    VStack {
      Image(systemName: "square.and.arrow.down.fill")
        .resizable()
        .frame(width:16, height:16)
        .foregroundColor(Color(#colorLiteral(red: 0.1331118345, green: 0.4078201056, blue: 0.7316896319, alpha: 1)))
      Text(title)
    }
  }
  
}

struct DownloadView : View {
  
  let title: String
  let resourceURL: () -> URL
  
  @State var show: Bool = false
  @State var progress: Float = 0.0
  @State var isDownloading: Bool = false
  @State var showingAlert: Bool = false
  @State var alertMessage: String = ""
  @State var task: URLSessionDownloadTask?
  
  func fileExists(basename: String) -> Bool {
    
    var isDirectory:ObjCBool = false
    var fil = AppDelegate.downloadsFolder
    fil.appendPathComponent(basename)
    
    return(FileManager.default.fileExists(atPath: fil.relativePath, isDirectory: &isDirectory))
    
  }
  
  func downloadFile() {
    
    let urlString = resourceURL().absoluteString
    
    task = URLSession.shared.downloadTask(with: URL(string: urlString)!) {
      tempURL, response, error in
      
      DispatchQueue.main.async {
        self.show = false
        self.isDownloading = false
      }
      
      if (error != nil) {
        
        let err = error! as NSError
        
        if (err.code == -999) {
          return()
        } else {
          DispatchQueue.main.async {
            self.alertMessage = "Error downloading \(urlString). Please ensure RSwitch has Full Disk Access permissions."
            self.showingAlert = true
          }
        }
        
        return()
        
      } else if (response != nil) {
        
        let status = (response as? HTTPURLResponse)!.statusCode
        
        if (status < 300) {
          
          guard let fileURL = tempURL else {
            DispatchQueue.main.async {
              self.alertMessage = "Error downloading \(urlString). Please ensure RSwitch has Full Disk Access permissions."
              self.showingAlert = true
              self.progress = 0
            }
            return()
          }
          
          do {
            
            let basename = NSString(string: urlString).lastPathComponent as String
            let dldir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
            let dlfile = dldir.appendingPathComponent(basename.replacingOccurrences(of: "%2B", with: "+"))
            
            try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            try FileManager.default.moveItem(at: fileURL, to: dlfile)
            
            NSWorkspace.shared.activateFileViewerSelecting([dlfile])
            
            DispatchQueue.main.async {
              self.progress = 0
            }
            
            if (dlfile.pathExtension == "dmg") {
              
              let task = Process.launchedProcess(
                launchPath: "/usr/bin/hdiutil",
                arguments: [ "attach", "-autoopen", dlfile.absoluteString ]
              )
              task.waitUntilExit()
            }
            
          } catch {
            DispatchQueue.main.async {
              self.alertMessage = "Error downloading \(title). Please ensure RSwitch has Full Disk Access permissions."
              self.showingAlert = true
              self.progress = 0
            }
            return()
          }
          
        } else {
          DispatchQueue.main.async {
            self.alertMessage = "Could not find \(title) at \(urlString). Please ensure RSwitch has Full Disk Access permissions."
            self.showingAlert = true
            self.progress = 0
          }
          return()
        }
      }
      
    }
    
    AppDelegate.downloadObservers[title] = task?.progress.observe(\.fractionCompleted) { (progress, _) in
      DispatchQueue.main.async {
        self.progress = Float(progress.fractionCompleted)
      }
    }
    
    task?.resume()
    
    DispatchQueue.main.async { self.isDownloading = true }
    
  }
  
  var body: some View {
    
    VStack {
      if self.show {
        ProgressBar(progress: $progress)
      } else {
        DownloadButtonView(title: title)
      }
    }
    .padding(8)
    .frame(width: 90, height: 60, alignment:  .center)
    .background(Color(#colorLiteral(red: 0.1372351348, green: 0.1372662485, blue: 0.1372331679, alpha: 1)))
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor).shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    )
    .onTapGesture {
      
      if (isDownloading) {
        task?.cancel()
        self.progress = 0
        return()
      }
      
      let urlString = resourceURL().absoluteString
      
      let basename = URL(string: urlString)!.lastPathComponent
      
      if (fileExists(basename: basename)) {
        alertMessage = "\(basename) already exists in Downloads folder. Please remove or rename it if you wish to re-download it."
        showingAlert = true
        self.show = false
        return()
      }
      
      self.show = (currentReachabilityStatus != .notReachable)
      
      if (self.show) { downloadFile() }
      
    }
    .alert(isPresented: $showingAlert) {
      Alert(
        title: Text(""),
        message: Text(alertMessage)
      )
    }
    
  }
  
}

struct Downloaders: View {
  
  var body: some View {
    HStack(alignment: .top) {
      
      Spacer()
      
      VStack {
        Spacer()
        DownloadView(
          title: "R-dev (arm)",
          resourceURL: RUtils.RDevelURLArm
        )
        
        Spacer()
        
        DownloadView(
          title: "R-dev (x86)",
          resourceURL: RUtils.RDevelURLX86
        )
        Spacer()
      }
      
      VStack {
        Spacer()
        DownloadView(
          title: "RStudio",
          resourceURL: RStudioUtils.latestVersionURL
        )
        
        Spacer()
        
        DownloadView(
          title: "RS Pro",
          resourceURL: RStudioUtils.latestProVersionURL
        )
        Spacer()
      }
      
      Spacer()
      
    }
    
  }
}
