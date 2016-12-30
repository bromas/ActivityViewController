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
    ActivityOperation(rule: .any, identifier: "Launch", animator: CircleTransitionAnimator(direction: .outward, duration: 0.5)).execute()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.translatesAutoresizingMaskIntoConstraints = false
    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
    self.view.addSubview(label)
    label.text = "Hi from the generator"
    self.view.backgroundColor = .red
    
    let button: UIButton = UIButton(type: UIButtonType.system)
    button.setTitle("Back", for: UIControlState())
    button.frame = CGRect(x: 100, y: 180, width: 200, height: 100)
    button.addTarget(self, action: #selector(GeneratedController.buttonTap), for: .touchUpInside)
    self.view.addSubview(button)
    
  }
}
