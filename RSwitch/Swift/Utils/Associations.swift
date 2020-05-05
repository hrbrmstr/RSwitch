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
  
  public static func getHandlers() {
    
    let workspace = NSWorkspace.shared;

    let setResR : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "R" as CFString, nil)?.takeRetainedValue() as String? ?? "";
    NSLog("UTI of .R extension: " + setResR);
    
    let  handlerR : String = LSCopyDefaultRoleHandlerForContentType(setResR as CFString, LSRolesMask.all)?.takeRetainedValue() as String? ?? "";
    NSLog("Bundle ID of handler for .R files is: [" + handlerR + "]");
    
    let rAppUrl : URL = (workspace.urlForApplication(withBundleIdentifier: handlerR))!.appendingPathComponent("Contents/Info.plist");
    NSLog("The Info.plist for the app that handles .R files is: " + rAppUrl.absoluteString);

    let rAppDict : NSDictionary = NSDictionary(contentsOf: rAppUrl)!;
    NSLog("The name of the app that handles .R files is: " + (rAppDict.object(forKey: "CFBundleName") as! String));
        
    let setResRmd : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "Rmd" as CFString, nil)?.takeRetainedValue() as String? ?? "";
    NSLog("UTI of .Rmd extension: " + setResRmd);

    let  handlerRmd : String = LSCopyDefaultRoleHandlerForContentType(setResRmd as CFString, LSRolesMask.all)?.takeRetainedValue() as String? ?? "";
    NSLog("Bundle ID of handler for .Rmd files is: [" + handlerRmd + "]");

    let rmdAppUrl : URL = (workspace.urlForApplication(withBundleIdentifier: handlerRmd))!.appendingPathComponent("Contents/Info.plist");
    NSLog("The Info.plist for the app that handles .Rmd files is: " + rmdAppUrl.absoluteString);

    let rmdAppDict : NSDictionary = NSDictionary(contentsOf: rmdAppUrl)!;
    NSLog("The name of the app that handles .Rmd files is: " + (rmdAppDict.object(forKey: "CFBundleName") as! String));

  }
  
  public static func setHandlers() {
    
    let setResR : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "R" as CFString, nil)?.takeRetainedValue() as String? ?? "";
    //NSLog("UTI of .R extension: " + setResR);

    LSSetDefaultRoleHandlerForContentType(setResR as CFString, LSRolesMask.all, "org.rstudio.RStudio" as CFString);
    
    let setResRmd : String = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, "Rmd" as CFString, nil)?.takeRetainedValue() as String? ?? "";
    //NSLog("UTI of .Rmd extension: " + setResRmd);
    
    LSSetDefaultRoleHandlerForContentType(setResRmd as CFString, LSRolesMask.all, "org.rstudio.RStudio" as CFString);

  }
  
}
