//
//  ContainmentHelperMethods.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 2/17/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit

internal func constrainEdgesOf(_ view: UIView, toEdgesOf: UIView) {
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: toEdgesOf, attribute: .height, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: toEdgesOf, attribute: .width, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: toEdgesOf, attribute: .centerY, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: toEdgesOf, attribute: .centerX, multiplier: 1.0, constant: 0.0))
}

internal func prepareContainmentFor(_ controller: UIViewController?, inController: UIViewController?) {
  
  guard let putController = controller, let inController = inController else {
    return
  }
  
  putController.willMove(toParentViewController: inController)
  inController.addChildViewController(putController)
  putController.view.translatesAutoresizingMaskIntoConstraints = false
  putController.view.frame = inController.view.bounds
  putController.view.layoutIfNeeded()
}

internal func prepareAutoresizingContainmentFor(_ controller: UIViewController?, inController: UIViewController?) {
  
  guard let controller = controller, let inController = inController else {
    return
  }
  
  controller.willMove(toParentViewController: inController)
  controller.view.translatesAutoresizingMaskIntoConstraints = true
  inController.addChildViewController(controller)
  controller.view.frame = inController.view.bounds
  controller.view.layoutIfNeeded()
}
