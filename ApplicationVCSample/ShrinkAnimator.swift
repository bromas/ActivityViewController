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
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 0.7
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    toView!.translatesAutoresizingMaskIntoConstraints = false
    let container = transitionContext.containerView()
    
    container!.addSubview(toView!)
    constrainEdgesOf(toView!, toEdgesOf: container!)
    container!.layoutIfNeeded()
    toView?.alpha = 0
    
    let animations = { () -> Void in
      fromView?.transform = CGAffineTransformMakeScale(0.1, 0.1)
      toView?.alpha = 1
      return
    }
    
    let completion : (Bool) -> Void = { (didComplete) in
      fromView?.transform = CGAffineTransformIdentity
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      return
    }
    
    UIView.animateWithDuration(0.7, animations: animations, completion: completion)
  }
  
  func animationEnded(transitionCompleted: Bool) {
    
  }
  
}