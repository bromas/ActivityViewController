//
//  NonInteractiveTransitioningContext.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal class NonInteractiveTransitionContext : NSObject, UIViewControllerContextTransitioning {
  
  private let managedController: UIViewController
  private let fromViewController: UIViewController
  private let toViewController: UIViewController
  private let container: UIView
  
  private let viewControllers: [String : UIViewController]
  private let views: [String : UIView]
  
  func viewControllerForKey(key: String) -> UIViewController? { return viewControllers[key] }
  func viewForKey(key: String) -> UIView? { return views[key] }
  
  init(managedController: UIViewController, fromViewController: UIViewController, toViewController: UIViewController) {
    self.managedController = managedController
    self.fromViewController = fromViewController
    self.toViewController = toViewController
    self.container = fromViewController.view.superview!
    self.viewControllers = [UITransitionContextFromViewControllerKey : fromViewController, UITransitionContextToViewControllerKey : toViewController]
    self.views = [UITransitionContextFromViewKey: fromViewController.view, UITransitionContextToViewKey: toViewController.view]
    super.init()
  }
  
  var completionBlock : (Bool) -> Void = { (someBool) in }
  func completeTransition(didComplete: Bool) {
    completionBlock(didComplete)
  }
  
  func containerView() -> UIView { return container }
  
  func initialFrameForViewController(vc: UIViewController) -> CGRect {
    if vc == viewControllers[UITransitionContextFromViewControllerKey] {
      return self.managedController.view.frame
    } else {
      return CGRectZero
    }
  }
  
  func finalFrameForViewController(vc: UIViewController) -> CGRect {
    if vc == viewControllers[UITransitionContextFromViewControllerKey] {
      return CGRectZero
    } else {
      return self.managedController.view.frame
    }
  }
  
  // Defaults for a custom animated noninteractive transition
  func isAnimated() -> Bool { return true }
  func isInteractive() -> Bool { return false }
  func presentationStyle() -> UIModalPresentationStyle { return UIModalPresentationStyle.Custom }
  func targetTransform() -> CGAffineTransform { return CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 0, ty: 0) }
  
  // Interactive Transitioning / Transform
  func transitionWasCancelled() -> Bool { return false }
  func updateInteractiveTransition(percentComplete: CGFloat) { }
  func finishInteractiveTransition() { }
  func cancelInteractiveTransition() { }
}