//
//  GeneratedController.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 5/4/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class GeneratedController: UIViewController {
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    ActivityOperation(rule: .Any, identifier: "Launch", animator: CircleTransitionAnimator(direction: .Inward, duration: 0.5)).execute()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.translatesAutoresizingMaskIntoConstraints = false
    let label = UILabel(frame: CGRectMake(100, 100, 200, 100))
    self.view.addSubview(label)
    label.text = "Hi from the generator"
    self.view.backgroundColor = .redColor()
    
    let button: UIButton = UIButton(type: UIButtonType.System)
    button.setTitle("Back", forState: UIControlState.Normal)
    button.frame = CGRectMake(100, 180, 200, 100)
    button.addTarget(self, action: "buttonTap", forControlEvents: .TouchUpInside)
    self.view.addSubview(button)
    
  }
}
