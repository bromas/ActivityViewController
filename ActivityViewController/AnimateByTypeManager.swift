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
  
  fileprivate weak var managedContainer : UIViewController?
  
  init (containerController: UIViewController?) {
    managedContainer = containerController
  }
  
  internal func animate(_ animationType: UIViewAnimationOptions, fromVC: UIViewController, toVC: UIViewController, withDuration duration: TimeInterval, completion: @escaping () -> Void = { }) {
    prepareContainmentFor(toVC, inController: managedContainer)
    fromVC.willMove(toParentViewController: nil);
    
    let animations = { () -> Void in
      constrainEdgesOf(toVC.view, toEdgesOf: fromVC.view.superview!)
    }
    
    let completion : (Bool) -> Void = { completed in
      fromVC.removeFromParentViewController();
      toVC.didMove(toParentViewController: self.managedContainer);
      completion()
    }
    
    managedContainer?.transition(from: fromVC, to: toVC, duration: duration, options: animationType, animations: animations, completion: completion)
  }
}
