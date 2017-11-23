//
//  CoordinatorFabric.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

struct CoordinatorFabric {
  
  func createOnboardingCoordinator(rootViewController: UINavigationController?) -> OnboardingCoordinator {
    return OnboardingCoordinator(rootViewController: rootViewController)
  }
  
  func createMainCoordinator(rootViewController: UINavigationController?) -> MainCoordinator {
    return MainCoordinator(rootViewController: rootViewController)
  }
  
}
