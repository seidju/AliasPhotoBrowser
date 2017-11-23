//
//  CellSizeCalculatorProtocol.swift
//  AliasPhotoBrowser
//
//  Created by Pavel Shatalov on 22.11.2017.
//  Copyright © 2017 Pavel Shatalov. All rights reserved.
//

import UIKit

protocol CellSizeCalculatorProtocol {
  var itemsPerRow: Int { get set }
  var interitemSpace: CGFloat { get set }
  func cellSize(width: CGFloat, atIndex index: Int) -> CGSize
}
