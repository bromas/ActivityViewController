//
//  CinematicWipeAnimator.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

public class CinematicWipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  
  public var animationDuration: NSTimeInterval = 1.0
  private var isPresenting = true
  
  public func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
    return animationDuration
  }
  
  public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    var fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)
    var toView = transitionContext.viewForKey(UITransitionContextToViewKey)
    toView?.setTranslatesAutoresizingMaskIntoConstraints(false)
    var container = transitionContext.containerView()
    
    container.insertSubview(toView!, atIndex: 0)
    constrainSizeAndCenter(toView!, toView: container)
    container.layoutIfNeeded()
    
    let toSnapshot = toView!.snapshotViewAfterScreenUpdates(true)
    let snapshotContainer = UIView(frame: container.bounds)
    snapshotContainer.setTranslatesAutoresizingMaskIntoConstraints(false)
    toSnapshot.setTranslatesAutoresizingMaskIntoConstraints(false)
    snapshotContainer.clipsToBounds = true
    snapshotContainer.backgroundColor = UIColor.blackColor()
    
    container.addSubview(snapshotContainer)
    let width = constrainEdges(snapshotContainer, toView: container)
    width.constant = -container.bounds.width
    snapshotContainer.addSubview(toSnapshot)
    let snapShotConstraints = constrainEdges(toSnapshot, toView: snapshotContainer)
    snapshotContainer.removeConstraint(snapShotConstraints)
    let widthConstraint = NSLayoutConstraint(item: toSnapshot, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: container.bounds.width)
    toSnapshot.addConstraint(widthConstraint)
    container.layoutIfNeeded()
  
    UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
      width.constant = 0
      container.layoutIfNeeded()
      toSnapshot.layoutIfNeeded()
      }) { (complete) -> Void in
        fromView!.removeFromSuperview()
        snapshotContainer.removeFromSuperview()
        transitionContext.completeTransition(true)
        self.isPresenting = !self.isPresenting
    }
  }
  
  private func constrainSizeAndCenter(view: UIView, toView: UIView) -> (width: NSLayoutConstraint, height: NSLayoutConstraint, centerX: NSLayoutConstraint, centerY: NSLayoutConstraint) {
    let height = NSLayoutConstraint(item: view,attribute: .Height, relatedBy: .Equal, toItem: toView, attribute: .Height, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(height)
    let width = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: toView, attribute: .Width, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(width)
    let centerY = NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: toView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(centerY)
    let centerX = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: toView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(centerX)
    return (width, height, centerX, centerY)
  }
  
  private func constrainEdges(view: UIView, toView: UIView) -> NSLayoutConstraint {
    let top = NSLayoutConstraint(item: view,attribute: .Top, relatedBy: .Equal, toItem: toView, attribute: .Top, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(top)
    let bottom = NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: toView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(bottom)
    let right = NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: toView, attribute: .Right, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(right)
    let width = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: toView, attribute: .Width, multiplier: 1.0, constant: 0.0)
    toView.addConstraint(width)
    return width
  }
  
}
