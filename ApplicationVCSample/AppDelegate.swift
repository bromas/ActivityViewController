//
//  AppDelegate.swift
//  ApplicationVCSample
//
//  Created by Brian Thomas on 11/23/14.
//  Copyright (c) 2014 Brian Thomas. All rights reserved.
//

import UIKit
import ActivityViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

internal func constrainEdgesOf(view: UIView, toEdgesOf: UIView) -> NSLayoutConstraint {
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view,attribute: .Height, relatedBy: .Equal, toItem: toEdgesOf, attribute: .Height, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: toEdgesOf, attribute: .Width, multiplier: 1.0, constant: 0.0))
  toEdgesOf.addConstraint(NSLayoutConstraint(item: view, attribute: .CenterY, relatedBy: .Equal, toItem: toEdgesOf, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
  let constraint = NSLayoutConstraint(item: view, attribute: .CenterX, relatedBy: .Equal, toItem: toEdgesOf, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
  toEdgesOf.addConstraint(constraint)
  return constraint
}

