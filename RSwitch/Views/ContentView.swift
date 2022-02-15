//
// Core views of the app
//

import SwiftUI
import AppKit

struct PrefsView: View {
  
  @Binding var show : Bool
  @State var showDockIcon : Bool = Preferences.showDockIcon
  
  var body: some View {
    
    VStack {
      Form {
        Group {
          Toggle("Show icon in the Dock as well as menu", isOn: $showDockIcon)
            .onChange(of: showDockIcon) { _ in
              DispatchQueue.main.async { Preferences.showDockIcon = showDockIcon }
              DockIcon.standard.setVisibility(showDockIcon)
            }
        }
        .padding(2)
        
      }
      VStack {
        Button("Done") { show = false }
      }
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
      
      Spacer()

      Link("\(Image(systemName: "link.circle")) RSwitch Home", destination: URL(string: "https://github.com/hrbrmstr/RSwitch")!)
      Divider()
      Link("\(Image(systemName: "link.circle")) macOS for R Developers",  destination: URL(string: "https://mac.r-project.org")!)
      Link("\(Image(systemName: "link.circle")) R for macOS (CRAN)",  destination: URL(string: "https://cran.r-project.org/bin/macosx/")!)
      
      Spacer()
      
      Footer(prefsShowing: $prefsShowing)
      
    }
    .padding(10)
    .frame(minWidth: 300.0, alignment: .top)
    .cornerRadius(5)
    .sheet(isPresented: $prefsShowing, content: {
      PrefsView(show: $prefsShowing)
    })
    
  }
}

