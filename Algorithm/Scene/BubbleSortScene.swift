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
  private let colors: [UIColor] = [
    UIColor.rgb(red: 154, green: 0, blue: 0),
    UIColor.rgb(red: 142, green: 0, blue: 154),
    UIColor.rgb(red: 59, green: 0, blue: 154),
    UIColor.rgb(red: 0, green: 154, blue: 136),
    UIColor.rgb(red: 0, green: 154, blue: 18),
    UIColor.rgb(red: 148, green: 154, blue: 0),
    .darkGray,
    .black
  ]
  private var comparison: Comparison!
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    backgroundColor = .lightGray
    start(numberOfTiles: 8)
  }
  
  private func initValue() {
    removeAllActions()
    removeAllChildren()
  }
  
  func start(numberOfTiles: Int) {
    initValue()
    generateTiles(numberOfTiles: numberOfTiles)
    drawTiles()
    drawComparison(tileWidth: tiles[0].node.frame.width)
  }
  
  private func drawTiles() {
    tiles.forEach { tile in
      addChild(tile.node)
    }
  }
  
  private func generateTiles(numberOfTiles: Int) {
    let side: CGFloat = frame.size.width / CGFloat(numberOfTiles)
    let rect = CGRect(x: 0, y: 0, width: side, height: side)
    tiles = (1...numberOfTiles).map { numberOfText in
      let color = colors[numberOfText - 1]
      let tile = SortTile(rect: rect, color: color, numberOfText: numberOfText)
      return tile
    }
    tiles.shuffle()
    setupTilesPosition(side: side)
  }
  
  private func setupTilesPosition(side: CGFloat) {
    for (i, tile) in tiles.enumerated() {
      let position = CGPoint(x: CGFloat(i) * side + 0, y: 70)
      tile.node.position = position
    }
  }
  
  private func drawComparison(tileWidth: CGFloat) {
    let offsetOfTile: CGFloat = 15
    let position = CGPoint(x: tiles[0].node.frame.midX, y: 70 - offsetOfTile)
    comparison = Comparison(width: tileWidth, position: position)
    addChild(comparison.node)
  }
}
