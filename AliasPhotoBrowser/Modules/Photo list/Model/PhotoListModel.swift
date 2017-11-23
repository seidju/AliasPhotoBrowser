//
//  PhotoListModel.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 23.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import Photos
import Foundation

protocol PhotoListModelProtocol {

  func fetchPhotos(progress: ((Double)->())?, completionHandler: (() -> ())?)

}

class PhotoListModel: PhotoListModelProtocol {
  
  fileprivate var photoLibraryAuthorizationStatus: PHAuthorizationStatus {
    return PHPhotoLibrary.authorizationStatus()
  }
  
  fileprivate func requestAccess(completionHandler: ((Bool) -> ())?) {
    guard photoLibraryAuthorizationStatus != .authorized else {
      completionHandler?(true)
      return
    }
    PHPhotoLibrary.requestAuthorization { status  in
      if status == PHAuthorizationStatus.authorized {
        DispatchQueue.main.async {
          completionHandler?(true)
        }
      }
    }
  }
 
  func fetchPhotos(progress: ((Double) -> ())?, completionHandler: (() -> ())?) {
    requestAccess { success in
      guard success else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
        completionHandler?()
      }
    }
  }
  
}
