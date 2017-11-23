//
//  BaseCoordinator.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

class BaseCoordinator: Coordinator {
  
  weak var rootViewController: UINavigationController?
  var childCoordinators: [Coordinator] = []
  
  init(rootViewController: UINavigationController?) {
    self.rootViewController = rootViewController
  }
  
  func start() {
    fatalError("Override in subclasses")
  }
  
  // add only unique object
  func addDependency(_ coordinator: Coordinator) {
    for element in childCoordinators {
      if element === coordinator { return }
    }
    childCoordinators.append(coordinator)
  }
  
  func removeDependency(_ coordinator: Coordinator?) {
    guard
      childCoordinators.isEmpty == false,
      let coordinator = coordinator
      else { return }
    
    for (index, element) in childCoordinators.enumerated() {
      if element === coordinator {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}
