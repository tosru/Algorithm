//
//  BubbleSortScene.swift
//  Algorithm
//
//  Created by tosru on 2020/05/03
//  ©︎ 2020 tosru
//

import SpriteKit

class BubbleSortScene: SKScene {
  private(set) var status: Status = .initial
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
  private var waitAnimation: SKAction!
  
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
    status = .running
    myDelegate?.changeStatusLabelText()
    initValue()
    generateTiles(numberOfTiles: numberOfTiles)
    generateAnimations()
    drawTiles()
    drawComparison()
    sort() {
      self.swapAnimationAt(index: 0)
    }
  }
  
  func clear() {
    status = .initial
    initValue()
  }
  
  private func drawTiles() {
    tiles.forEach { tile in
      addChild(tile.node)
    }
  }
  
  private func generateTiles(numberOfTiles: Int) {
    let side: CGFloat = frame.size.width / CGFloat(numberOfTiles)
    let rect = CGRect(x: 0, y: 0, width: side, height: side)
    tiles = (1...numberOfTiles).map { numberForText in
      let color = colors[numberForText - 1]
      let tile = SortTile(rect: rect, color: color, numberForText: numberForText)
      return tile
    }
    tiles.shuffle()
    setupTilesPosition(side: side)
  }
  
  private func generateAnimations() {
    let node = tiles[0].node
    let distance = node.frame.height + 10
    let rhsUpAction = SKAction.moveBy(x: 0, y: distance, duration: 0.4)
    let rhsSlideAction = SKAction.moveBy(x: -1 * node.frame.width, y: 0, duration: 0.2)
    let rhsDownAction = SKAction.moveBy(x: 0, y: -1 * distance, duration: 0.4)
    lhsAnimation = SKAction.moveBy(x: node.frame.width, y: 0, duration: 1.0)
    rhsAnimation = SKAction.sequence([rhsUpAction, rhsSlideAction, rhsDownAction])
    waitAnimation = SKAction.wait(forDuration: 0.5)
  }
  
  private func setupTilesPosition(side: CGFloat) {
    for (i, tile) in tiles.enumerated() {
      let position = CGPoint(x: CGFloat(i) * side + 0, y: 70)
      tile.node.position = position
    }
  }
  
  private func drawComparison() {
    let offsetOfTile: CGFloat = 15
    let tileFrame = tiles[0].node.frame
    let position = CGPoint(x: tileFrame.midX, y: 70 - offsetOfTile)
    comparison = Comparison(width: tileFrame.width, position: position, numberOfTiles: tiles.count)
    addChild(comparison.node)
  }
  
  private func sort(completion: @escaping () -> Void) {
    var copyTiles = tiles
    l: for i in 0..<copyTiles.count - 1 {
      var count = 0
      for j in 0..<copyTiles.count - 1 - i {
        if copyTiles[j].numberForText > copyTiles[j + 1].numberForText {
          copyTiles.swapAt(j, j + 1)
          swapAtIndex.append((j, j + 1))
          count += 1
        } else {
          // swapしない場合は、同じindexを追加する
          swapAtIndex.append((j, j))
        }
        // sortが完了しているなら抜ける
        if count == 0 && (j + 1 + i == copyTiles.count - 1) { break l }
      }
    }
    completion()
  }
  
  private func swapAnimationAt(index: Int) {
    if swapAtIndex.count == index {
      status = .end
      myDelegate?.changeStatusLabelText()
      return
    }
    // sequenceに入れてもmoveを呼び出すだけなのでcomparisonを動かす時間を待ってくれるわけではない(たぶん)
    let comparisonAnimation = SKAction.run { self.comparison.move() }
    let groupAnimation = SKAction.group([comparisonAnimation, SKAction.wait(forDuration: 1.0)])
    let i = swapAtIndex[index].i
    let j = swapAtIndex[index].j
    if i != j {
      // swapさせる場合は、0.5秒待機 -> 1秒でswap -> 0.5秒待機 -> 1秒でcomparisonの移動
      let lhs = tiles[i], rhs = tiles[j]
      rhs.node.run(SKAction.sequence([waitAnimation, rhsAnimation, waitAnimation]))
      lhs.node.run(SKAction.sequence([waitAnimation, lhsAnimation, waitAnimation, groupAnimation])) {
        self.tiles.swapAt(i, j)
        self.swapAnimationAt(index: index + 1)
      }
    } else {
      // swapさせない場合は、2秒待機 -> 1秒でcomparisonの移動
      scene?.run(SKAction.sequence([SKAction.wait(forDuration: 2.0), groupAnimation])) {
        self.swapAnimationAt(index: index + 1)
      }
    }
  }
}
