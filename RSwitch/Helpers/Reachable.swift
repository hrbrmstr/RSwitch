//
// This lets us not do anything if no internet connection is present.
//

import Foundation
import SwiftUI
import SystemConfiguration

enum ReachabilityStatus {
  case notReachable
  case reachableViaWWAN
  case reachableViaWiFi
}

var currentReachabilityStatus: ReachabilityStatus {
  
  var zeroAddress = sockaddr_in()
  zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
  zeroAddress.sin_family = sa_family_t(AF_INET)
  guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
      SCNetworkReachabilityCreateWithAddress(nil, $0)
    }
  }) else {
    return .notReachable
  }
  
  var flags: SCNetworkReachabilityFlags = []
  if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
    return .notReachable
  }
  
  if flags.contains(.reachable) == false { // not reachable.
    return .notReachable
  } else if flags.contains(.connectionRequired) == false { // on WiFi/LAN
    return .reachableViaWiFi
  } else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false { // user enabled internet access somehow
    return .reachableViaWiFi
  } else {
    return .notReachable
  }
}

