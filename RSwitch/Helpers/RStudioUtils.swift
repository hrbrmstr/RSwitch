//
// Helpers that deal with talking to the RStudio download pages and turning HTML into data
//

import Foundation

import Foundation
import SwiftSoup
import Just

class RStudioUtils {
  
  var pro: String { get {
    return(RStudioUtils.latestProVersionURL().absoluteString)
  } }
  
  public static func latestProVersionURL() -> URL {
    let res = Just.get("https://dailies.rstudio.com/rstudio/pro/mac/index.html?\(String(Date().timeIntervalSince1970))", timeout: 10)
    if (res.ok) {
      do {
        let doc = try SwiftSoup.parse(String(decoding: res.content!, as: UTF8.self))
        let anchor = try doc.select("td.filename > a").first()!.text()
        return(URL(string: "https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/\(anchor)")!)
      } catch {
      }
    }
    return(res.url!)
  }

  public static func latestProVersionNumber(fromString : String? = nil) -> String {
    let urlString = (fromString == nil) ? latestProVersionURL().absoluteString : fromString!
    return(
      urlString // https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/RStudio-pro-1.4.1038-1.dmg
        .replacingOccurrences(of: "https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/RStudio-pro-", with: "")
        .replacingOccurrences(of: ".dmg", with: "")
    )
  }
  
  public static func latestVersionURL() -> URL {
    let res = Just.get("https://dailies.rstudio.com/rstudio/oss/mac/index.html?\(String(Date().timeIntervalSince1970))", timeout: 10)
    if (res.ok) {
      do {
        let doc = try SwiftSoup.parse(String(decoding: res.content!, as: UTF8.self))
        let anchor = try doc.select("td.filename > a").first()!.text()
        return(URL(string: "https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/\(anchor)")!)
      } catch {
      }
    }
    return(res.url!)
  }
  
  public static func latestVersionNumber(fromString : String? = nil) -> String {
    let urlString = (fromString == nil) ? latestVersionURL().absoluteString : fromString!
    return(
      urlString // https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/RStudio-1.4.1038.dmg
        .replacingOccurrences(of: "https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/RStudio-", with: "")
        .replacingOccurrences(of: ".dmg", with: "")
    )
  }
  
}
