//
//  OnboardingViewController.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
  
  var onboardingModel: OnboardingModelProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  @IBAction func start(_ sender: Any) {
    guard let model = onboardingModel else { return }
    model.onboardingDidFinish?()
  }
}
