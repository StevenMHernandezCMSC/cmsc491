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

let BLOCKSIZE = 72
let HALFBLOCK = BLOCKSIZE / 2

let COLUMN_COUNT = Int(WIDTH / BLOCKSIZE)
let ROW_COUNT = Int(HEIGHT / BLOCKSIZE)

let TOP_PADDING = (HEIGHT % BLOCKSIZE) / 2
let LEFT_PADDING = (WIDTH % BLOCKSIZE) / 2

let MAX_BLOCK_COUNT = 15
let count = COLUMN_COUNT * ROW_COUNT

enum PhysicsCategory : UInt32 {
    case caveman = 1
    case block = 2
    case water = 4
//    case ground = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var caveman : SKSpriteNode?
    
    private var blocks = [SKSpriteNode]()
    
    private var innerBlocksPlaced = 0
    
    private var innerBlocks = [Int: SKSpriteNode]()
    
    var timer: Timer?
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        self.caveman = self.childNode(withName: "//caveman") as? SKSpriteNode
        self.caveman?.size.height = CGFloat(BLOCKSIZE) * 0.8
        self.caveman?.size.width = CGFloat(BLOCKSIZE) * 0.8
        self.caveman?.position.x = CGFloat(LEFT_PADDING + (BLOCKSIZE / 2))
        self.caveman?.position.y = CGFloat(BLOCKSIZE * 3 / 2) + 8
        self.caveman?.xScale = -1
        self.caveman?.physicsBody?.isDynamic =  false
        self.caveman?.physicsBody?.allowsRotation =  false
        
        self.renderTop()
        
        self.renderBottom()
        
        self.addBitMasks()
        
        self.addAllGestureRecognizers()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.addRandomBlock), userInfo: nil, repeats: true)
    }
    
    /**
     * Add random block to the center. Max 15 blocks,
     * afterwhich we invalidate the timer.
     */
    func addRandomBlock() {
        var column = 0
        var row = 0
        
        // prevent blocks from overlapping
        repeat {
            column = Int(arc4random_uniform(UInt32(COLUMN_COUNT)))
            row = Int(arc4random_uniform(UInt32(ROW_COUNT) - 3)) + 1
        } while (self.innerBlocks[COLUMN_COUNT * column + row] != nil)
        // TODO: while self.notOccupied() // caveman, other items, enemies, other blocks
        
        print (column, row)
        
        let block = SKSpriteNode(imageNamed: "block")
        let x = LEFT_PADDING + column * BLOCKSIZE + HALFBLOCK
        let y = row * BLOCKSIZE + HALFBLOCK + TOP_PADDING
        self.createBlock(block: block, x: x, y: y, category: PhysicsCategory.block.rawValue)
        
        self.innerBlocks[COLUMN_COUNT * column + row] = block
        print(self.innerBlocks)
        
        if (self.innerBlocks.count >= MAX_BLOCK_COUNT) {
            self.timer?.invalidate()
        }
    }
    
    func renderTop() {
        var i = BLOCKSIZE / 2 + LEFT_PADDING
        
        while (i < WIDTH) {
            for r in 0...1 {
                let block = SKSpriteNode(imageNamed: "block")
                let x = i
                let y = HEIGHT - (BLOCKSIZE/2) - (r * BLOCKSIZE) - TOP_PADDING
                self.createBlock(block: block, x: x, y: y, category: PhysicsCategory.block.rawValue)
            }
            
            i += BLOCKSIZE
        }
    }
    
    func renderBottom() {
        var i = 0

        // decide where the 2 water blocks go
        let block1 = arc4random_uniform(UInt32(COLUMN_COUNT))
        let block2 = block1 == 0 ? arc4random_uniform(UInt32(COLUMN_COUNT)) + 1 : arc4random_uniform(block1 + 1)
        
        print(block1, block2)

        while (i * BLOCKSIZE) + (BLOCKSIZE / 2) + LEFT_PADDING < WIDTH {
            let block: SKSpriteNode
            let category: UInt32
            if UInt32(i) == block1 || UInt32(i) == block2 {
                block = SKSpriteNode(imageNamed: "water")
                category = PhysicsCategory.water.rawValue
                print(PhysicsCategory.water.rawValue, category)
            } else {
                block = SKSpriteNode(imageNamed: "block")
                category = PhysicsCategory.block.rawValue
            }
            let x = (i * BLOCKSIZE) + BLOCKSIZE / 2 + LEFT_PADDING
            let y = (BLOCKSIZE / 2) + TOP_PADDING
            self.createBlock(block: block, x: x, y: y, category: category)
            i += 1
        }
    }
    
    func createBlock(block: SKSpriteNode, x: Int, y: Int, category: UInt32) {
        block.position.x = CGFloat(x)
        block.position.y = CGFloat(y)
        block.size.height = CGFloat(BLOCKSIZE)
        block.size.width = CGFloat(BLOCKSIZE)
        self.addChild(block)
        self.blocks.append(block)
        block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
        block.physicsBody?.affectedByGravity =  false
        block.physicsBody?.isDynamic =  false
        block.physicsBody?.pinned =  true
        block.physicsBody?.categoryBitMask = category
    }
    
    func addBitMasks(){
        self.caveman?.physicsBody = SKPhysicsBody(rectangleOf: (self.caveman?.size)!)
        self.caveman?.physicsBody?.affectedByGravity =  false
        self.caveman?.physicsBody?.categoryBitMask = PhysicsCategory.caveman.rawValue
        self.caveman?.physicsBody?.contactTestBitMask = PhysicsCategory.block.rawValue | PhysicsCategory.water.rawValue
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
    
    func didBegin(_ contact: SKPhysicsContact) {
        print(contact.bodyA.categoryBitMask,contact.bodyB.categoryBitMask)
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.block.rawValue) {
            print("CAVEMAN contacted block")
            
            self.caveman?.removeAllActions()
        }
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.water.rawValue) {
            print("CAVEMAN contacted water")
            
            self.caveman?.removeAllActions()
            
            // TODO: drown
        }
    }
    
    /**
     * Depending on
     */
    func didContact(_ contact: SKPhysicsContact, _ a: UInt32, _ b: UInt32) -> Bool {
        return (contact.bodyA.categoryBitMask == a && contact.bodyB.categoryBitMask == b) ||
               (contact.bodyA.categoryBitMask == b && contact.bodyB.categoryBitMask == a)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func moveCaveman(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.caveman?.removeAllActions()
            
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
