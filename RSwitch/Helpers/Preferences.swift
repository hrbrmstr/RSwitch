//
// Preference handling is annoying
//

import Foundation
import AppKit

fileprivate let defaults: UserDefaults = UserDefaults.standard

extension Bool {
  var stateValue: NSControl.StateValue { return self.toStateValue() }
  private func toStateValue() -> NSControl.StateValue { return(self ? .on : .off) }
}

extension UserDefaults {
  
  enum Key: String {
    case showDockIcon = "showDockIcon"
    case hourlyRStudioCheck = "hourlyRStudioCheck"
    case hourlyRStudioProCheck = "hourlyRStudioProCheck"
    case ensureFileHandlers = "ensureFileHandlers"
    case firstRunGone = "firstRunGone"
    case lastVersionNotified = "lastVersionNotified"
    case lastProVersionNotified = "lastProVersionNotified"
    case notificationsAllowed = "notificationsAllowed"
  }
  
  func set<T>(_ value: T, forKey key: Key) { set(value, forKey: key.rawValue) }
  func bool(forKey key: Key) -> Bool { return(bool(forKey: key.rawValue)) }
  func string(forKey key: Key) -> String? { return(string(forKey: key.rawValue)) }
  func integer(forKey key: Key) -> Int? { return(integer(forKey: key.rawValue)) }
  func url(forKey key: Key) -> URL? { return(url(forKey: key.rawValue)) }
  
}

struct DockIcon {
  
  static var standard = DockIcon()
  
  var isVisible: Bool {
    get { return(NSApp.activationPolicy() == .regular) }
    set { setVisibility(newValue) }
  }
  
  @discardableResult
  func setVisibility(_ state: Bool) -> Bool {
    NSApp.setActivationPolicy(state ? .regular : .accessory)
    return(isVisible)
  }
  
}

struct Preferences {
  
  static var hourlyRStudioCheck: Bool {
    get { return(defaults.bool(forKey: .hourlyRStudioCheck)) }
    set {
      defaults.set(newValue, forKey: .hourlyRStudioCheck)
      defaults.synchronize()
    }
  }
  
  static var hourlyRStudioProCheck: Bool {
    get { return(defaults.bool(forKey: .hourlyRStudioProCheck)) }
    set {
      defaults.set(newValue, forKey: .hourlyRStudioProCheck)
      defaults.synchronize()
    }
  }

  static var showDockIcon: Bool {
    get { return(defaults.bool(forKey: .showDockIcon)) }
    set {
      defaults.set(newValue, forKey: .showDockIcon)
      defaults.synchronize()
    }
  }

  static var firstRunGone: Bool {
    get { return(defaults.bool(forKey: .firstRunGone)) }
    set {
      defaults.set(newValue, forKey: .firstRunGone)
      defaults.synchronize()
    }
  }
  
  static var notificationsAllowed: Bool {
    get { return(defaults.bool(forKey: .notificationsAllowed)) }
    set {
      defaults.set(newValue, forKey: .notificationsAllowed)
      defaults.synchronize()
    }
  }
  
  static var lastVersionNotified : String {
    get {
      let x = defaults.string(forKey: .lastVersionNotified)
      return((x == nil) ? "" : x!)
    }
    set {
      defaults.set(newValue, forKey: .lastVersionNotified)
      defaults.synchronize()
    }
  }
  
  static var lastProVersionNotified : String {
    get {
      let x = defaults.string(forKey: .lastProVersionNotified)
      return((x == nil) ? "" : x!)
    }
    set {
      defaults.set(newValue, forKey: .lastProVersionNotified)
      defaults.synchronize()
    }
  }

  static var ensureFileHandlers: Bool {
    get { return(defaults.bool(forKey: .ensureFileHandlers)) }
    set {
      defaults.set(newValue, forKey: .ensureFileHandlers)
      defaults.synchronize()
    }
  }
  
  static func restore() {
    Preferences.showDockIcon = false
    Preferences.firstRunGone = false
    Preferences.hourlyRStudioCheck = true
    Preferences.hourlyRStudioProCheck = true
    Preferences.ensureFileHandlers = false
    Preferences.notificationsAllowed = true
    Preferences.lastVersionNotified = ""
    Preferences.lastProVersionNotified = ""
  }
  
}

