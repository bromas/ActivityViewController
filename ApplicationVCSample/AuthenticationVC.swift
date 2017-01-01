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
      
      self.activities.registerGenerator("Generator") { () -> UIViewController in
          return NoXibController()
      }
      
    }
  }
  
  override func viewDidLoad() {
    self.navigationController?.isNavigationBarHidden = true
    self.actionOnButtonTap = {
      var operation = ActivityOperation(rule: .new, identifier: "Launch", animator: ShrinkAnimator())
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
      let operation = ActivityOperation(identifier: "Launch", animator: CircleTransitionAnimator(direction: .outward, duration: 0.5))
      ActivityViewController.rootController?.performActivityOperation(operation)
    case 1:
      let operation = ActivityOperation(identifier: "Launch", animator: CinematicWipeTransitionAnimator())
      ActivityViewController.rootController?.performActivityOperation(operation)
    case 2:
      let operation = ActivityOperation(identifier: "Launch", animator: ShrinkAnimator())
      ActivityViewController.rootController?.performActivityOperation(operation)
    case 3:
      let operation = ActivityOperation(identifier: "Launch", animationType: UIViewAnimationOptions.transitionCurlUp, duration: 0.5)
      ActivityViewController.rootController?.performActivityOperation(operation)
    default:
      let operation = ActivityOperation(identifier: "Launch", animationType: UIViewAnimationOptions.transitionFlipFromLeft, duration: 0.5)
      ActivityViewController.rootController?.performActivityOperation(operation)
    }
  }
  
}
