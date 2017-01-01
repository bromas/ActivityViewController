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
  case none
  case animationOption
  case nonInteractiveTransition
  case transitioningDelegate
  case presented
}

public enum ActivityOperationRule {
  case new
  case any
  case previous
}

public struct ActivityOperation {
  
  internal var type = ActivityOperationType.animationOption
  internal var selectRule = ActivityOperationRule.any
  internal var animationOption = UIViewAnimationOptions.transitionCrossDissolve
  internal var animationDuration = 0.3
  internal var nonInteractiveTranstionanimator : UIViewControllerAnimatedTransitioning!
  public var completionBlock : () -> Void = { }
  
  internal let activityIdentifier: String
  
  public init (rule: ActivityOperationRule = .any, identifier: String = "") {
    selectRule = rule
    activityIdentifier = identifier
    type = .none
  }
  
  public init (rule: ActivityOperationRule = .any, identifier: String, animator: UIViewControllerAnimatedTransitioning) {
    selectRule = rule
    activityIdentifier = identifier
    type = .nonInteractiveTransition
    nonInteractiveTranstionanimator = animator
  }
  
  public init (rule: ActivityOperationRule = .any, identifier: String, animationType: UIViewAnimationOptions, duration: Double) {
    selectRule = rule
    activityIdentifier = identifier
    type = .animationOption
    animationOption = animationType
    animationDuration = duration
  }
  
}


