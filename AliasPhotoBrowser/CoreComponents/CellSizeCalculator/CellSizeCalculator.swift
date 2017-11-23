//
//  CellSizeCalculator.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

struct CellSizeCalculator: CellSizeCalculatorProtocol {
  var itemsPerRow: Int = 0
  var interitemSpace: CGFloat = 0.0

  func cellSize(width: CGFloat, atIndex index: Int) -> CGSize {
    let availableWidth = width - interitemSpace * CGFloat((itemsPerRow - 1))
    if availableWidth <= 0 {
      return CGSize.zero
    }
    var itemWidth = Int(floor(availableWidth / CGFloat(itemsPerRow)))
    let itemHeigth = itemWidth
    let extraPixels = Int(availableWidth) % itemsPerRow
    let isItemWithExtraPixel = index % itemsPerRow < extraPixels
    if isItemWithExtraPixel {
      itemWidth += 1
    }
    return CGSize(width: itemWidth, height: itemHeigth)
  }
  
}
