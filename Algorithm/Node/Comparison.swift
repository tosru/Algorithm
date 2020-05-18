//
//  Comparison.swift
//  Algorithm
//
//  Created by tosru on 2020/05/07
//  ©︎ 2020 tosru
//

import SpriteKit

class Comparison {
  let node: SKShapeNode
  private let leftBar: SKShapeNode
  private let rightBar: SKShapeNode
  private let initPosition: CGPoint
  private let tileWidth: CGFloat
  private var moveRightCount = 0
  private var moveRightNumber = -1
  
  init(width: CGFloat, position: CGPoint, numberOfTiles: Int) {
    let barWidth: CGFloat = 10
    let barHeight: CGFloat = 35
    self.tileWidth = width
    self.node = SKShapeNode(rect: CGRect(x: 0, y: 0, width: width, height: barWidth))
    self.leftBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: barWidth, height: barHeight))
    self.rightBar = SKShapeNode(rect: CGRect(x: 0, y: 0, width: barWidth, height: barHeight))
    let initPosition = CGPoint(x: position.x, y: position.y - barHeight)
    self.initPosition = initPosition
    self.moveRightNumber = numberOfTiles - 2
    node.position = initPosition
    node.lineWidth = 0
    leftBar.lineWidth = 0
    rightBar.lineWidth = 0
    node.fillColor = .black
    leftBar.fillColor = .black
    rightBar.fillColor = .black
    join()
  }
  
  private func join() {
    // positionを変えてleftBar,rightBarがSortTileの中心を指すようにする
    leftBar.position = CGPoint(x: -(leftBar.frame.width / 2), y: 0)
    node.addChild(leftBar)
    rightBar.position = CGPoint(x: node.frame.width - rightBar.frame.width / 2, y: 0)
    node.addChild(rightBar)
  }
  
  func move() {
    if moveRightNumber == 0 { return }
    if moveRightCount == moveRightNumber {
      moveToInitPosition()
      moveRightNumber -= 1
      moveRightCount = 0
    } else {
      moveToRight()
      moveRightCount += 1
    }
  }
  
  private func moveToRight() {
    let newXPoint = node.position.x + tileWidth
    let action = SKAction.moveTo(x: newXPoint, duration: 1.0)
    node.run(action)
  }
  
  private func moveToInitPosition() {
    let action = SKAction.move(to: initPosition, duration: 1.0)
    node.run(action)
  }
}
