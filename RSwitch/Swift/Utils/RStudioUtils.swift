//
//  RStudioUtils.swift
//  RSwitch
//
//  Created by hrbrmstr on 9/6/19.
//  Copyright © 2019 Bob Rudis. All rights reserved.
//

import Foundation
import Just

class RStudioUtils {
  
  private static let dailyCleanerRegex = try!NSRegularExpression(
    pattern: "https://s3.amazonaws.com/rstudio-ide-build/desktop/macos/RStudio-|.dmg",
    options: NSRegularExpression.Options.caseInsensitive
  )

  public static func latestVersionURL() -> URL? {
    let res = Just.head("https://www.rstudio.org/download/latest/daily/desktop/mac/RStudio-latest.dmg", timeout: 10)
    return(res.url)
  }
  
  public static func latestVersionNumber(fromString : String? = nil) -> String {
    let urlString = (fromString == nil) ? latestVersionURL()!.absoluteString : fromString!
    return(dailyCleanerRegex.stringByReplacingMatches(in: urlString, options: [], range: NSMakeRange(0, urlString.count), withTemplate: ""))
  }
  
}
