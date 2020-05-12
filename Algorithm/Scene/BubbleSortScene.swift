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
  private var swapAtIndex: [(i: Int, j: Int)] = []
  private var lhsAnimation: SKAction!
  private var rhsAnimation: SKAction!
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    backgroundColor = .lightGray
  }
  
  private func initValue() {
    removeAllActions()
    removeAllChildren()
    swapAtIndex.removeAll()
  }
  
  func start(numberOfTiles: Int) {
    initValue()
    generateTiles(numberOfTiles: numberOfTiles)
    generateAnimations()
    drawTiles()
    drawComparison(tileWidth: tiles[0].node.frame.width)
    sort() {
      self.swapAnimationAt(index: 0)
    }
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
  
  private func generateAnimations() {
    let node = tiles[0].node
    let rhsUpAction = SKAction.moveBy(x: 0, y: node.position.y, duration: 0.4)
    let rhsSlideAction = SKAction.moveBy(x: -1 * node.frame.width, y: 0, duration: 0.2)
    let rhsDownAction = SKAction.moveBy(x: 0, y: -1 * node.position.y, duration: 0.4)
    lhsAnimation = SKAction.moveBy(x: node.frame.width, y: 0, duration: 1.0)
    rhsAnimation = SKAction.sequence([rhsUpAction, rhsSlideAction, rhsDownAction])
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
  
  private func sort(completion: @escaping () -> Void) {
    var copyTiles = tiles
    l: for _ in 0..<copyTiles.count - 1 {
      var count = 0
      for i in 0..<copyTiles.count - 1 {
        if copyTiles[i].numberOfText > copyTiles[i+1].numberOfText {
          copyTiles.swapAt(i, i + 1)
          swapAtIndex.append((i, i + 1))
          count += 1
        }
        if count == 0 && (i + 1 == copyTiles.count - 1) { break l }
      }
    }
    completion()
  }
  
  private func swapAnimationAt(index: Int) {
    if swapAtIndex.count == index { return }
    let i = swapAtIndex[index].i
    let j = swapAtIndex[index].j
    let lhs = tiles[i], rhs = tiles[j]
    rhs.node.run(rhsAnimation)
    lhs.node.run(lhsAnimation) {
      self.tiles.swapAt(i, j)
      self.swapAnimationAt(index: index + 1)
    }
  }
}
