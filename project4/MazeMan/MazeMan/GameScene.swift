//
//  GameScene.swift
//  MazeMan
//
//  Created by Steven Hernandez on 4/4/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import SpriteKit
import GameplayKit

let WIDTH = 1366
let BLOCKSIZE = 99
let LEFT_PADDING = (WIDTH % BLOCKSIZE) / 2

class GameScene: SKScene {
    
    private var caveman : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        self.caveman = self.childNode(withName: "//caveman") as? SKSpriteNode
        self.caveman?.size.height = CGFloat(BLOCKSIZE)
        self.caveman?.size.width = CGFloat(BLOCKSIZE)
        print(self.caveman?.position.x ?? "nothing")
        self.caveman?.position.x = CGFloat(LEFT_PADDING + (BLOCKSIZE / 2))
        self.caveman?.position.y = CGFloat(BLOCKSIZE * 3 / 2)
        
        self.renderBottom()
        
        self.addAllGestureRecognizers()
    }
    
    func renderBottom() {
        var i = BLOCKSIZE / 2 + LEFT_PADDING
        while (i < WIDTH) {
            let block = SKSpriteNode(imageNamed: "block")
            block.position.x = CGFloat(i)
            block.position.y = CGFloat(BLOCKSIZE/2)
            block.size.height = CGFloat(BLOCKSIZE)
            block.size.width = CGFloat(BLOCKSIZE)
            self.addChild(block)
            i += BLOCKSIZE
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
