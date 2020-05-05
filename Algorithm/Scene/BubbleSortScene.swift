//
//  BubbleSortScene.swift
//  Algorithm
//
//  Created by tosru on 2020/05/03
//  ©︎ 2020 tosru
//

import SpriteKit

class BubbleSortScene: SKScene {
  
  private(set) var status: Status = .processing
  weak var myDelegate: StatusLabelDelegate?
  private var tiles: [SortTile] = []
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    backgroundColor = .lightGray
    let tmptile = SortTile(rect: CGRect(x: 10, y: 10, width: 50, height: 50), color: .blue, textNumber: 5)
    addChild(tmptile.node)
  }
  
  
  
}
