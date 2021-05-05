//
// Froody donut % counters
//

import Foundation
import SwiftUI

struct ProgressBar: View {
  
  @Binding var progress: Float
  
  var body: some View {
    
    ZStack {
      
      Circle()
        .stroke(lineWidth: 4.0)
        .opacity(0.3)
        .foregroundColor(Color(#colorLiteral(red: 0.4604763985, green: 0.6682265997, blue: 0.8600678444, alpha: 1)))
      
      Circle()
        .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
        .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
        .foregroundColor(Color(#colorLiteral(red: 0.4604763985, green: 0.6682265997, blue: 0.8600678444, alpha: 1)))
        .rotationEffect(Angle(degrees: 270.0))
        .animation(.linear)
      
      Text(String(format: "%.0f%%", min(self.progress, 1.0)*100.0))
        .font(.caption)
        .bold()
      
    }
    
  }
  
}
