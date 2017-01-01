//
//  ShrinkAnimator.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/1/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class ShrinkAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.7
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    toView!.translatesAutoresizingMaskIntoConstraints = false
    let container = transitionContext.containerView
    
    container.addSubview(toView!)
    constrainEdgesOf(toView!, toEdgesOf: container)
    container.layoutIfNeeded()
    toView?.alpha = 0
    
    let animations = { () -> Void in
      fromView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
      toView?.alpha = 1
      return
    }
    
    let completion : (Bool) -> Void = { (didComplete) in
      fromView?.transform = CGAffineTransform.identity
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      return
    }
    
    UIView.animate(withDuration: 0.7, animations: animations, completion: completion)
  }
  
  func animationEnded(_ transitionCompleted: Bool) {
    
  }
  
}
