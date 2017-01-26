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
  
  fileprivate weak var managedContainer : UIViewController?
  
  init (containerController: UIViewController?) {
    managedContainer = containerController
  }
  
  internal func animate(_ animator: UIViewControllerAnimatedTransitioning, fromVC: UIViewController, toVC: UIViewController, completion: @escaping () -> Void = { }) {
    
    guard let container = managedContainer else {
      return
    }
    
    prepareAutoresizingContainmentFor(toVC, inController: managedContainer)
    fromVC.willMove(toParentViewController: nil);
    
    let transitionContext = NonInteractiveTransitionContext(managedController: container, fromViewController: fromVC, toViewController: toVC)
    
    transitionContext.completionBlock = { completed in
      fromVC.view.removeFromSuperview()
      fromVC.removeFromParentViewController()
      toVC.didMove(toParentViewController: self.managedContainer)
      animator.animationEnded?(completed)
      completion()
    }
    
    animator.animateTransition(using: transitionContext)
  }
}
