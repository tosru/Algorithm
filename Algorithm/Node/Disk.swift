//
//  Disk.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit

class Disk {
  
  private var colors: [SKColor] = [SKColor(red: 0, green: 27/255, blue: 131/255, alpha: 1.0), SKColor(red: 167/255, green: 0, blue: 0, alpha: 1.0), SKColor(red: 60/255, green: 119/255, blue: 38/255, alpha: 1.0)]
  private(set) var node: SKSpriteNode
  
  init(size: CGSize) {
    node = SKSpriteNode(texture: nil, size: size)
  }
  
  func changeColor(diskNum: Int) {
    let index = diskNum % 3
    node.color = colors[index]
  }
}
