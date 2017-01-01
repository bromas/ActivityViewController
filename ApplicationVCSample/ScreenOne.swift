//
//  ScreenOne.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 11/23/14.
//  Copyright (c) 2014 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class ScreenOne : UIViewController {
  
  @IBAction func authButtonTapped() {
    let operation = ActivityOperation(rule: .any, identifier: "Generator", animator: CircleTransitionAnimator(direction: .inward, duration: 0.5))
    ActivityViewController.closestParentOfController(self)?.performActivityOperation(operation)
  }
  
  @IBAction func embedButtonTapped() {
    let operation = ActivityOperation(rule: .any, identifier: "Authentication", animator: ShrinkDismissAnimator())
    ActivityViewController.closestParentOfController(self)?.performActivityOperation(operation)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
}
