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

  internal var transitionManager: ActivityTransitionManager!
  
  internal let activitiesManager: ActivityManager = ActivityManager()
  
  open var enableLogging: Bool = false
  open var animating: Bool = false
  
  open var initialActivityIdentifier: String?
  
  fileprivate var _activeController: UIViewController?
  open var activeViewController : UIViewController? {
    get { return _activeController }
    set {
      _activeController = newValue
      if let found = newValue {
        transitionManager.configureActiveController(found)
      }
    }
  }
  
  open var activityConfigurationClosure: (_ identifer: String, _ controller: UIViewController) -> () = { identifier, controller in
    
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    transitionManager = ActivityTransitionManager(containerController: self)
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let foundIdentifier = initialActivityIdentifier {
      self.performActivityOperation(ActivityOperation(rule: .new, identifier: foundIdentifier))
    }
  }
  
  open func prepareActivity(_ activity: String, controller: UIViewController) -> Void {
    activityConfigurationClosure(activity, controller)
  }
  
  open override func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
  
  open func configureInitialActivityIdentifier(_ identifier: String) {
    initialActivityIdentifier = identifier
  }
  
  open func registerStoryboardIdentifier(_ storyboard: String, forActivityIdentifier identifier: String) {
    activitiesManager.registerStoryboardIdentifier(storyboard, forActivityIdentifier: identifier)
  }
  
  open func registerGenerator(_ identifier: String, generator: @escaping ActivityGenerator) {
    activitiesManager.registerGenerator(identifier, generator: generator)
  }
  
  open func flushInactiveActivitiesForIdentifier(_ identifier: String) {
    activitiesManager.flushInactiveActivitiesForIdentifier(identifier)
  }
  
  open func performActivityOperation(_ operation: ActivityOperation) {
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
  
  func processActivityResult(_ activityResult: ActivityResult, withOperation operation: ActivityOperation) -> Void {
    if enableLogging { print("Activity: \(activityResult)") }
    switch activityResult {
    case .fresh(let activity):
      self.prepareActivity(activity.identifier, controller: activity.controller)
      transitionManager.transitionToVC(activity.controller, withOperation: operation)
    case .retrieved(let activity):
      transitionManager.transitionToVC(activity.controller, withOperation: operation)
    case .current(_): break
    case .error: break
    }
  }
  
}
