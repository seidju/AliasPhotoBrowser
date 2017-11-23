//
//  PhotoCell.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 23.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

class PhotosInputPlaceholderCell: UICollectionViewCell {
  
  private struct Constants {
    static let backgroundColor = UIColor(red: 231.0/255.0, green: 236.0/255.0, blue: 242.0/255.0, alpha: 1)
    static let imageName = "lock"
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  private var imageView: UIImageView!
  private func commonInit() {
    self.imageView = UIImageView()
    self.imageView.contentMode = .center
    self.imageView.image = UIImage(named: Constants.imageName, in: Bundle(for: PhotosInputPlaceholderCell.self), compatibleWith: nil)
    self.contentView.addSubview(self.imageView)
    self.contentView.backgroundColor = Constants.backgroundColor
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.imageView.sizeToFit()
    self.imageView.center = self.contentView.center
  }
}

class PhotosInputCell: UICollectionViewCell {
  
  private struct Constants {
    static let backgroundColor = UIColor(red: 231.0/255.0, green: 236.0/255.0, blue: 242.0/255.0, alpha: 1)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.commonInit()
  }
  
  private var imageView: UIImageView!
  private var label: UILabel!
  
  private func commonInit() {
    clipsToBounds = true
    imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    configureLabel()
    
    contentView.addSubview(imageView)
    contentView.addSubview(label)
    contentView.backgroundColor = Constants.backgroundColor
  }
  
  fileprivate func configureLabel() {
    label = UILabel()
    label.font = UIFont.systemFont(ofSize: 10.0)
    label.numberOfLines = 3
    label.textAlignment = .center
    label.textColor = .black
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 40.0)
    label.frame = CGRect(x: 0, y: bounds.height - 40.0, width: bounds.width, height: 40.0)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    image = nil
    text = nil
  }
  
  var text: String? {
    get { return label.text }
    set { label.text = newValue }
  }
  
  var image: UIImage? {
    get {
      return self.imageView.image
    }
    set {
      self.imageView.image = newValue
    }
  }
}
