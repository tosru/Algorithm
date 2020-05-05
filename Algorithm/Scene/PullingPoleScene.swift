//
//  PullingPoleScene.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit
import UIKit

class PullingPoleScene: SKScene {
  
  private enum Direction {
    case up
    case right
    case down
    case left
    
    static func randomDirection(isTopPole: Bool) -> Direction {
      var allCase: [Direction]
      if isTopPole {
        allCase = [.up, .right, .down, .left]
      } else {
        allCase = [.right, .down, .left]
      }
      let randomIndex = Int.random(in: 0..<allCase.count)
      return allCase[randomIndex]
    }
  }
  
  private var mazeNumber: [[Int]] = []
  private var mazeNodes: [[Tile]] = []
  var mazeSize: Int!
  /// 通ることができる道
  private let path = 0
  private var pullingPoleNumber = 2
  private var timer: Timer!
  private let wall = 1
  private var xIndex = 2
  private var yIndex = 2
  var status: Status = .processing
  weak var myDelegate: StatusLabelDelegate?
  static var bottomSafeArea: CGFloat = 0
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    backgroundColor = .lightGray
  }
  
  func startMaze(mazeSize: Int) {
    self.mazeSize = mazeSize
    mazeNumber = mazeGenerator()
    drawMaze()
  }
  
  func initValue() {
    removeAllChildren()
    mazeNodes = [[Tile]]()
    mazeNumber = [[Int]]()
    xIndex = 2
    yIndex = 2
    timer.invalidate()
    timer = nil
    pullingPoleNumber = 2
    status = .processing
  }
  
  func startTimer(mazeSize: Int) {
    status = .running
    if mazeSize < 15 {
      timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(pullPole(sender:)), userInfo: nil, repeats: true)
    } else if mazeSize < 40 {
      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(pullPole(sender:)), userInfo: nil, repeats: true)
    } else if mazeSize < 50 {
      timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(pullPole(sender:)), userInfo: nil, repeats: true)
    } else {
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(pullPole(sender:)), userInfo: nil, repeats: true)
    }
  }
  
  @objc private func pullPole(sender: Timer) {
    if mazeSize - 3 < xIndex {
      yIndex += 2
      if mazeSize - 3 < yIndex {
        status = .end
        timer.invalidate()
        myDelegate?.changeStatusLabelText()
        return
      }
      xIndex = 2
    }
    let index = getPoleAroundIndex(y: yIndex, x: xIndex)
    for i in index {
      if mazeNumber[i.y][i.x] == pullingPoleNumber {
        mazeNodes[i.y][i.x].changePoleTexture(poleNum: pullingPoleNumber)
        pullingPoleNumber += 1
      }
    }
    xIndex += 2
  }
  
  private func mazeGenerator() -> [[Int]] {
    var maze: [[Int]] = []
    for y in 0..<mazeSize {
      var mazeRow: [Int] = []
      for x in 0..<mazeSize {
        if x == 0 || y == 0 || x == mazeSize - 1 || y == mazeSize - 1 {
          mazeRow.append(wall)
        } else {
          mazeRow.append(path)
        }
      }
      maze.append(mazeRow)
    }
    var poleNumber = 2
    for y in stride(from: 2, to: mazeSize - 1, by: 2) {
      for x in stride(from: 2, to: mazeSize - 1, by: 2) {
        maze[y][x] = poleNumber
        
        while true {
          var wallx = x
          var wally = y
          
          switch Direction.randomDirection(isTopPole: y == 2) {
          case .up:
            wally -= 1
          case .right:
            wallx += 1
          case .down:
            wally += 1
          case .left:
            wallx -= 1
          }
          if maze[wally][wallx] == path {
            //もし、まだ壁じゃなかったら
            //対応するポールの数字を入れる こうすることでどのポールから倒れた壁かがわかり
            //色付けに使える
            maze[wally][wallx] = poleNumber
            poleNumber += 1
            break
          }
        }
      }
    }
    return maze
  }
  
  private func drawMaze() {
    let oneSideLengthTile = size.width / CGFloat(mazeSize)
    
    for y in 0..<mazeSize {
      var tiles = [Tile]()
      for x in 0..<mazeSize {
        let tile = Tile(size: CGSize(width: oneSideLengthTile, height: oneSideLengthTile))
        tile.node.anchorPoint = CGPoint(x: 0, y: 1.0) //左上
        tile.node.position = CGPoint(x: oneSideLengthTile * CGFloat(x), y: size.width - oneSideLengthTile * CGFloat(y) + PullingPoleScene.bottomSafeArea)
        tiles.append(tile)
      }
      mazeNodes.append(tiles)
    }
    var poleNumber = 2
    for (y, tiles) in mazeNodes.enumerated() {
      for (x, tile) in tiles.enumerated() {
        if x == 0 || y == 0 || x == mazeSize - 1 || y == mazeSize - 1 {
          tile.changeToWall()
        } else if x % 2 == 0 && y % 2 == 0 {
          tile.changePoleTexture(poleNum: poleNumber)
          poleNumber += 1
        } else if x == 1 && y == 1 {
          tile.changeToStart()
        } else if x == mazeSize - 2 && y == mazeSize - 2 {
          tile.changeToGoal()
        } else {}
        addChild(tile.node)
      }
    }
  }
  
  private func getPoleAroundIndex(y: Int, x: Int) -> [(y: Int, x: Int)] {
    var index = [(y: Int, x: Int)]()
    if y == 2 {
      let upIndex = (y: y - 1, x: x)
      index.append(upIndex)
    }
    let rightIndex = (y: y, x: x + 1)
    let downIndex = (y: y + 1, x: x)
    let leftIndex = (y: y, x: x - 1)
    index.append(contentsOf: [rightIndex, downIndex, leftIndex])
    return index
  }
}
