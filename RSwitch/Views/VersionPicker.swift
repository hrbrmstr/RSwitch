//
// This presents and handles the R version selection
//

import Foundation
import SwiftUI

struct VersionPicker: View {

  @EnvironmentObject var versionsModel: RVersions
    
  @State private var showingAlert: Bool = false
  @State private var alertMessage: String = ""
  
  func handleRSwitch(newIndex: Int) {
        
    let v = versionsModel.versions
    let fm = FileManager.default
    let rmLink = (RVersions.macosRFramework as NSString).appendingPathComponent("Current")
    let newLink = (RVersions.macosRFramework as NSString).appendingPathComponent(v[newIndex].path)
    
    do {
      try fm.removeItem(atPath: rmLink)
    } catch  {
      alertMessage = "Could not remove `Current` symlink. Check permissions in the `R.framework` folder and make sure RSwitch has Full Disk Access permissions."
      showingAlert = true
      return()
    }
    
    do {
      try fm.createSymbolicLink(
        at: NSURL(fileURLWithPath: rmLink) as URL,
        withDestinationURL: NSURL(fileURLWithPath: newLink) as URL
      )
    } catch {
      alertMessage = "Could not create new `Current` symlink. Check permissions in the `R.framework` folder and make sure RSwitch has Full Disk Access permissions."
      showingAlert = true
      return()
    }
    
  }
  
  var body: some View {
    
    VStack(spacing: 0) {
      
      HStack {
        Text("Current")
        Image(nsImage: AppDelegate.rlogo!)
        Text("Version:")
      }
      
      Picker(selection: self.$versionsModel.current, label: Text("")) {
        ForEach(versionsModel.versions.indices, id: \.self) {
          Text(versionsModel.versions[$0].verboseVersion)
        }
      }
      .onChange(of: self.versionsModel.current, perform: { value in
        handleRSwitch(newIndex: value)
      })
      .padding()

    }
    .padding(4)
    .cornerRadius(5)
    .alert(isPresented: $showingAlert) {
      Alert(
        title: Text("NOTE"),
        message: Text(alertMessage)
      )
    }
  }
  
}
