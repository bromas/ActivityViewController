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
    self.registerGenerator("Generator") { () -> UIViewController in
      return GeneratedController()
    }
  }
  
}
