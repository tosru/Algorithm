//
//  SortTile.swift
//  Algorithm
//
//  Created by tosru on 2020/05/05
//  ©︎ 2020 tosru
//

import SpriteKit

class SortTile {
  let node: SKShapeNode
  private var numberLabel: SKLabelNode
  let numberOfText: Int
  
  init(rect: CGRect, color: SKColor, numberOfText: Int) {
    self.node = SKShapeNode(rect: rect, cornerRadius: 3)
    self.numberOfText = numberOfText
    
    node.fillColor = color
    node.lineWidth = 0
    numberLabel = SKLabelNode(text: "\(numberOfText)")
    numberLabel.position = CGPoint(x: node.frame.midX, y: node.frame.midY)
    numberLabel.fontName = "HiraMaruProN-W4"
    numberLabel.verticalAlignmentMode = .center
    node.addChild(numberLabel)
  }
}
