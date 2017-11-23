//
//  ApplicationCoordinator.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

class ApplicationCoordinator: BaseCoordinator {
  
  fileprivate enum StartState {
    case onboarding
    case main
  }
  
  fileprivate var state: StartState = .onboarding
  
  override init(rootViewController: UINavigationController?) {
    super.init(rootViewController: rootViewController)
    state = isFirstStart ? .onboarding : .main
  }
  
  override func start() {
    switch state {
      case .onboarding: runOnboardingFlow()
      case .main: runMainFlow()
    }
  }
  
  fileprivate func runOnboardingFlow() {
    let onboardingCoordinator = CoordinatorFabric().createOnboardingCoordinator(rootViewController: rootViewController)
    onboardingCoordinator.finishFlow = { [weak self, weak onboardingCoordinator] in
      self?.state = .main
      self?.start()
      self?.removeDependency(onboardingCoordinator)
    }
    addDependency(onboardingCoordinator)
    onboardingCoordinator.start()
  }
  
  fileprivate func runMainFlow() {
    let mainCoordinator = CoordinatorFabric().createMainCoordinator(rootViewController: rootViewController)
    addDependency(mainCoordinator)
    mainCoordinator.start()
  }
  
  // MARK: - Helper
  fileprivate var isFirstStart: Bool {
    guard let _ = getFromSettings(key: "firstStart") as? Bool else { return true }
    return false
  }
}
