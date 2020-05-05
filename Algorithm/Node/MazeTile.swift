//
//  Tile.swift
//  Algorithm
//
//  Created by tosru on 2020/04/26
//  ©︎ 2020 tosru
//

import SpriteKit

class MazeTile {
  
  private(set) var node: SKSpriteNode
  private let goalTexture = SKTexture(imageNamed: "maze_goal")
  private let poleTextures: [SKTexture] = [SKTexture(imageNamed: "maze_pole_1"), SKTexture(imageNamed: "maze_pole_2"), SKTexture(imageNamed: "maze_pole_3"), SKTexture(imageNamed: "maze_pole_4")]
  private let startTexture = SKTexture(imageNamed: "maze_start")
  private let wallTexture = SKTexture(imageNamed: "maze_wall")
    
  init(size: CGSize) {
    node = SKSpriteNode(texture: nil, color: SKColor.white, size: size)
  }
  
  func changeToWall() {
   node.texture = wallTexture
  }
  
  func changeToStart() {
    node.texture = startTexture
  }
  
  func changeToGoal() {
    node.texture = goalTexture
  }
  
  func changePoleTexture(poleNum: Int) {
    let index = poleNum % 4
    node.texture = poleTextures[index]
  }
}
