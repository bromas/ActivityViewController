//
//  ActivityManager.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 1/31/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

enum ActivityResult : CustomStringConvertible {
  case fresh(Activity)
  case retrieved(Activity)
  case current(Activity)
  case error
  
  internal var description : String {
    get {
      switch self {
      case .fresh(let activity):
        return "Fresh: \(activity.identifier)"
      case .retrieved(let activity):
        return "Retrieved: \(activity.identifier)"
      case .current(let activity):
        return "Current: \(activity.identifier)"
      default:
        return ""
      }
    }
  }
}

internal class ActivityManager {
  
  var activeActivity : Activity?
  lazy var inactiveActivities: [Activity] = []
  fileprivate let activityProvider = ActivityProvider()
  
  init () { }
  
  func registerStoryboardIdentifier(_ storyboard: String, forActivityIdentifier identifier: String) {
    activityProvider.registerStoryboardIdentifier(storyboard, forActivityIdentifier: identifier)
  }
  
  func registerGenerator(_ identifier: String, generator: @escaping ActivityGenerator) {
    activityProvider.registerGenerator(identifier, generator: generator)
  }
  
  func flushInactiveActivitiesForIdentifier(_ identifier: String) -> Void {
    let containedActivity = inactiveActivities.filter{ $0.identifier == identifier }
    if let foundActivity = containedActivity.first {
      inactiveActivities.remove(at: inactiveActivities.index(of: foundActivity)!)
      flushInactiveActivitiesForIdentifier(identifier)
    }
  }
  
  func setController(_ controller: UIViewController, forActivityIdentifier identifier: String) -> Void {
    let new = Activity(identifier: identifier, controller: controller)
    inactiveActivities.append(new)
  }
  
  func activityForIdentifier(_ identifier: String) -> ActivityResult {
    
    if activeActivity?.identifier == identifier
    {
      return .current(activeActivity!)
    }
    
    let containedActivity = inactiveActivities.filter{ $0.identifier == identifier }
    if let foundActivity = containedActivity.first {
      inactiveActivities.remove(at: inactiveActivities.index(of: foundActivity)!)
      inactiveActivities.append(activeActivity!)
      activeActivity = foundActivity
      return .retrieved(foundActivity)
    }
    
    if let foundActivity = activeActivity {
      self.inactiveActivities.append(foundActivity)
    }
    let activity = activityProvider.activityFromIdentifier(identifier)
    activeActivity = activity
    return .fresh(activeActivity!)
  }
  
  func viewControllerForPreviousActivity() -> ActivityResult {
    if inactiveActivities.count > 0 {
      let previousActivity = inactiveActivities.removeLast()
      activeActivity = previousActivity
      return .retrieved(previousActivity)
    }
    assert(false, "Attempted to move to a previous controller when none exists.")
    return .error
  }
  
}
