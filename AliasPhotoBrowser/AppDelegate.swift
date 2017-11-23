//
//  AppDelegate.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  fileprivate var applicationCoordinator: ApplicationCoordinator?
  fileprivate let rootViewController = UINavigationController()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    customizeWindow()
    let coordinator = ApplicationCoordinator(rootViewController: rootViewController)
    coordinator.start()
    applicationCoordinator = coordinator
    return true
  }
  
  fileprivate func customizeWindow() {
    let window = UIWindow()
    window.rootViewController = rootViewController
    window.makeKeyAndVisible()
    self.window = window
  }


}

