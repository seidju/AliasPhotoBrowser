//
//  OnboardingModelProtocol.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//


protocol OnboardingModelProtocol {
  
  var onboardingDidFinish: (() -> ())? { get set }
}
