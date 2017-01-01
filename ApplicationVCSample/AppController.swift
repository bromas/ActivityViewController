//
//  AppController.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 3/2/15.
//  Copyright (c) 2015 Brian Thomas. All rights reserved.
//

import Foundation
import UIKit
import ActivityViewController

class AppController : ActivityViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.registerGenerator("Cache") { () -> UIViewController in
      let nav = UINavigationController(rootViewController: NoXibController())
      return nav
    }
    
    self.registerGenerator("Generator") { () -> UIViewController in
      let inner = ActivityViewController()
      inner.registerGenerator("Generator") {
        let nav = UINavigationController(rootViewController: NoXibController())
        return nav
      }
      inner.initialActivityIdentifier = "Generator"
      return inner
    }
  }
  
}
