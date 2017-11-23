//
//  MainCoordinator.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//


class MainCoordinator: BaseCoordinator {
  
  fileprivate var didPickPhoto: (() -> ())?
  
  override func start() {
    setToSettings(key: "firstStart", value: true as AnyObject)
    showPhotoList()
  }
  
  fileprivate func showPhotoList() {
    let photoList = ModuleFabric().createPhotoList()
    rootViewController?.pushViewController(photoList, animated: true)
  }
  
  
  
}
