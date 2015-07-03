//
//  ActivityProvider.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 2/1/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal struct Activity : Equatable {
  var identifier: String
  var controller: UIViewController
}

func ==(lhs: Activity, rhs: Activity) -> Bool {
  return lhs.identifier == rhs.identifier
}

internal class ActivityProvider {
  
  private var activityStoryboardNames: [String : String] = [String : String]()
  private var activityGenerators: [String: ActivityGenerator] = ["defaultController": { return UIViewController() }]
  
  init () { }
  
  func registerStoryboardIdentifier(storyboard: String, forActivityIdentifier identifier: String) {
    self.activityStoryboardNames[identifier] = storyboard
  }
  
  func registerGenerator(identifier: String, generator: ActivityGenerator) {
    self.activityGenerators[identifier] = generator
  }
  
  func activityFromIdentifier(identifier: String) -> Activity {
    var controller: UIViewController
    if let generator = activityGenerators[identifier] {
      controller = generator()
    } else {
      let storyboardName = self.activityStoryboardNames[storyboardIdentifierFromActivityIdentifier(identifier)] ?? identifier
      controller = self.loadStoryboard(storyboardName, withActivityName: identifier)
    }
    return Activity(identifier: identifier, controller: controller)
  }
  
  private func loadStoryboard(storyboardName: String, withActivityName activity: String) -> UIViewController {
    let controller = UIStoryboard(name: storyboardName, bundle: NSBundle.mainBundle()).instantiateInitialViewController()
    if let initialized = controller {
      return initialized
    }
    assert(false, "Attempted to start an activity without a properly registered storyboard.")
    return UIViewController()
  }
}

func storyboardIdentifierFromActivityIdentifier(identifier: String) -> String {
  if identifier.rangeOfString("#") != nil {
    return identifier.componentsSeparatedByString("#")[0]
  } else {
    return identifier
  }
}

func controllerForStoryboard(storyboard: String, activityName: String) -> UIViewController? {
  if activityName.rangeOfString("#") != nil {
    let boardName = activityName.componentsSeparatedByString("#")
    return UIStoryboard(name: storyboard, bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier(boardName[1])
  } else {
    
  }
  return UIViewController()
}
