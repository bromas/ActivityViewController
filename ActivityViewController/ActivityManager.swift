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
  case current(Activity)
  case error
  case first(Activity)
  case fresh(Activity)
  case retrieved(Activity)
  
  internal var description : String {
    get {
      switch self {
      case .current(let activity):
        return "Current: \(activity.identifier)"
      case .first(let activity):
        return "First: \(activity.identifier)"
      case .fresh(let activity):
        return "Fresh: \(activity.identifier)"
      case .retrieved(let activity):
        return "Retrieved: \(activity.identifier)"
      default:
        return "Error."
      }
    }
  }
}

internal class ActivityManager {
  
  var activeActivity : Activity?
  var inactiveActivities: [Activity] = []
  fileprivate let activityProvider = ActivityProvider()
  
  init () { }
  
  func registerGenerator(_ identifier: String, generator: @escaping ActivityGenerator) {
    activityProvider.registerGenerator(identifier, generator: generator)
  }
  
  func flushInactiveActivitiesForIdentifier(_ identifier: String) -> Void {
    let containedActivity = inactiveActivities.filter { $0.identifier == identifier }
    if let foundActivity = containedActivity.first {
      inactiveActivities.remove(at: inactiveActivities.index(of: foundActivity)!)
      flushInactiveActivitiesForIdentifier(identifier)
    }
  }
  
  func activityForIdentifier(_ identifier: String) -> ActivityResult {
    // If no activeActivity - this is the first activity
    guard let currentActivity = activeActivity else {
      let activity = activityProvider.activityFromIdentifier(identifier)
      activeActivity = activity
      return .first(activity)
    }
    
    // If the identifier matches - this is the current activity
    guard currentActivity.identifier != identifier else {
      return .current(currentActivity)
    }
    
    // If the identifier exists in the inactive activities - retrieve it and make it active.
    let containedActivity = inactiveActivities.filter { $0.identifier == identifier }
    if let foundActivity = containedActivity.first {
      inactiveActivities.remove(at: inactiveActivities.index(of: foundActivity)!)
      inactiveActivities.append(currentActivity)
      activeActivity = foundActivity
      return .retrieved(foundActivity)
    }
    
    // After passing the previous checks we have a 'next' activity that wasn't in the inactive/retrieve cache.
    // Move the current activity to the inactive activies and present the new one as fresh
    self.inactiveActivities.append(currentActivity)
    let activity = activityProvider.activityFromIdentifier(identifier)
    activeActivity = activity
    return .fresh(activity)
  }
  
}


// imprecise functions
extension ActivityManager {
  // TODO: this will not always return the correct activity - consider caching the string.
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


// Unused functions
extension ActivityManager {
  func setController(_ controller: UIViewController, forActivityIdentifier identifier: String) -> Void {
    let new = Activity(identifier: identifier, controller: controller)
    inactiveActivities.append(new)
  }
}
