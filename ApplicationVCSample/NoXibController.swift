//
//  NoXibController.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 1/1/17.
//  Copyright © 2017 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class NoXibController: UIViewController {
  override func loadView() {
    self.view = UIControl()
    self.view.backgroundColor = .yellow
  }
  
  @IBAction func buttonTap() { actionOnButtonTap() }
  var actionOnButtonTap : () -> Void = {
    let operation = ActivityOperation(rule: .any, identifier: "Launch", animator: CircleTransitionAnimator(direction: .outward, duration: 0.5))
    ActivityViewController.rootController?.performActivityOperation(operation)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.translatesAutoresizingMaskIntoConstraints = false
    let label = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 100))
    self.view.addSubview(label)
    label.text = "Hi from the generator"
    
    let button: UIButton = UIButton(type: UIButtonType.system)
    button.setTitle("Back", for: UIControlState())
    button.frame = CGRect(x: 100, y: 180, width: 200, height: 100)
    button.addTarget(self, action: #selector(NoXibController.buttonTap), for: .touchUpInside)
    self.view.addSubview(button)
    
  }
  
}
