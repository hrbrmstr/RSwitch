//
//  Associations.swift
//  RSwitch
//
//  Created by hrbrmstr on 2/11/20.
//  Copyright © 2020 Bob Rudis. All rights reserved.
//

import Foundation
import AppKit
import ApplicationServices

class FileAssociationUtils {
  
//  public static func getHandlers() {
//
//    let workspace = NSWorkspace.shared;
//
//    let setResR : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "R" as CFString, nil)?.takeRetainedValue() as String? ?? "";
//    let handlerR : String = LSCopyDefaultRoleHandlerForContentType(setResR as CFString, LSRolesMask.all)?.takeRetainedValue() as String? ?? "";
//    let rAppUrl : URL = (workspace.urlForApplication(withBundleIdentifier: handlerR))!.appendingPathComponent("Contents/Info.plist");
//    let rAppDict : NSDictionary = NSDictionary(contentsOf: rAppUrl)!;
//    let setResRmd : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "Rmd" as CFString, nil)?.takeRetainedValue() as String? ?? "";
//    let handlerRmd : String = LSCopyDefaultRoleHandlerForContentType(setResRmd as CFString, LSRolesMask.all)?.takeRetainedValue() as String? ?? "";
//    let rmdAppUrl : URL = (workspace.urlForApplication(withBundleIdentifier: handlerRmd))!.appendingPathComponent("Contents/Info.plist");
//    let rmdAppDict : NSDictionary = NSDictionary(contentsOf: rmdAppUrl)!;
//  }
  
  public static func setHandlers() {
    
    let setResR : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "R" as CFString, nil)?.takeRetainedValue() as String? ?? "";

    LSSetDefaultRoleHandlerForContentType(setResR as CFString, LSRolesMask.all, "org.rstudio.RStudio" as CFString);
    
    let setResRmd : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "Rmd" as CFString, nil)?.takeRetainedValue() as String? ?? "";
    
    LSSetDefaultRoleHandlerForContentType(setResRmd as CFString, LSRolesMask.all, "org.rstudio.RStudio" as CFString);

  }
  
}
