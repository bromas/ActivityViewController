//
//  InteractiveTransitioningManager.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 8/21/15.
//  Copyright © 2015 Brian Thomas. All rights reserved.
//

import UIKit

internal struct InteractiveTransitioningManager {
    
    fileprivate let managedContainer : UIViewController
    
    init (containerController: UIViewController) {
        managedContainer = containerController
    }
    
    internal func animate(_ animator: UIViewControllerInteractiveTransitioning, fromVC: UIViewController, toVC: UIViewController, completion: @escaping () -> Void = { }) {
        prepareAutoresizingContainmentFor(toVC, inController: managedContainer)
        fromVC.willMove(toParentViewController: nil);
        
        let transitionContext = NonInteractiveTransitionContext(managedController: managedContainer, fromViewController: fromVC, toViewController: toVC)
        
        transitionContext.completionBlock = { completed in
            fromVC.view.removeFromSuperview()
            fromVC.removeFromParentViewController()
            toVC.didMove(toParentViewController: self.managedContainer)
            completion()
        }
    }
}
