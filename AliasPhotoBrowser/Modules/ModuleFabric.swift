//
//  ModulesFabric.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

struct ModuleFabric {
  
  let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
  
  func createOnboarding() -> OnboardingViewController {
    let onboardingVC = mainStoryboard.instantiateViewController(withIdentifier: "OnboardingViewController") as! OnboardingViewController
    let onboardingModel = OnboardingModel()
    onboardingVC.onboardingModel = onboardingModel
    return onboardingVC
  }
  
  func createPhotoList() -> PhotoListViewController {
    let photoListVC = mainStoryboard.instantiateViewController(withIdentifier: "PhotoListViewController") as! PhotoListViewController
    let photoListModel = PhotoListModel()
    photoListVC.photoListModel = photoListModel
    return photoListVC
  }
  
}
