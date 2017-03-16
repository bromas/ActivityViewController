//
//  ActivitiesViewController.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 4/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

public typealias ActivityGenerator = () -> UIViewController

open class ActivityViewController : UIViewController {
  
  open var enableLogging: Bool = false
  open var animating: Bool = false
  
  internal var transitionManager: ActivityTransitionManager!
  internal let activitiesManager: ActivityManager = ActivityManager()
  private var hasInitialized: Bool = false
  
  open var initialActivityIdentifier: String?
  
  // Runs on the first display of a controller.
  open var configureContainerView: (UIView) -> () = { view in }
  
  // Runs when an activity is first initialized
  open var activityInitiationClosure: (_ identifer: String, _ controller: UIViewController) -> () = { identifier, controller in }
  
  // Runs each time an activity is presented.
  open var activityConfigurationClosure: (_ identifer: String, _ controller: UIViewController) -> () = { identifier, controller in }
  
  
  /* Lifecycle */
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    transitionManager = ActivityTransitionManager(containerController: self)
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let foundIdentifier = initialActivityIdentifier, !hasInitialized {
      if case .first(let activity) = activitiesManager.activityForIdentifier(foundIdentifier) {
        _ = transitionManager.initializeDisplayWithController(activity.controller)
      }
    }
    hasInitialized = true
  }
  /* End Lifecycle */
  
  
  open func registerGenerator(_ identifier: String, generator: @escaping ActivityGenerator) {
    activitiesManager.registerGenerator(identifier, generator: generator)
  }
  
  open func flushInactiveActivitiesForIdentifier(_ identifier: String) {
    activitiesManager.flushInactiveActivitiesForIdentifier(identifier)
  }
  
  // TODO: Cannot display a new controller of the same activityIdentifier atm. Refactor previous activity or activity stack to be queriable?
  open func performActivityOperation(_ operation: ActivityOperation) {
    // ignores calls to perform an activity operation while the controller is still animating.
    guard !animating else {
      return
    }
    
    let activityResult: ActivityResult
    switch operation.selectRule {
    case .new:
      activitiesManager.flushInactiveActivitiesForIdentifier(operation.activityIdentifier)
      activityResult = activitiesManager.activityForIdentifier(operation.activityIdentifier)
    case .any:
      activityResult = activitiesManager.activityForIdentifier(operation.activityIdentifier)
    case .previous:
      activityResult = activitiesManager.viewControllerForPreviousActivity()
    }
    processActivityResult(activityResult, withOperation: operation)
  }
  
  fileprivate func processActivityResult(_ activityResult: ActivityResult, withOperation operation: ActivityOperation) -> Void {
    if enableLogging { print("Activity: \(activityResult)") }
    switch activityResult {
    case .first(let activity), .fresh(let activity):
      activityInitiationClosure(activity.identifier, activity.controller)
      activityConfigurationClosure(activity.identifier, activity.controller)
      transitionManager.transitionToVC(activity.controller, withOperation: operation)
    case .retrieved(let activity):
      activityConfigurationClosure(activity.identifier, activity.controller)
      transitionManager.transitionToVC(activity.controller, withOperation: operation)
    case .current(_): break
    case .error: break
    }
  }
  
}


// Helper functions for finding the right ActivityViewController to call operations on.
extension ActivityViewController {
  public static var rootController: ActivityViewController? {
    let delegate =  UIApplication.shared.delegate
    let rootController = delegate?.window??.rootViewController as? ActivityViewController
    if let appVC = rootController {
      return appVC
    } else {
      return .none
    }
  }
  
  // Only works if the controller is a child controller of the activityVC (it must be the active activities controller.)
  public static func closestParentOfController(_ controller: UIViewController) -> ActivityViewController? {
    var inspectedController: UIViewController? = controller
    while inspectedController != .none {
      let parent = inspectedController?.parent
      if let parentActivity = parent as? ActivityViewController {
        return parentActivity
      }
      
      inspectedController = parent
    }
    return .none
  }
}

