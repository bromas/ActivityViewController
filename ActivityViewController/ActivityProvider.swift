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
  
  fileprivate var activityStoryboardNames: [String : String] = [String : String]()
  fileprivate var activityGenerators: [String: ActivityGenerator] = ["defaultController": { return UIViewController() }]
  
  init () { }
  
  func registerGenerator(_ identifier: String, generator: @escaping ActivityGenerator) {
    self.activityGenerators[identifier] = generator
  }
  
  // Checks first for a generator and then for a storyboard with the identifiers name - loads the initial view controller.
  func activityFromIdentifier(_ identifier: String) -> Activity {
    var controller: UIViewController
    if let generator = activityGenerators[identifier] {
      controller = generator()
    } else {
      controller = self.loadStoryboard(withActivityName: identifier)
    }
    return Activity(identifier: identifier, controller: controller)
  }
  
  fileprivate func loadStoryboard(withActivityName activity: String) -> UIViewController {
    let controller = UIStoryboard(name: activity, bundle: Bundle.main).instantiateInitialViewController()
    if let initialized = controller {
      return initialized
    }
    assert(false, "Attempted to start an activity without a properly registered storyboard.")
    return UIViewController()
  }
}

func storyboardIdentifierFromActivityIdentifier(_ identifier: String) -> String {
  if identifier.range(of: "#") != nil {
    return identifier.components(separatedBy: "#")[0]
  } else {
    return identifier
  }
}

func controllerForStoryboard(_ storyboard: String, activityName: String) -> UIViewController? {
  if activityName.range(of: "#") != nil {
    let boardName = activityName.components(separatedBy: "#")
    return UIStoryboard(name: storyboard, bundle: Bundle.main).instantiateViewController(withIdentifier: boardName[1])
  } else {
    
  }
  return UIViewController()
}
