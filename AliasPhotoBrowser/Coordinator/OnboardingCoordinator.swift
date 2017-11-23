//
//  OnboardingCoordinator.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

class OnboardingCoordinator: BaseCoordinator {
  
  var finishFlow: (() -> ())?
  
  override func start() {
    showOnboarding()
  }
  
  
  fileprivate func showOnboarding() {
    let onboarding = ModuleFabric().createOnboarding()
    onboarding.onboardingModel?.onboardingDidFinish = finishFlow
    rootViewController?.pushViewController(onboarding, animated: false)
  }
  
}

