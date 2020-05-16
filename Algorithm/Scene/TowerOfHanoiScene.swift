//
//  TowerOfHanoiScene.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit

protocol StatusLabelDelegate: AnyObject {
  func changeStatusLabelText()
}

enum Status: String {
  case initial
  case processing = "処理中"
  case running = "実行中"
  case end = "終了"
}

class TowerOfHanoiScene: SKScene {
  
  private var baseNode: SKSpriteNode!
  private(set) var defaultDuration: [String: TimeInterval] = ["upDown": 0.4, "leftRight": 0.2]
  private var disks: [Disk] = []
  private var destinationDisks: [(numDisk: Int, from: Stick, to: Stick)] = []
  private var diskCounter = 0 //1番目の要素から0番目の要素はstartHanoiで呼んでいる moveDiskで1行目に+1するので0からになっている
  private var sticks: [Stick] = []
  var status: Status = .processing
  weak var myDelegate: StatusLabelDelegate?
  static var bottomSafeArea: CGFloat = 0
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    backgroundColor = .lightGray
  }
  
  func startHanoi(numDisk: Int) {
    status = .running
    drawBase()
    drawSticks()
    drawDisks(numDisk: numDisk)
    hanoiAlgorithm(numDisk: disks.count, from: sticks[0], evacuation: sticks[1], to: sticks[2])
    myDelegate?.changeStatusLabelText()
    moveDisk(numDisk: destinationDisks[0].numDisk, from: destinationDisks[0].from, to: destinationDisks[0].to)
  }
  
  func initValue() {
    scene?.removeAllActions()
    scene?.removeAllChildren()
    sticks = []
    disks = []
    destinationDisks = []
    diskCounter = 0
    status = .processing
  }
  
  private func drawBase() {
    baseNode = SKSpriteNode(texture: nil, size: CGSize(width: size.width * 0.9, height: 30))
    baseNode.position = CGPoint(x: frame.midX, y: baseNode.frame.size.height * 0.5 + TowerOfHanoiScene.bottomSafeArea)
    baseNode.color = .black
    addChild(baseNode)
  }
  
  private func drawSticks() {
    let baseWidth = size.width / 4.0
    let leftStick = Stick(size: CGSize(width: 7, height: size.height * 0.27))
    let centerStick = Stick(size: CGSize(width: 7, height: size.height * 0.27))
    let rightStick = Stick(size: CGSize(width: 7, height: size.height * 0.27))
    
    leftStick.node.anchorPoint = CGPoint(x: 0.5, y: 0)
    centerStick.node.anchorPoint = CGPoint(x: 0.5, y: 0)
    rightStick.node.anchorPoint = CGPoint(x: 0.5, y: 0)
    
    leftStick.node.position = CGPoint(x: baseWidth, y: baseNode.frame.size.height + TowerOfHanoiScene.bottomSafeArea)
    centerStick.node.position = CGPoint(x: baseWidth * 2, y: baseNode.frame.size.height + TowerOfHanoiScene.bottomSafeArea)
    rightStick.node.position = CGPoint(x: baseWidth * 3, y: baseNode.frame.size.height + TowerOfHanoiScene.bottomSafeArea)
    
    sticks.append(leftStick)
    sticks.append(centerStick)
    sticks.append(rightStick)
    sticks.forEach { addChild($0.node) }
  }
  
  private func drawDisks(numDisk: Int) {
    var diskWidthScale: CGFloat = 1.0
    let diskBaseWidth = size.width / 4.0
    for i in 0..<numDisk {
      let disk = Disk(size: CGSize(width: diskBaseWidth * diskWidthScale, height: 20))
      disk.changeColor(diskNum: i)
      disk.node.position = CGPoint(x: sticks[0].node.position.x, y: sticks[0].pileHeight + disk.node.frame.size.height * 0.5 + baseNode.frame.size.height + TowerOfHanoiScene.bottomSafeArea)
      sticks[0].increaseHeight(diskHeight: disk.node.frame.size.height)
      diskWidthScale *= 0.85
      disks.append(disk)
      addChild(disk.node)
    }
    disks.reverse()
  }
  
  private func hanoiAlgorithm(numDisk: Int, from: Stick, evacuation: Stick, to: Stick) {
    if numDisk > 0 {
      hanoiAlgorithm(numDisk: numDisk - 1, from: from, evacuation: to, to: evacuation)
      destinationDisks.append((numDisk - 1, from, to))
      hanoiAlgorithm(numDisk: numDisk - 1, from: evacuation, evacuation: from, to: to)
    }
  }
  
  private func moveDisk(numDisk: Int, from: Stick, to: Stick) {
    diskCounter += 1
    let upPosition = from.node.size.height * 1.4
    let upAction = SKAction.moveTo(y: upPosition, duration: defaultDuration["upDown"]!)
    let sidePosition = to.node.position.x
    let sideAction = SKAction.moveTo(x: sidePosition, duration: defaultDuration["leftRight"]!)
    let downPosition = baseNode.size.height + to.pileHeight + disks[numDisk].node.size.height * 0.5 + TowerOfHanoiScene.bottomSafeArea
    let downAction = SKAction.moveTo(y: downPosition, duration: defaultDuration["upDown"]!)
    let sequenceAction = SKAction.sequence([upAction, sideAction, downAction])
    disks[numDisk].node.run(sequenceAction) {
      from.decreaseHeight(diskHeight: self.disks[numDisk].node.size.height)
      to.increaseHeight(diskHeight: self.disks[numDisk].node.size.height)
      if self.destinationDisks.count <= self.diskCounter {
        self.status = .end
        self.myDelegate?.changeStatusLabelText()
        return
      }
      self.moveDisk(
        numDisk: self.destinationDisks[self.diskCounter].numDisk,
        from: self.destinationDisks[self.diskCounter].from,
        to: self.destinationDisks[self.diskCounter].to)
    }
  }
  
  func changeSpeed(speedScale: Double) {
    // デフォルトに対しての倍率のため毎回初期化する必要がある
    defaultDuration = ["upDown": 0.4, "leftRight": 0.2]
    let tmp1: TimeInterval = defaultDuration["upDown"]!
    let tmp2: TimeInterval = defaultDuration["leftRight"]!
    defaultDuration.updateValue(tmp1 * speedScale, forKey: "upDown")
    defaultDuration.updateValue(tmp2 * speedScale, forKey: "leftRight")
  }
}
