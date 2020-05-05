//
//  SortTile.swift
//  Algorithm
//
//  Created by tosru on 2020/05/05
//  ©︎ 2020 tosru
//

import SpriteKit

class SortTile {
  var node: SKShapeNode
  private var numberLabel: SKLabelNode
  
  init(rect: CGRect, color: SKColor, textNumber: Int) {
    node = SKShapeNode(rect: rect, cornerRadius: 3)
    node.fillColor = color
    node.lineWidth = 0
    numberLabel = SKLabelNode(text: "\(textNumber)")
    numberLabel.position = CGPoint(x: node.frame.midX, y: node.frame.midY)
    numberLabel.fontName = "HiraMaruProN-W4"
    numberLabel.verticalAlignmentMode = .center
    node.addChild(numberLabel)
  }
}
