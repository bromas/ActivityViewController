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
  case Fresh(Activity)
  case Retrieved(Activity)
  case Current(Activity)
  case Error
  
  internal var description : String {
    get {
      switch self {
      case .Fresh(let activity):
        return "Fresh: \(activity.identifier)"
      case .Retrieved(let activity):
        return "Retrieved: \(activity.identifier)"
      case .Current(let activity):
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
  private let activityProvider = ActivityProvider()
  
  init () { }
  
  func registerStoryboardIdentifier(storyboard: String, forActivityIdentifier identifier: String) {
    activityProvider.registerStoryboardIdentifier(storyboard, forActivityIdentifier: identifier)
  }
  
  func registerGenerator(identifier: String, generator: ActivityGenerator) {
    activityProvider.registerGenerator(identifier, generator: generator)
  }
  
  func flushInactiveActivitiesForIdentifier(identifier: String) -> Void {
    let containedActivity = inactiveActivities.filter{ $0.identifier == identifier }
    if let foundActivity = containedActivity.first {
      inactiveActivities.removeAtIndex(inactiveActivities.indexOf(foundActivity)!)
      flushInactiveActivitiesForIdentifier(identifier)
    }
  }
  
  func setController(controller: UIViewController, forActivityIdentifier identifier: String) -> Void {
    let new = Activity(identifier: identifier, controller: controller)
    inactiveActivities.append(new)
  }
  
  func activityForIdentifier(identifier: String) -> ActivityResult {
    
    if activeActivity?.identifier == identifier
    {
      return .Current(activeActivity!)
    }
    
    let containedActivity = inactiveActivities.filter{ $0.identifier == identifier }
    if let foundActivity = containedActivity.first {
      inactiveActivities.removeAtIndex(inactiveActivities.indexOf(foundActivity)!)
      inactiveActivities.append(activeActivity!)
      activeActivity = foundActivity
      return .Retrieved(foundActivity)
    }
    
    if let foundActivity = activeActivity {
      self.inactiveActivities.append(foundActivity)
    }
    let activity = activityProvider.activityFromIdentifier(identifier)
    activeActivity = activity
    return .Fresh(activeActivity!)
  }
  
  func viewControllerForPreviousActivity() -> ActivityResult {
    if inactiveActivities.count > 0 {
      let previousActivity = inactiveActivities.removeLast()
      activeActivity = previousActivity
      return .Retrieved(previousActivity)
    }
    assert(false, "Attempted to move to a previous controller when none exists.")
    return .Error
  }
  
}
