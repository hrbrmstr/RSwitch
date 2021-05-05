import Foundation
import AppKit
import SwiftUI

// All this for easy image resizing on the SwiftUI side

extension NSImage {
  
  func resized(to newSize: NSSize) -> NSImage? {
    
    if let bitmapRep = NSBitmapImageRep(
      
      bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
      bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
      colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0
      
    ) {
      
      bitmapRep.size = newSize
      NSGraphicsContext.saveGraphicsState()
      NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
      draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
      NSGraphicsContext.restoreGraphicsState()
      
      let resizedImage = NSImage(size: newSize)
      resizedImage.addRepresentation(bitmapRep)
      
      return(resizedImage)
      
    }
    
    return(nil)
    
  }
  
}

// Abusing thje String class to deal with R version numbers

extension String {
  
  /// Inner comparison utility to handle same versions with different length. (Ex: "1.0.0" & "1.0")
  private func compare(toVersion targetVersion: String) -> ComparisonResult {
    
    let versionDelimiter = "."
    var result: ComparisonResult = .orderedSame
    var versionComponents = components(separatedBy: versionDelimiter)
    var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
    let spareCount = versionComponents.count - targetComponents.count
    
    if spareCount == 0 {
      result = compare(targetVersion, options: .numeric)
    } else {
      let spareZeros = repeatElement("0", count: abs(spareCount))
      if spareCount > 0 {
        targetComponents.append(contentsOf: spareZeros)
      } else {
        versionComponents.append(contentsOf: spareZeros)
      }
      result = versionComponents.joined(separator: versionDelimiter)
        .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
    }
    return result
  }
  
  public func isVersion(equalTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedSame }
  public func isVersion(greaterThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedDescending }
  public func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedAscending }
  public func isVersion(lessThan targetVersion: String) -> Bool { return compare(toVersion: targetVersion) == .orderedAscending }
  public func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool { return compare(toVersion: targetVersion) != .orderedDescending }
  
}
