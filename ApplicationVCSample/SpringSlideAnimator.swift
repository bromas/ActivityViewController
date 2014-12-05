//
//  SpringSlideAnimator.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

class SpringSlideAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return 0.7
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    var fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    var toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    toView?.setTranslatesAutoresizingMaskIntoConstraints(false)
    var container = transitionContext.containerView()
    
    container.backgroundColor = UIColor.blackColor()
    container.addSubview(toView!)
    let centerXTo = constrainEdgesOf(toView!, toEdgesOf: container)
    centerXTo.constant = container.bounds.width + 16
    container.layoutIfNeeded()
    
    let animations = { () -> Void in
      centerXTo.constant = 0
      fromView?.transform = CGAffineTransformMakeTranslation(-container.bounds.width - 16, 0.0)
      container.layoutIfNeeded()
    }
    
    let completion : (Bool) -> Void = { (didComplete) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
      return
    }
    
    UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(0), animations: animations, completion: completion)
  }
  
  func animationEnded(transitionCompleted: Bool) {
    
  }
}
