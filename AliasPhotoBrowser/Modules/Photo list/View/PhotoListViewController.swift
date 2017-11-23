//
//  PhotoListViewController.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit
import Photos
import MBProgressHUD

class PhotoListViewController: UIViewController {
  
  var photoListModel: PhotoListModelProtocol!
  fileprivate var alreadyFetched: Bool = false
  fileprivate var collectionView: UICollectionView!
  fileprivate var collectionViewLayout: UICollectionViewFlowLayout!
  fileprivate var cellProvider: PhotosCellProviderProtocol!
  fileprivate var dataProvider: PhotosDataProviderProtocol!
  fileprivate var itemSizeCalculator: CellSizeCalculatorProtocol!
  fileprivate lazy var collectionViewQueue = SerialTaskQueue()
  
  fileprivate var photoLibraryAuthorizationStatus: PHAuthorizationStatus {
    return PHPhotoLibrary.authorizationStatus()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationItem.setHidesBackButton(true, animated: true)
    let fetchButton = UIBarButtonItem(title: "Fetch!", style: .plain, target: self, action: #selector(fetchAction(sender:)))
    navigationItem.rightBarButtonItem = fetchButton
  }
  
  @objc private func fetchAction(sender: UIBarButtonItem) {
    guard !alreadyFetched else { return }
    let hud = MBProgressHUD.showAdded(to: view, animated: true)
    hud.label.text = "Fetching..."
    
    photoListModel.fetchPhotos(progress: nil) {[weak self] in 
      self?.commonInit()
      self?.alreadyFetched = true
      hud.hide(animated: true)
    }
  }
  
  private func commonInit() {
    replacePlaceholderItemsWithPhotoItems()
    configureCollectionView()
    configureItemSizeCalculator()
    dataProvider = PhotosPlaceholderDataProvider()
    cellProvider = PhotosPlaceholderCellProvider(collectionView: collectionView)
    collectionViewQueue.start()
  }
  
  private func configureItemSizeCalculator() {
    itemSizeCalculator = CellSizeCalculator()
    itemSizeCalculator.itemsPerRow = 1
    itemSizeCalculator.interitemSpace = 1
  }
  
  
  private func replacePlaceholderItemsWithPhotoItems() {
    collectionViewQueue.addTask { [weak self] (completion) in
      guard let sSelf = self else { return }

      let newDataProvider = PhotosWithPlaceholdersDataProvider(photosDataProvider: PhotosDataProvider(), placeholdersDataProvider: PhotosPlaceholderDataProvider())
      newDataProvider.delegate = sSelf
      sSelf.dataProvider = newDataProvider
      sSelf.cellProvider = PhotosCellProvider(collectionView: sSelf.collectionView, dataProvider: newDataProvider)
      sSelf.collectionView.reloadData()
      DispatchQueue.main.async(execute: completion)
    }
  }
  
  func reload() {
    collectionViewQueue.addTask { [weak self] completion in
      self?.collectionView.reloadData()
      DispatchQueue.main.async(execute: completion)
    }
  }
}

//MARK: - CollectionViewDataSource
extension PhotoListViewController: UICollectionViewDataSource {
  func configureCollectionView() {
    collectionViewLayout = PhotoListCollectionViewLayout()
    collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewLayout)
    collectionView.backgroundColor = UIColor.white
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      view.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
      view.topAnchor.constraint(equalTo: collectionView.topAnchor),
      view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
    ])
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataProvider.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = cellProvider.cellForItemAtIndexPath(indexPath)
    return cell
  }
}

//MARK: - CollectionViewFlowLayout
extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return itemSizeCalculator.cellSize(width: collectionView.bounds.width, atIndex: indexPath.item)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return itemSizeCalculator.interitemSpace
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return itemSizeCalculator.interitemSpace
  }
}

extension PhotoListViewController: PhotosDataProviderDelegate {
  func handlePhotosInpudDataProviderUpdate(_ dataProvider: PhotosDataProviderProtocol, updateBlock: @escaping () -> Void) {
    collectionViewQueue.addTask { [weak self] (completion) in
      guard let sSelf = self else { return }
      updateBlock()
      sSelf.collectionView.reloadData()
      DispatchQueue.main.async(execute: completion)
    }
  }
  
}

class PhotoListCollectionViewLayout: UICollectionViewFlowLayout {
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return newBounds.width != collectionView?.bounds.width
  }
}



