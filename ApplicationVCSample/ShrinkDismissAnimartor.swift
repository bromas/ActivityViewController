//
//  ShrinkDismissAnimartor.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation

import Foundation
import QuartzCore
import UIKit

class ShrinkDismissAnimator : NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.8
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    let container = transitionContext.containerView
    
    toView!.translatesAutoresizingMaskIntoConstraints = false
    
    container.backgroundColor = UIColor.black
    container.addSubview(toView!)
    let centerXTo = constrainEdgesOf(toView!, toEdgesOf: container)
    centerXTo.constant = container.bounds.width + 20
    container.layoutIfNeeded()
    toView?.alpha = 1
    
    let animations = { () -> Void in
      var transform = CATransform3DConcat(CATransform3DMakeRotation(0.8, 0, 1, 0), CATransform3DMakeScale(0.9, 0.9, 1))
      transform.m34 =  -1.0 / 2000.0
      
      let transformAnimation = CABasicAnimation(keyPath: "transform")
      transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DIdentity, CATransform3DMakeTranslation(0, 0, -1000)))
      let finalTransform = CATransform3DConcat(transform, CATransform3DMakeTranslation(0, 0, -1000))
      let finalTranslated = CATransform3DConcat(finalTransform, CATransform3DMakeTranslation(50, 0, 0))
      transformAnimation.toValue = NSValue(caTransform3D: finalTranslated)
      
      let fadeAnimation = CABasicAnimation(keyPath: "opacity")
      fadeAnimation.fromValue = 1.0
      fadeAnimation.toValue = 0.1
      
      let animationGroup = CAAnimationGroup()
      animationGroup.animations = [fadeAnimation, transformAnimation]
      animationGroup.duration = 0.8
      animationGroup.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.2, 0.8, 0.1)
      
      fromView?.layer.add(animationGroup, forKey: "rotateScaleFade")
      centerXTo.constant = 0
      container.layoutIfNeeded()
      return
    }
    
    let completion : (Bool) -> Void = { (didComplete) in
      fromView?.transform = CGAffineTransform.identity
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      return
    }
    
    UIView.animate(withDuration: 0.8, animations: animations, completion: completion)
  }
  
  func animationEnded(_ transitionCompleted: Bool) {
    
  }
}
