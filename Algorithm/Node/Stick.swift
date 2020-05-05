//
//  Stick.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit

class Stick {
  
  private(set) var node: SKSpriteNode
  /// diskが積み重なった合計の高さ
  private(set) var pileHeight: CGFloat = 0
  
  init(size: CGSize) {
    node = SKSpriteNode(texture: nil, size: size)
    node.color = .white
  }
  
  func increaseHeight(diskHeight: CGFloat) {
    pileHeight += diskHeight
  }
  
  func decreaseHeight(diskHeight: CGFloat) {
    if diskHeight <= pileHeight {
      //pileHeightが0以上になる時のみ
      pileHeight -= diskHeight
    }
  }
}
