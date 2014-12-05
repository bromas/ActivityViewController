//
//  ContainmentHelperMethods.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 2/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal func constrainEdgesOf(view: UIView, #toEdgesOf: UIView) {
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: toEdgesOf, attribute: .Height, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: toEdgesOf, attribute: .Width, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: toEdgesOf, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: toEdgesOf, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
}

internal func prepareContainmentFor(controller: UIViewController, #inController: UIViewController) {
  controller.willMoveToParentViewController(inController)
  inController.addChildViewController(controller)
  controller.view.setTranslatesAutoresizingMaskIntoConstraints(false)
  controller.view.frame = inController.view.bounds
  controller.view.layoutIfNeeded()
}

internal func prepareAutoresizingContainmentFor(controller: UIViewController, #inController: UIViewController) {
  controller.willMoveToParentViewController(inController)
  controller.view.setTranslatesAutoresizingMaskIntoConstraints(true)
  inController.addChildViewController(controller)
  controller.view.frame = inController.view.bounds
  controller.view.layoutIfNeeded()
}