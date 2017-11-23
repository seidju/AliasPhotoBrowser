//
//  PhotoDataProviderProtocol.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 23.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

protocol PhotosDataProviderDelegate: class {
  func handlePhotosInpudDataProviderUpdate(_ dataProvider: PhotosDataProviderProtocol, updateBlock: @escaping () -> Void)
}

protocol PhotosDataProviderProtocol : class {
  weak var delegate: PhotosDataProviderDelegate? { get set }
  var count: Int { get }
  func requestImageAtIndex(index: Int, targetSize: CGSize, completion: @escaping (UIImage, String?) -> ()) -> Int32
  func cancelImageRequest(_ requestID: Int32)
}
