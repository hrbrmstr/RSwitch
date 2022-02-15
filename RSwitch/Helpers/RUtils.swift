//
// Where the R's are
//

import Foundation

class RUtils {
  
  public static func RDevelURLArm() -> URL {
    return(URL(string: "https://mac.r-project.org/big-sur/R-devel/arm64/R-devel.tar.gz")!)
  }
  
  public static func RDevelURLX86() -> URL {
    return(URL(string: "https://mac.r-project.org/high-sierra/R-devel/x86_64/R-devel.tar.gz")!)
  }

}
