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
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "activities" {
      self.activities = segue.destinationViewController as? ActivityViewController
    }
  }
  
  override func viewDidLoad() {
    self.navigationController?.navigationBarHidden = true
    self.actionOnButtonTap = {
      var operation = ActivityOperation(rule: .New, identifier: "Authentication", animator: ShrinkAnimator())
      operation.completionBlock = {
        println("ohhhh yea")
      }
      self.activities.performActivityOperation(operation)
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    timesPresented += 1
  }
  
  @IBAction func backButtonTapped() {
    switch timesPresented % 5 {
    case 0:
      ActivityOperation(identifier: "Launch", animator: CircleTransitionAnimator(direction: .Outward, duration: 0.5)).execute()
    case 1:
      ActivityOperation(identifier: "Launch", animator: CinematicWipeTransitionAnimator()).execute()
    case 2:
      ActivityOperation(identifier: "Launch", animator: ShrinkAnimator()).execute()
    case 3:
      ActivityOperation(identifier: "Launch", animationType: UIViewAnimationOptions.TransitionCurlUp, duration: 0.5).execute()
    default:
      ActivityOperation(identifier: "Launch", animationType: UIViewAnimationOptions.TransitionFlipFromLeft, duration: 0.5).execute()
    }
  }
  
}
