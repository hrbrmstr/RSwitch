//
// Core views of the app
//

import SwiftUI
import AppKit

struct PrefsView: View {
  
  @Binding var show : Bool
  @State var rstudioCheck : Bool = Preferences.hourlyRStudioCheck
  @State var rstudioProCheck : Bool = Preferences.hourlyRStudioProCheck
  @State var showDockIcon : Bool = Preferences.showDockIcon

  var body: some View {
    
    VStack {
      Form {
      Group {
        Toggle("Check hourly for new RStudio Daily", isOn: $rstudioCheck)
          .onChange(of: rstudioCheck) { _ in
            DispatchQueue.main.async { Preferences.hourlyRStudioCheck = rstudioCheck }
          }
        Toggle("Check hourly for new RStudio Pro Daily", isOn: $rstudioProCheck)
          .onChange(of: rstudioProCheck) { _ in
            DispatchQueue.main.async { Preferences.hourlyRStudioProCheck = rstudioProCheck }
          }
        Toggle("Show icon in the Dock as well as menu", isOn: $showDockIcon)
          .onChange(of: showDockIcon) { _ in
            DispatchQueue.main.async { Preferences.showDockIcon = showDockIcon }
            DockIcon.standard.setVisibility(showDockIcon)
          }
      }
      .padding(2)
      
    }
      Button("Done") { show = false }
    }.padding()
    
  }
  
}

struct Footer: View {
  
  @Binding var prefsShowing: Bool

  var body: some View {
    HStack(alignment: .bottom) {
      Text("RSwitch \(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String)").font(.caption)
      Spacer()
      VStack(alignment: .trailing) {
        Button(
          action: {
            prefsShowing.toggle()
          }
        ) {
          Image(systemName: "gear")
        }
      }.font(.caption)
    }
  }
  
}
    
var versionsModel = RVersions()

struct ContentView: View {
  
  @State private var prefsShowing = false
  
  var body: some View {
    
    VStack(alignment: .center) {
      
      VersionPicker()
        .environmentObject(versionsModel)
      
      Downloaders()
      
      Spacer()
      
      Footer(prefsShowing: $prefsShowing)
      
    }
    .padding(10)
    .frame(minWidth: 300.0, minHeight: 200, alignment: .top)
    .background(Color(#colorLiteral(red: 0.1176293567, green: 0.1176572666, blue: 0.1176275685, alpha: 1)))
    .cornerRadius(5)
    .sheet(isPresented: $prefsShowing, content: {
      PrefsView(show: $prefsShowing)
    })
          
  }
}

