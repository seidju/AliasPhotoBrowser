//
//  PhotoListModel.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 23.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

protocol PhotosCellProviderProtocol {
  
  func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell
  
}

class PhotosPlaceholderCellProvider: PhotosCellProviderProtocol {
  private let reuseIdentifier = "PhotosPlaceholderCellProvider"
  private let collectionView: UICollectionView
  init(collectionView: UICollectionView) {
    self.collectionView = collectionView
    self.collectionView.register(PhotosInputPlaceholderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
    return collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath)
  }
}

class PhotosCellProvider: PhotosCellProviderProtocol {
  private let reuseIdentifier = "PhotosCellProvider"
  private let collectionView: UICollectionView
  private let dataProvider: PhotosDataProviderProtocol
  init(collectionView: UICollectionView, dataProvider: PhotosDataProviderProtocol) {
    self.dataProvider = dataProvider
    self.collectionView = collectionView
    collectionView.register(PhotosInputCell.self, forCellWithReuseIdentifier: self.reuseIdentifier)
  }
  
  func cellForItemAtIndexPath(_ indexPath: IndexPath) -> UICollectionViewCell {
    let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! PhotosInputCell
    configureCell(cell, atIndexPath: indexPath)
    return cell
  }
  
  private let previewRequests = NSMapTable<PhotosInputCell, NSNumber>.weakToStrongObjects()
  private func configureCell(_ cell: PhotosInputCell, atIndexPath indexPath: IndexPath) {
    if let requestID = self.previewRequests.object(forKey: cell) {
      previewRequests.removeObject(forKey: cell)
      dataProvider.cancelImageRequest(requestID.int32Value)
    }
    
    let index = indexPath.item
    let targetSize = cell.bounds.size
    var imageProvidedSynchronously = true
    var requestID: Int32 = -1
    requestID = dataProvider.requestImageAtIndex(index: index, targetSize: targetSize) { [weak self, weak cell] image, url in
      guard let sSelf = self, let sCell = cell else { return }
      let imageIsForThisCell = imageProvidedSynchronously || sSelf.previewRequests.object(forKey: sCell)?.int32Value == requestID
      if imageIsForThisCell {
        DispatchQueue.global().async {
          let data = UIImageJPEGRepresentation(image, 1.0)!
          let hash = CC.digest(data, alg: .md5).hexadecimalString()
          let name = url?.components(separatedBy: "/").last
          let nameStr = "Name: \(name ?? "")"
          let hashStr = "MD5: \(hash)"
          let size = (Double(data.count)) / (1024 * 1024)
          let sizeStr = "Size: " + String(format:"%.2f", size) + " MByte"
          let infoStr = nameStr + "\n" + hashStr + "\n" + sizeStr
          DispatchQueue.main.async {
            sCell.image = image
            sCell.text = infoStr
          }
        }
      }
    }
    imageProvidedSynchronously = false
    previewRequests.setObject(NSNumber(value: requestID), forKey: cell)
  }
}
