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
  case Inward
  case Outward
}

public class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  public var animationDuration: NSTimeInterval = 0.6
  public var maskingDirection: CircleMaskDirection = .Inward
  
  private var currentTransitionContext: UIViewControllerContextTransitioning?
  private var fromView: UIView!
  private var toView: UIView!
  private var container: UIView!
  
  public init(direction: CircleMaskDirection, duration: NSTimeInterval) {
    animationDuration = duration
    maskingDirection = direction
    super.init()
  }
  
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return animationDuration
  }
  
  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    currentTransitionContext = transitionContext
    fromView = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey))?.view!
    toView = (transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey))?.view!
    container = transitionContext.containerView()
    
    let x = container.bounds.size.width / 2.0
    let y = container.bounds.size.height / 2.0
    let circleRadius = sqrt(x*x + y*y)
    
    let xDifference = circleRadius - x
    let yDifference = circleRadius - y
    
    let rect = CGRect(x: -xDifference/2.0, y: -yDifference/2.0, width: 2.0 * circleRadius, height: 2.0 * circleRadius)
    let insetRect = CGRectInset(rect, rect.size.width / 2.0 - 2.0, rect.size.height / 2.0 - 2.0)
    let smallPath = CGPathCreateWithEllipseInRect(insetRect, nil)
    let fullPath = CGPathCreateWithEllipseInRect(rect, nil)
    
    let maskLayer = circularMaskLayer(rect)
    maskLayer.path = smallPath
    
    let maskedView: UIView
    switch maskingDirection {
    case .Inward:
      maskedView = fromView
      container.insertSubview(toView, atIndex: 0)
    case .Outward:
      maskedView = toView
      container.addSubview(toView)
    }
    
    maskedView.layer.mask = maskLayer
    maskLayer.masksToBounds = true
    
    var animation = CABasicAnimation(keyPath: "path")
    animation.duration = self.transitionDuration(transitionContext)
    animation.delegate = self
    animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    
    switch maskingDirection {
    case .Inward:
      animation.fromValue = fullPath
      animation.toValue = smallPath
    case .Outward:
      animation.fromValue = smallPath
      animation.toValue = fullPath
    }
    
    maskLayer.addAnimation(animation, forKey: "MaskLayerAnimation")
    
    switch maskingDirection {
    case .Inward:
      maskLayer.path = smallPath
    case .Outward:
      maskLayer.path = fullPath
    }
  }
  
  private func circularMaskLayer(frame: CGRect) -> CAShapeLayer {
    var layer = CAShapeLayer()
    layer.fillColor = UIColor.blackColor().CGColor
    layer.frame = frame
    layer.path = CGPathCreateWithEllipseInRect(frame, nil)
    return layer
  }
  
  override public func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
    if flag {
      toView.layer.masksToBounds = false
      fromView.layer.masksToBounds = false
      toView.layer.mask = nil
      fromView.layer.mask = nil
      fromView.removeFromSuperview()
      toView = .None
      fromView = .None
      currentTransitionContext?.completeTransition(true)
      currentTransitionContext = nil
    }
  }
}
