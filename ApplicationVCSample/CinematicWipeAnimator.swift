//
//  CinematicWipeAnimator.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

open class CinematicWipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  open var animationDuration: TimeInterval = 1.0
  fileprivate var isPresenting = true
  
  open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }
  
  open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    toView!.translatesAutoresizingMaskIntoConstraints = false
    let container = transitionContext.containerView
    
    container.insertSubview(toView!, at: 0)
    constrainSizeAndCenter(toView!, toView: container)
    container.layoutIfNeeded()
    
    let toSnapshot = toView!.snapshotView(afterScreenUpdates: true)
    let snapshotContainer = UIView(frame: container.bounds)
    snapshotContainer.translatesAutoresizingMaskIntoConstraints = false
    toSnapshot?.translatesAutoresizingMaskIntoConstraints = false
    snapshotContainer.clipsToBounds = true
    snapshotContainer.backgroundColor = UIColor.black
    
    container.addSubview(snapshotContainer)
    let width = constrainEdges(snapshotContainer, toView: container)
    width.constant = -container.bounds.width
    snapshotContainer.addSubview(toSnapshot!)
    let snapShotConstraints = constrainEdges(toSnapshot!, toView: snapshotContainer)
    snapshotContainer.removeConstraint(snapShotConstraints)
    let widthConstraint = NSLayoutConstraint(item: toSnapshot, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: container.bounds.width)
    toSnapshot?.addConstraint(widthConstraint)
    container.layoutIfNeeded()
  
    UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: UIViewAnimationOptions(), animations: { () -> Void in
      width.constant = 0
      container.layoutIfNeeded()
      toSnapshot?.layoutIfNeeded()
      }) { (complete) -> Void in
        fromView!.removeFromSuperview()
        snapshotContainer.removeFromSuperview()
        transitionContext.completeTransition(true)
        self.isPresenting = !self.isPresenting
    }
  }
  
  fileprivate func constrainSizeAndCenter(_ view: UIView, toView: UIView) -> (width: NSLayoutConstraint, height: NSLayoutConstraint, centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
    let height = NSLayoutConstraint(item: view,attribute: .height, relatedBy: .equal, toItem: toView, attribute: .height, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(height)
    let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: toView, attribute: .width, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(width)
    let centerY = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: toView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(centerY)
    let centerX = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: toView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(centerX)
    return (width, height, centerX, centerY)
  }
  
  fileprivate func constrainEdges(_ view: UIView, toView: UIView) -> NSLayoutConstraint {
    let top = NSLayoutConstraint(item: view,attribute: .top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(top)
    let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: toView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(bottom)
    let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: toView, attribute: .right, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(right)
    let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: toView, attribute: .width, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(width)
    return width
  }
  
}
