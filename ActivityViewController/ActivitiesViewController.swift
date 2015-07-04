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

public class ActivityViewController : UIViewController {

  internal var transitionManager: ActivityTransitionManager!
  
  internal let activitiesManager: ActivityManager = ActivityManager()
  
  public var enableLogging: Bool = false
  public var animating: Bool = false
  
  public var initialActivityIdentifier: String?
  
  private var _activeController: UIViewController?
  public var activeViewController : UIViewController? {
    get { return _activeController }
    set {
      _activeController = newValue
      if let found = newValue {
        transitionManager.configureActiveController(found)
      }
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    transitionManager = ActivityTransitionManager(containerController: self)
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let foundIdentifier = initialActivityIdentifier {
      self.performActivityOperation(ActivityOperation(rule: .New, identifier: foundIdentifier))
    }
  }
  
  public func prepareActivity(activity: String, controller: UIViewController) -> Void { }
  
  public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) { }
  
  public func configureInitialActivityIdentifier(identifier: String) {
    initialActivityIdentifier = identifier
  }
  
  public func registerStoryboardIdentifier(storyboard: String, forActivityIdentifier identifier: String) {
    activitiesManager.registerStoryboardIdentifier(storyboard, forActivityIdentifier: identifier)
  }
  
  public func registerGenerator(identifier: String, generator: ActivityGenerator) {
    activitiesManager.registerGenerator(identifier, generator: generator)
  }
  
  public func flushInactiveActivitiesForIdentifier(identifier: String) {
    activitiesManager.flushInactiveActivitiesForIdentifier(identifier)
  }
  
  public func performActivityOperation(operation: ActivityOperation) {
    let activityResult: ActivityResult
    switch operation.selectRule {
    case .New:
      activitiesManager.flushInactiveActivitiesForIdentifier(operation.activityIdentifier)
      activityResult = activitiesManager.activityForIdentifier(operation.activityIdentifier)
    case .Any:
      activityResult = activitiesManager.activityForIdentifier(operation.activityIdentifier)
    case .Previous:
      activityResult = activitiesManager.viewControllerForPreviousActivity()
    }
    processActivityResult(activityResult, withOperation: operation)
  }
  
  func processActivityResult(activityResult: ActivityResult, withOperation operation: ActivityOperation) -> Void {
    if enableLogging { print("Activity: \(activityResult)") }
    switch activityResult {
    case .Fresh(let activity):
      self.prepareActivity(activity.identifier, controller: activity.controller)
      transitionManager.transitionToVC(activity.controller, withOperation: operation)
    case .Retrieved(let activity):
      transitionManager.transitionToVC(activity.controller, withOperation: operation)
    case .Current(_): break
    case .Error: break
    }
  }
  
}