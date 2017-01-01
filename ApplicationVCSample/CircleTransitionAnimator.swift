//
//  CircleTransitionAnimator.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 5/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

public enum CircleMaskDirection {
  case inward
  case outward
}

open class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
  
  open var animationDuration: TimeInterval = 0.6
  open var maskingDirection: CircleMaskDirection = .inward
  
  fileprivate var currentTransitionContext: UIViewControllerContextTransitioning?
  fileprivate var fromView: UIView!
  fileprivate var toView: UIView!
  fileprivate var container: UIView!
  
  public init(direction: CircleMaskDirection, duration: TimeInterval) {
    animationDuration = duration
    maskingDirection = direction
    super.init()
  }
  
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    currentTransitionContext = transitionContext
    fromView = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from))?.view!
    toView = (transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to))?.view!
    container = transitionContext.containerView
    
    let x = container.bounds.size.width / 2.0
    let y = container.bounds.size.height / 2.0
    let circleRadius = sqrt(x*x + y*y)
    
    let xDifference = circleRadius - x
    let yDifference = circleRadius - y
    
    let rect = CGRect(x: -xDifference/2.0, y: -yDifference/2.0, width: 2.0 * circleRadius, height: 2.0 * circleRadius)
    let insetRect = rect.insetBy(dx: rect.size.width / 2.0 - 2.0, dy: rect.size.height / 2.0 - 2.0)
    let smallPath = CGPath(ellipseIn: insetRect, transform: nil)
    let fullPath = CGPath(ellipseIn: rect, transform: nil)
    
    let maskLayer = circularMaskLayer(rect)
    maskLayer.path = smallPath
    
    let maskedView: UIView
    switch maskingDirection {
    case .inward:
      maskedView = fromView
      container.insertSubview(toView, at: 0)
    case .outward:
      maskedView = toView
      container.addSubview(toView)
    }
    
    maskedView.layer.mask = maskLayer
    maskLayer.masksToBounds = true
    
    let animation = CABasicAnimation(keyPath: "path")
    animation.duration = self.transitionDuration(using: transitionContext)
    animation.delegate = self
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    switch maskingDirection {
    case .inward:
      animation.fromValue = fullPath
      animation.toValue = smallPath
    case .outward:
      animation.fromValue = smallPath
      animation.toValue = fullPath
    }
    
    maskLayer.add(animation, forKey: "MaskLayerAnimation")
    
    switch maskingDirection {
    case .inward:
      maskLayer.path = smallPath
    case .outward:
      maskLayer.path = fullPath
    }
  }
  
  fileprivate func circularMaskLayer(_ frame: CGRect) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.fillColor = UIColor.black.cgColor
    layer.frame = frame
    layer.path = CGPath(ellipseIn: frame, transform: nil)
    return layer
  }
  
  open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      toView.layer.masksToBounds = false
      fromView.layer.masksToBounds = false
      toView.layer.mask = nil
      fromView.layer.mask = nil
      fromView.removeFromSuperview()
      toView = .none
      fromView = .none
      currentTransitionContext?.completeTransition(true)
      currentTransitionContext = nil
    }
  }
}
