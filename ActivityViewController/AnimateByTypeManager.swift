//
//  AnimateByTypeManager.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 2/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal struct AnimateByTypeManager {
  
  private let managedContainer : UIViewController
  
  init (containerController: UIViewController) {
    managedContainer = containerController
  }
  
  internal func animate(animationType:UIViewAnimationOptions, fromVC: UIViewController, toVC: UIViewController, withDuration duration: NSTimeInterval, completion: () -> Void = { }) {
    prepareContainmentFor(toVC, inController: managedContainer)
    fromVC.willMoveToParentViewController(nil);
    
    let animations = { () -> Void in
      constrainEdgesOf(toVC.view, toEdgesOf: fromVC.view.superview!)
    }
    
    let completion : (Bool) -> Void = { completed in
      fromVC.removeFromParentViewController();
      toVC.didMoveToParentViewController(self.managedContainer);
      completion()
    }
    
    managedContainer.transitionFromViewController(fromVC, toViewController: toVC, duration: duration, options: animationType, animations: animations, completion: completion)
  }
}