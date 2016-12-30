//
//  ApplicationTransitionManager.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/1/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal class ActivityTransitionManager {
  
  fileprivate let managedContainer : ActivityViewController
  internal var activeVC : UIViewController?
  
  internal var animating: Bool = false
  
  lazy internal var typeAnimator: AnimateByTypeManager = {
    return AnimateByTypeManager(containerController: self.managedContainer)
    }()
  lazy internal var noninteractiveTransitionManager: AnimateNonInteractiveTransitionManager = {
    return AnimateNonInteractiveTransitionManager(containerController: self.managedContainer)
    }()
  
  init (containerController: ActivityViewController) {
    managedContainer = containerController
  }
  
/**
  An 'active controller's view should be contained in a UIView subview of the container controller to operate correctly with all transition types.
*/
  func configureActiveController(_ controller: UIViewController) {
    activeVC = controller
  }
  
  func completionGen(_ operation: ActivityOperation) -> (() -> Void) {
    return { [unowned self] _ in
      operation.completionBlock()
      self.managedContainer.animating = false
    }
  }
  
  internal func transitionToVC(_ controller: UIViewController, withOperation operation: ActivityOperation) {
    if let activeVCUnwrapped = activeVC {
      switch operation.type {
      case .animationOption:
        self.managedContainer.animating = true
        typeAnimator.animate(operation.animationOption, fromVC: activeVCUnwrapped, toVC: controller, withDuration: operation.animationDuration, completion: completionGen(operation))
      case .nonInteractiveTransition:
        self.managedContainer.animating = true
        noninteractiveTransitionManager.animate(operation.nonInteractiveTranstionanimator, fromVC: activeVCUnwrapped, toVC: controller, completion: completionGen(operation))
      case .none:
        initializeDisplayWithController(controller)
        removeController(activeVCUnwrapped)
      default:
        assert(false, "You called for a transition with an invalid operation... How did you even do that!?")
      }
      activeVC = controller
    } else {
      initializeDisplayWithController(controller)
    }
  }
  
  fileprivate func initializeDisplayWithController(_ controller: UIViewController) {
    let container = UIView(frame: CGRect.zero)
    container.translatesAutoresizingMaskIntoConstraints = false
    managedContainer.view.addSubview(container)
    constrainEdgesOf(container, toEdgesOf: managedContainer.view)
    prepareContainmentFor(controller, inController: managedContainer)
    container.addSubview(controller.view)
    constrainEdgesOf(controller.view, toEdgesOf: container)
    controller.didMove(toParentViewController: managedContainer);
    self.activeVC = controller
  }
  
  fileprivate func removeController(_ controller: UIViewController) {
    controller.willMove(toParentViewController: nil)
    controller.view.removeFromSuperview()
    controller.didMove(toParentViewController: nil)
  }
  
}
