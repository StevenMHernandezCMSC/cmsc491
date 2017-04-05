//
//  GameScene.swift
//  MazeMan
//
//  Created by Steven Hernandez on 4/4/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import SpriteKit
import GameplayKit

let HEIGHT = 1024
let WIDTH = 1366
let BLOCKSIZE = 99
let LEFT_PADDING = (WIDTH % BLOCKSIZE) / 2

class GameScene: SKScene {
    
    private var caveman : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        self.caveman = self.childNode(withName: "//caveman") as? SKSpriteNode
        self.caveman?.size.height = CGFloat(BLOCKSIZE)
        self.caveman?.size.width = CGFloat(BLOCKSIZE)
        self.caveman?.position.x = CGFloat(LEFT_PADDING + (BLOCKSIZE / 2))
        self.caveman?.position.y = CGFloat(BLOCKSIZE * 3 / 2)
        
        self.renderTop()
        
        self.renderBottom()
        
        self.addAllGestureRecognizers()
    }
    
    func renderTop() {
        var i = BLOCKSIZE / 2 + LEFT_PADDING
        
        while (i < WIDTH) {
            for r in 0...1 {
                let block = SKSpriteNode(imageNamed: "block")
                block.position.x = CGFloat(i)
                block.position.y = CGFloat(HEIGHT - (BLOCKSIZE/2) - (r * BLOCKSIZE))
                block.size.height = CGFloat(BLOCKSIZE)
                block.size.width = CGFloat(BLOCKSIZE)
                self.addChild(block)
            }
            
            i += BLOCKSIZE
        }
    }
    
    func renderBottom() {
        var i = 0

        // decide where the 2 water blocks go
        let block1 = arc4random_uniform(UInt32(WIDTH / BLOCKSIZE))
        let block2 = block1 == 0 ? arc4random_uniform(UInt32(WIDTH / BLOCKSIZE)) + 1 : arc4random_uniform(block1 + 1)
        
        print(block1, block2)

        while (i * BLOCKSIZE) + (BLOCKSIZE / 2) + LEFT_PADDING < WIDTH {
            let block: SKSpriteNode
            if UInt32(i) == block1 || UInt32(i) == block2 {
                block = SKSpriteNode(imageNamed: "water")
            } else {
                block = SKSpriteNode(imageNamed: "block")
            }
            block.position.x = CGFloat((i * BLOCKSIZE) + BLOCKSIZE / 2 + LEFT_PADDING)
            block.position.y = CGFloat(BLOCKSIZE/2)
            block.size.height = CGFloat(BLOCKSIZE)
            block.size.width = CGFloat(BLOCKSIZE)
            self.addChild(block)
            i += 1
        }
    }
    
    func addAllGestureRecognizers() {
        for direction in [UISwipeGestureRecognizerDirection.left,
                          UISwipeGestureRecognizerDirection.right,
                          UISwipeGestureRecognizerDirection.up,
                          UISwipeGestureRecognizerDirection.down] {
                            let swipe = UISwipeGestureRecognizer()
                            swipe.direction = direction;
                            swipe.addTarget(self, action: #selector(moveCaveman))
                            self.view?.addGestureRecognizer(swipe)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func moveCaveman(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            var movement: SKAction?;
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.left:
                movement = SKAction.move(by: CGVector(dx: -BLOCKSIZE, dy: 0), duration: 1.0)
                self.caveman?.xScale = 1
            case UISwipeGestureRecognizerDirection.right:
                movement = SKAction.move(by: CGVector(dx: BLOCKSIZE, dy: 0), duration: 1.0)
                self.caveman?.xScale = -1
            case UISwipeGestureRecognizerDirection.up:
                movement = SKAction.move(by: CGVector(dx: 0, dy: BLOCKSIZE), duration: 1.0)
            case UISwipeGestureRecognizerDirection.down:
                movement = SKAction.move(by: CGVector(dx: 0, dy: -BLOCKSIZE), duration: 1.0)
            default:
                print("error, unhandled gesture direction", swipeGesture)
            }
            
            if var m = movement {
                m = SKAction.repeatForever(m)
                self.caveman?.run(m, withKey: "caveman_moving")
            }
        }
        
    }
}
