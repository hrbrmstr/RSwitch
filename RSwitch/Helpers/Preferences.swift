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
    case ensureFileHandlers = "ensureFileHandlers"
    case firstRunGone = "firstRunGone"
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
    Preferences.ensureFileHandlers = false
    Preferences.notificationsAllowed = true
  }
  
}

