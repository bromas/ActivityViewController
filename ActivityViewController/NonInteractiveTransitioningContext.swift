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
  
  @available(iOS 10.0, *)
  public func pauseInteractiveTransition() {
    return
  }
  
  fileprivate let managedController: UIViewController
  fileprivate let fromViewController: UIViewController
  fileprivate let toViewController: UIViewController
  fileprivate let container: UIView
  
  fileprivate let viewControllers: [UITransitionContextViewControllerKey : UIViewController]
  fileprivate let views: [UITransitionContextViewKey : UIView]
  
  func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? { return viewControllers[key] }
  func view(forKey key: UITransitionContextViewKey) -> UIView? { return views[key] }
  
  init(managedController: UIViewController, fromViewController: UIViewController, toViewController: UIViewController) {
    self.managedController = managedController
    self.fromViewController = fromViewController
    self.toViewController = toViewController
    self.container = fromViewController.view.superview!
    self.viewControllers = [UITransitionContextViewControllerKey(rawValue: UITransitionContextViewControllerKey.from.rawValue) : fromViewController, UITransitionContextViewControllerKey(rawValue: UITransitionContextViewControllerKey.to.rawValue) : toViewController]
    self.views = [UITransitionContextViewKey(rawValue: UITransitionContextViewKey.from.rawValue): fromViewController.view, UITransitionContextViewKey(rawValue: UITransitionContextViewKey.to.rawValue): toViewController.view]
    super.init()
  }
  
  var completionBlock : (Bool) -> Void = { (someBool) in }
  func completeTransition(_ didComplete: Bool) {
    completionBlock(didComplete)
  }
  
  var containerView : UIView { return container }
  
  func initialFrame(for vc: UIViewController) -> CGRect {
    if vc == viewControllers[UITransitionContextViewControllerKey.from] {
      return self.managedController.view.frame
    } else {
      return CGRect.zero
    }
  }
  
  func finalFrame(for vc: UIViewController) -> CGRect {
    if vc == viewControllers[UITransitionContextViewControllerKey.from] {
      return CGRect.zero
    } else {
      return self.managedController.view.frame
    }
  }
  
  // Defaults for a custom animated noninteractive transition
  var isAnimated : Bool { return true }
  var isInteractive : Bool { return false }
  var presentationStyle : UIModalPresentationStyle { return UIModalPresentationStyle.custom }
  var targetTransform : CGAffineTransform { return CGAffineTransform(a: 0, b: 0, c: 0, d: 0, tx: 0, ty: 0) }
  
  // Interactive Transitioning / Transform
  var transitionWasCancelled : Bool { return false }
  func updateInteractiveTransition(_ percentComplete: CGFloat) { }
  func finishInteractiveTransition() { }
  func cancelInteractiveTransition() { }
}
