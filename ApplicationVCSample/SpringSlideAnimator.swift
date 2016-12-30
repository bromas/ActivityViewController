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
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.7
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    toView!.translatesAutoresizingMaskIntoConstraints = false
    let container = transitionContext.containerView
    
    container.backgroundColor = UIColor.black
    container.addSubview(toView!)
    let centerXTo = constrainEdgesOf(toView!, toEdgesOf: container)
    centerXTo.constant = container.bounds.width + 16
    container.layoutIfNeeded()
    
    let animations = { () -> Void in
      centerXTo.constant = 0
      fromView!.transform = CGAffineTransform(translationX: -container.bounds.width - 16, y: 0.0)
      container.layoutIfNeeded()
    }
    
    let completion : (Bool) -> Void = { (didComplete) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      return
    }
    
    UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(rawValue: 0), animations: animations, completion: completion)
  }
  
  func animationEnded(_ transitionCompleted: Bool) {
    
  }
}
