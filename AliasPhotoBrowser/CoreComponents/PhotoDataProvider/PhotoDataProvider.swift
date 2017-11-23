//
//  PhotoDataProvider.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 23.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import PhotosUI

class PhotosPlaceholderDataProvider: PhotosDataProviderProtocol {
  weak var delegate: PhotosDataProviderDelegate?
  
  let numberOfPlaceholders: Int
  
  init(numberOfPlaceholders: Int = 5) {
    self.numberOfPlaceholders = numberOfPlaceholders
  }
  
  var count: Int {
    return self.numberOfPlaceholders
  }
  
  func requestImageAtIndex(index: Int, targetSize: CGSize, completion: @escaping (UIImage, String?) -> ()) -> Int32 {
    return -1
  }
  
  func cancelImageRequest(_ requestID: Int32) {
    //
  }
}

class PhotosDataProvider: NSObject, PhotosDataProviderProtocol, PHPhotoLibraryChangeObserver {
  weak var delegate: PhotosDataProviderDelegate?
  private var imageManager = PHCachingImageManager()
  private var fetchResult: PHFetchResult<PHAsset>!
  override init() {
    func fetchOptions(_ predicate: NSPredicate?) -> PHFetchOptions {
      let options = PHFetchOptions()
      options.sortDescriptors = [ NSSortDescriptor(key: "creationDate", ascending: false) ]
      options.predicate = predicate
      return options
    }
    
    if let userLibraryCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject {
      fetchResult = PHAsset.fetchAssets(in: userLibraryCollection, options: fetchOptions(NSPredicate(format: "mediaType = \(PHAssetMediaType.image.rawValue)")))
    } else {
      fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions(nil))
    }
    super.init()
    PHPhotoLibrary.shared().register(self)
  }
  
  deinit {
    PHPhotoLibrary.shared().unregisterChangeObserver(self)
  }
  
  var count: Int {
    return fetchResult.count
  }
  
  func requestImageAtIndex(index: Int, targetSize: CGSize, completion: @escaping (UIImage, String?) -> ()) -> Int32 {
    guard index >= 0 && index < fetchResult.count else { return -1 }
    let asset = self.fetchResult[index]
    let options = PHImageRequestOptions()
    options.deliveryMode = .highQualityFormat
    return self.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, data in
      if let image = image, let photoDict = data as? [String: Any] {
        let url = photoDict["PHImageFileURLKey"] as? URL
        completion(image, url?.path)
      }
    }
  }

  func cancelImageRequest(_ requestID: Int32) {
    imageManager.cancelImageRequest(requestID)
  }
  
  
  // MARK: PHPhotoLibraryChangeObserver
  func photoLibraryDidChange(_ changeInstance: PHChange) {
    // Photos may call this method on a background queue; switch to the main queue to update the UI.
    DispatchQueue.main.async { [weak self]  in
      guard let sSelf = self else { return }
      if let changeDetails = changeInstance.changeDetails(for: sSelf.fetchResult as! PHFetchResult<PHObject>) {
        let updateBlock = { () -> Void in
          self?.fetchResult = changeDetails.fetchResultAfterChanges as! PHFetchResult<PHAsset>
        }
        sSelf.delegate?.handlePhotosInpudDataProviderUpdate(sSelf, updateBlock: updateBlock)
      }
    }
  }
}

class PhotosWithPlaceholdersDataProvider: PhotosDataProviderProtocol, PhotosDataProviderDelegate {
  weak var delegate: PhotosDataProviderDelegate?
  private let photosDataProvider: PhotosDataProviderProtocol
  private let placeholdersDataProvider: PhotosDataProviderProtocol
  
  init(photosDataProvider: PhotosDataProviderProtocol, placeholdersDataProvider: PhotosDataProviderProtocol) {
    self.photosDataProvider = photosDataProvider
    self.placeholdersDataProvider = placeholdersDataProvider
    photosDataProvider.delegate = self
  }
  
  var count: Int {
    return max(self.photosDataProvider.count, self.placeholdersDataProvider.count)
  }
  
  func requestImageAtIndex(index: Int, targetSize: CGSize, completion: @escaping (UIImage, String?) -> ()) -> Int32 {
    if index < photosDataProvider.count {
      return photosDataProvider.requestImageAtIndex(index: index, targetSize: targetSize, completion: completion)
    } else {
      return placeholdersDataProvider.requestImageAtIndex(index: index, targetSize: targetSize, completion: completion)
    }
  }
  
  func cancelImageRequest(_ requestID: Int32) {
    return photosDataProvider.cancelImageRequest(requestID)
  }
  // MARK: PhotosInputDataProviderDelegate
  
  func handlePhotosInpudDataProviderUpdate(_ dataProvider: PhotosDataProviderProtocol, updateBlock: @escaping () -> Void) {
    self.delegate?.handlePhotosInpudDataProviderUpdate(self, updateBlock: updateBlock)
  }
}
