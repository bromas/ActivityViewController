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
    ActivityOperation(rule: .Any, identifier: "Generator", animator: CircleTransitionAnimator(direction: .Inward, duration: 0.5)).execute()
  }
  
  @IBAction func embedButtonTapped() {
    ActivityOperation(rule: .Any, identifier: "Authentication", animator: ShrinkDismissAnimator()).execute()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
}
