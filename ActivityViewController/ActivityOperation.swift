//
//  ActivityOperation.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 2/18/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

public enum ActivityOperationType {
  case None
  case AnimationOption
  case NonInteractiveTransition
  case TransitioningDelegate
  case Presented
}

public enum ActivityOperationRule {
  case New
  case Any
  case Previous
}

public struct ActivityOperation {
  
  internal var type = ActivityOperationType.AnimationOption
  internal var selectRule = ActivityOperationRule.Any
  internal var animationOption = UIViewAnimationOptions.TransitionCrossDissolve
  internal var animationDuration = 0.3
  internal var nonInteractiveTranstionanimator : UIViewControllerAnimatedTransitioning!
  public var completionBlock : () -> Void = { }
  
  internal let activityIdentifier: String
  
  public init (rule: ActivityOperationRule = .Any, identifier: String = "") {
    selectRule = rule
    activityIdentifier = identifier
    type = .None
  }
  
  public init (rule: ActivityOperationRule = .Any, identifier: String, animator: UIViewControllerAnimatedTransitioning) {
    selectRule = rule
    activityIdentifier = identifier
    type = .NonInteractiveTransition
    nonInteractiveTranstionanimator = animator
  }
  
  public init (rule: ActivityOperationRule = .Any, identifier: String, animationType: UIViewAnimationOptions, duration: Double) {
    selectRule = rule
    activityIdentifier = identifier
    type = .AnimationOption
    animationOption = animationType
    animationDuration = duration
  }
  
  public func execute () {
    let delegate =  UIApplication.sharedApplication().delegate
    let rootController = delegate?.window??.rootViewController as? ActivityViewController
    if let appVC = rootController {
      appVC.performActivityOperation(self)
    }
    else {
      assert(false, "You are not managing your application with an application view controller. Please refer to the documentation.")
    }
  }
}

