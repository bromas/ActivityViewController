//
//  AuthenticationVC.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 11/23/14.
//  Copyright (c) 2014 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class AuthenticationVC : UIViewController {
  
  @IBOutlet var activities: ActivityViewController!
  var timesPresented = -1
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "activities" {
      self.activities = segue.destination as? ActivityViewController
    }
  }
  
  override func viewDidLoad() {
    self.navigationController?.isNavigationBarHidden = true
    self.actionOnButtonTap = {
      var operation = ActivityOperation(rule: .new, identifier: "Authentication", animator: ShrinkAnimator())
      operation.completionBlock = {
        print("ohhhh yea")
      }
      self.activities.performActivityOperation(operation)
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    timesPresented += 1
  }
  
  @IBAction func backButtonTapped() {
    switch timesPresented % 5 {
    case 0:
      ActivityOperation(identifier: "Launch", animator: CircleTransitionAnimator(direction: .outward, duration: 0.5)).execute()
    case 1:
      ActivityOperation(identifier: "Launch", animator: CinematicWipeTransitionAnimator()).execute()
    case 2:
      ActivityOperation(identifier: "Launch", animator: ShrinkAnimator()).execute()
    case 3:
      ActivityOperation(identifier: "Launch", animationType: UIViewAnimationOptions.transitionCurlUp, duration: 0.5).execute()
    default:
      ActivityOperation(identifier: "Launch", animationType: UIViewAnimationOptions.transitionFlipFromLeft, duration: 0.5).execute()
    }
  }
  
}
