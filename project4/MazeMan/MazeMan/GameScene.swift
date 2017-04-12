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

let SPEED = 0.2

enum PhysicsCategory : UInt32 {
    case caveman = 1
    case block = 2
    case water = 4
    case star = 8
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var caveman : SKSpriteNode?
    
    private var blocks = [SKSpriteNode]()
    
    private var innerBlocksPlaced = 0
    
    private var innerBlocks = [Int: SKSpriteNode]()
    
    private var starLabel = SKLabelNode(fontNamed: "Arial")
    private var rockLabel = SKLabelNode(fontNamed: "Arial")
    private var livesLabel = SKLabelNode(fontNamed: "Arial")
    private var energyLabel = SKLabelNode(fontNamed: "Arial")
    
    private var starIcon = SKSpriteNode(imageNamed: "star")
    private var rockIcon = SKSpriteNode(imageNamed: "rock")
    private var livesIcon = SKSpriteNode(imageNamed: "heart")
    private var energyIcon = SKSpriteNode(imageNamed: "battery")
    
    // PLAYER:
    private var player = Player()
    
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
        
        self.player.rerenderCallback = updateGUI
        self.player.deathCallback = playerDied
        
        self.renderTop()
        
        self.renderSides()
        
        self.renderBottom()
        
        self.addBitMasks()
        
        self.addAllGestureRecognizers()
        
        self.renderGUI()
        
        self.addRandomBlock("star", PhysicsCategory.star.rawValue)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.addRandomBlockBlock), userInfo: nil, repeats: true)
    }
    
    func renderGUI() {
        let padding: CGFloat = 1.0
        
        starIcon.position.x = CGFloat(HALFBLOCK + LEFT_PADDING) + padding
        starIcon.position.y = CGFloat(HALFBLOCK + TOP_PADDING) + padding
        starIcon.size.height = CGFloat(BLOCKSIZE) - (padding * 8)
        starIcon.size.width = CGFloat(BLOCKSIZE) - (padding * 8)
        rockIcon.position.x = CGFloat(HALFBLOCK + LEFT_PADDING + BLOCKSIZE) + padding
        rockIcon.position.y = CGFloat(HALFBLOCK + TOP_PADDING) + padding
        rockIcon.size.height = CGFloat(BLOCKSIZE) - (padding * 8)
        rockIcon.size.width = CGFloat(BLOCKSIZE) - (padding * 8)
        livesIcon.position.x = CGFloat(HALFBLOCK + LEFT_PADDING + BLOCKSIZE * 2) + padding
        livesIcon.position.y = CGFloat(HALFBLOCK + TOP_PADDING) + padding
        livesIcon.size.height = CGFloat(BLOCKSIZE) - (padding * 8)
        livesIcon.size.width = CGFloat(BLOCKSIZE) - (padding * 8)
        energyIcon.position.x = CGFloat(HALFBLOCK + LEFT_PADDING) + (CGFloat(BLOCKSIZE) * 3.5) + padding
        energyIcon.position.y = CGFloat(HALFBLOCK + TOP_PADDING) + padding
        energyIcon.size.height = CGFloat(BLOCKSIZE) - (padding * 8)
        energyIcon.size.width = CGFloat(BLOCKSIZE * 2) - (padding * 8)
        
        starLabel.text = "2"
        starLabel.zPosition = 99
        starLabel.fontColor = .black
        starLabel.position.x = CGFloat(HALFBLOCK + LEFT_PADDING)
        starLabel.position.y = CGFloat(HALFBLOCK)
        
        rockLabel.text = "2"
        rockLabel.zPosition = 99
        rockLabel.position.x = CGFloat(HALFBLOCK + LEFT_PADDING + BLOCKSIZE)
        rockLabel.position.y = CGFloat(HALFBLOCK)
        
        livesLabel.text = "2"
        livesLabel.zPosition = 99
        livesLabel.position.x = CGFloat(HALFBLOCK + LEFT_PADDING + BLOCKSIZE * 2)
        livesLabel.position.y = CGFloat(HALFBLOCK)
        
        energyLabel.text = "2"
        energyLabel.zPosition = 99
        energyLabel.fontColor = .black
        energyLabel.position.x = CGFloat(HALFBLOCK + LEFT_PADDING) + (CGFloat(BLOCKSIZE) * 3.5)
        energyLabel.position.y = CGFloat(HALFBLOCK)
        
        self.addChild(starIcon)
        self.addChild(rockIcon)
        self.addChild(livesIcon)
        self.addChild(energyIcon)
        self.addChild(starLabel)
        self.addChild(rockLabel)
        self.addChild(livesLabel)
        self.addChild(energyLabel)
        
        self.updateGUI()
    }
    
    func updateGUI() {
        self.starLabel.text = String(self.player.stars)
        self.rockLabel.text = String(self.player.rocks)
        self.livesLabel.text = String(self.player.lives)
        self.energyLabel.text = String(self.player.energy)
    }
    
    func playerDied(_ livesRemaining: Int) {
        print("player died. forever ey", livesRemaining)
    }
    
    func addRandomBlockBlock() {
        self.addRandomBlock("block", PhysicsCategory.block.rawValue)
    }
    
    /**
     * Add random block to the center. Max 15 blocks,
     * afterwhich we invalidate the timer.
     */
    func addRandomBlock(_ name: String, _ category: UInt32) {
        var column = 0
        var row = 0
        
        // prevent blocks from overlapping
        repeat {
            column = Int(arc4random_uniform(UInt32(COLUMN_COUNT)))
            row = Int(arc4random_uniform(UInt32(ROW_COUNT) - 3)) + 1
        } while (self.innerBlocks[COLUMN_COUNT * column + row] != nil)
        // TODO: while self.notOccupied() // caveman, other items, enemies, other blocks
        
        let block = SKSpriteNode(imageNamed: name)
        let x = LEFT_PADDING + column * BLOCKSIZE + HALFBLOCK
        let y = row * BLOCKSIZE + HALFBLOCK + TOP_PADDING
        self.createBlock(block: block, x: x, y: y, category: category)
        
        self.innerBlocks[COLUMN_COUNT * column + row] = block
        
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
    
    func renderSides() {
        let leftBlock = SKSpriteNode()
        self.createBlock(block: leftBlock, x: LEFT_PADDING - 1, y: HEIGHT / 2, width: 2, height: HEIGHT, category: PhysicsCategory.block.rawValue)
        
        let rightBlock = SKSpriteNode()
        self.createBlock(block: rightBlock, x: WIDTH - LEFT_PADDING + 1, y: HEIGHT / 2, width: 2, height: HEIGHT, category: PhysicsCategory.block.rawValue)
    }
    
    func renderBottom() {
        var i = 0
        
        // decide where the 2 water blocks go
        let block1 = arc4random_uniform(UInt32(COLUMN_COUNT))
        let block2 = block1 == 0 ? arc4random_uniform(UInt32(COLUMN_COUNT)) + 1 : arc4random_uniform(block1 + 1)
        
        while (i * BLOCKSIZE) + (BLOCKSIZE / 2) + LEFT_PADDING < WIDTH {
            let block: SKSpriteNode
            let category: UInt32
            if UInt32(i) == block1 || UInt32(i) == block2 {
                block = SKSpriteNode(imageNamed: "water")
                category = PhysicsCategory.water.rawValue
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
        self.createBlock(block: block, x: x, y: y, width: BLOCKSIZE, height: BLOCKSIZE, category: category)
    }
    
    func createBlock(block: SKSpriteNode, x: Int, y: Int, width: Int, height: Int, category: UInt32) {
        block.position.x = CGFloat(x)
        block.position.y = CGFloat(y)
        block.size.height = CGFloat(height)
        block.size.width = CGFloat(width)
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
        self.caveman?.physicsBody?.contactTestBitMask = PhysicsCategory.block.rawValue | PhysicsCategory.water.rawValue | PhysicsCategory.star.rawValue
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
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.block.rawValue) {
            self.caveman?.removeAllActions()
        }
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.water.rawValue) {
            let _ = self.player.loseLife()
            
            self.caveman?.removeAllActions()
        }
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.star.rawValue) {
            self.player.incrementStar(1)
            
            let star = contact.bodyA.categoryBitMask == PhysicsCategory.star.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            let starPosition = self.findBlockInInnerBlocksDictionary(node: star as! SKSpriteNode)
            
            self.innerBlocks.removeValue(forKey: starPosition)
            
            self.removeChildren(in: [star!])
            
            self.addRandomBlock("star", PhysicsCategory.star.rawValue)
        }
    }
    
    /*
     * Search self.innerBlocks dictionary for a specific value
     */
    func findBlockInInnerBlocksDictionary(node: SKSpriteNode) -> Int {
        for (index, entry) in self.innerBlocks {
            if (entry == node) {
                return index
            }
        }
        
        return -1
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
                movement = SKAction.move(by: CGVector(dx: -BLOCKSIZE, dy: 0), duration: SPEED)
                self.caveman?.xScale = 1
            case UISwipeGestureRecognizerDirection.right:
                movement = SKAction.move(by: CGVector(dx: BLOCKSIZE, dy: 0), duration: SPEED)
                self.caveman?.xScale = -1
            case UISwipeGestureRecognizerDirection.up:
                movement = SKAction.move(by: CGVector(dx: 0, dy: BLOCKSIZE), duration: SPEED)
            case UISwipeGestureRecognizerDirection.down:
                movement = SKAction.move(by: CGVector(dx: 0, dy: -BLOCKSIZE), duration: SPEED)
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
