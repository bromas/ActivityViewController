//
//  AnimateNonInteractiveTransitionManager.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/1/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal struct AnimateNonInteractiveTransitionManager {
  
  private let managedContainer : UIViewController
  
  init (containerController: UIViewController) {
    managedContainer = containerController
  }
  
  internal func animate(animator: UIViewControllerAnimatedTransitioning, fromVC: UIViewController, toVC: UIViewController, completion: () -> Void = { }) {
    prepareAutoresizingContainmentFor(toVC, inController: managedContainer)
    fromVC.willMoveToParentViewController(nil);
    
    let transitionContext = NonInteractiveTransitionContext(managedController: managedContainer, fromViewController: fromVC, toViewController: toVC)
    
    transitionContext.completionBlock = { completed in
      fromVC.view.removeFromSuperview()
      fromVC.removeFromParentViewController()
      toVC.didMoveToParentViewController(self.managedContainer)
      animator.animationEnded?(completed)
      completion()
    }
    
    animator.animateTransition(transitionContext)
  }
}
