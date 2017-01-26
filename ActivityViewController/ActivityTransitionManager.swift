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
  
  fileprivate weak var managedContainer : ActivityViewController?
  internal var activeVC : UIViewController?
  
  lazy internal var typeAnimator: AnimateByTypeManager = {
    return AnimateByTypeManager(containerController: self.managedContainer)
  }()
  lazy internal var noninteractiveTransitionManager: AnimateNonInteractiveTransitionManager = {
    return AnimateNonInteractiveTransitionManager(containerController: self.managedContainer)
  }()
  
  init (containerController: ActivityViewController) {
    managedContainer = containerController
  }
  
  var containerView: UIView? = .none
  
  /**
   An 'active controller's view should be contained in a UIView subview of the container controller to operate correctly with all transition types.
   */
  
  internal func transitionToVC(_ controller: UIViewController, withOperation operation: ActivityOperation) {
    
    guard let managedContainer = managedContainer else {
      return
    }
    
    if let activeVCUnwrapped = activeVC {
      switch operation.type {
      case .animationOption:
        managedContainer.animating = true
        typeAnimator.animate(operation.animationOption, fromVC: activeVCUnwrapped, toVC: controller, withDuration: operation.animationDuration, completion: completionGen(operation))
      case .nonInteractiveTransition:
        managedContainer.animating = true
        noninteractiveTransitionManager.animate(operation.nonInteractiveTranstionanimator, fromVC: activeVCUnwrapped, toVC: controller, completion: completionGen(operation))
      case .none:
        _ = swapToControllerUnanimated(controller, fromController: activeVCUnwrapped)
      default:
        assert(false, "You called for a transition with an invalid operation... How did you even do that!?")
      }
      activeVC = controller
    } else {
      _ = initializeDisplayWithController(controller)
    }
  }
  
  fileprivate func completionGen(_ operation: ActivityOperation) -> (() -> Void) {
    return { [weak self] _ in
      operation.completionBlock()
      self?.managedContainer?.animating = false
    }
  }
  
  fileprivate func swapToControllerUnanimated(_ controller: UIViewController, fromController: UIViewController) -> Bool {
    guard let container = containerView else {
      return false
    }
    
    removeController(fromController)
    self.activeVC = .none
    
    prepareContainmentFor(controller, inController: managedContainer)
    container.addSubview(controller.view)
    constrainEdgesOf(controller.view, toEdgesOf: container)
    controller.didMove(toParentViewController: managedContainer);
    
    self.activeVC = controller
    return true
  }
  
  func initializeDisplayWithController(_ controller: UIViewController) -> Bool {
    
    guard let managedContainer = managedContainer else {
      return false
    }
    
    let container = UIView(frame: CGRect.zero)
    container.translatesAutoresizingMaskIntoConstraints = false
    managedContainer.view.addSubview(container)
    constrainEdgesOf(container, toEdgesOf: managedContainer.view)
    containerView = container
    managedContainer.configureContainerView(container)
    
    prepareContainmentFor(controller, inController: managedContainer)
    container.addSubview(controller.view)
    constrainEdgesOf(controller.view, toEdgesOf: container)
    controller.didMove(toParentViewController: managedContainer);
    
    self.activeVC = controller
    return true
  }
  
  fileprivate func removeController(_ controller: UIViewController) {
    controller.willMove(toParentViewController: nil)
    controller.view.removeFromSuperview()
    controller.didMove(toParentViewController: nil)
  }
  
}
