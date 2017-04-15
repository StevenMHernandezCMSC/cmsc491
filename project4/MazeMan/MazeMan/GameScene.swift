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

let SPEED = 0.3
let ENEMY_SPEED_UP = 0.2 // .5 = 200x faster

enum PhysicsCategory : UInt32 {
    case caveman = 1
    case block = 2
    case water = 4
    case star = 8
    case food = 16
    case dino = 32
    case immuneDino = 64
    case rock = 128
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var caveman : SKSpriteNode?
    
    private var blocks = [SKSpriteNode]()
    private var waterBlocks = [SKSpriteNode]()
    
    private var innerBlocksPlaced = 0
    
    private var innerBlocks = [Int: SKSpriteNode]()
    
    private var randomBlockCount = 0
    
    /*
     * DINO ATTRIBUTES
     * These should really be seperated to their own files.
     */
    private var dino1 = SKSpriteNode(imageNamed: "dino1")
    private var dino1Direction:Bool = true
    
    private var dino2 = SKSpriteNode(imageNamed: "dino2")
    private var dino2Direction:Bool = true
    
    private var dino3 = SKSpriteNode(imageNamed: "dino3")
    private var dino3Direction:Bool = true
    
    private var dino4 = SKSpriteNode(imageNamed: "dino4")
    private var dino4Direction:Bool = true
    
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
        
        let _ = self.addRandomBlock("star", PhysicsCategory.star.rawValue)
        
        self.addFood()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.addRandomBlockBlock), userInfo: nil, repeats: true)
        
        self.addDino1();
        self.addDino2();
        self.addDino3();
        self.addDino4();
    }
    
    /**
     * DINO METHODS
     * These should really be placed into their own files.
     */
    
    func addDino1() {
        let waterBlock = self.waterBlocks[Int(arc4random_uniform(UInt32(self.waterBlocks.count)))]
        
        self.dino1 = SKSpriteNode(imageNamed: "dino1")
        
        self.createBlock(block: self.dino1, x: Int(waterBlock.position.x), y: Int(waterBlock.position.y), category: PhysicsCategory.dino.rawValue)
        
        self.dino1Direction = true
        
        self.moveDino1()
    }
    
    func moveDino1() {
        self.dino1Direction = !self.dino1Direction
        
        let wait = SKAction.wait(forDuration: 2.0, withRange: 1.0)
        
        let action = self.dino1Direction
            ? SKAction.move(by: CGVector(dx: 0, dy: -BLOCKSIZE * 3), duration: 3 * ENEMY_SPEED_UP)
            : SKAction.move(by: CGVector(dx: 0, dy: BLOCKSIZE * 3), duration: 3 * ENEMY_SPEED_UP)
        
        self.dino1.run(SKAction.sequence([wait, action])) {
            self.moveDino1()
        }
    }
    
    func removeDino1() {
        self.removeChildren(in: [self.dino1])
        
        let respawnTime = Int(arc4random_uniform(5))
        
        Timer.scheduledTimer(timeInterval: TimeInterval(respawnTime), target: self, selector: #selector(GameScene.addDino1), userInfo: nil, repeats: false)
    }
    
    func addDino2() {
        self.dino2 = SKSpriteNode(imageNamed: "dino2")
        
        let randomRow = Int(arc4random_uniform(UInt32(ROW_COUNT) - 3)) + 1
        
        let y = randomRow * BLOCKSIZE + HALFBLOCK + TOP_PADDING
        
        self.createBlock(block: self.dino2, x: WIDTH - BLOCKSIZE - LEFT_PADDING, y: y, category: PhysicsCategory.dino.rawValue)
        
        self.dino2Direction = true
        
        self.moveDino2()
    }
    
    func moveDino2() {
        self.dino2Direction = !self.dino2Direction
        
        let wait = SKAction.wait(forDuration: 2.0, withRange: 1.0)
        
        let action = self.dino2Direction
            ? SKAction.move(by: CGVector(dx: BLOCKSIZE * 9, dy: 0), duration: 9 * ENEMY_SPEED_UP)
            : SKAction.move(by: CGVector(dx: -BLOCKSIZE * 9, dy: 0), duration: 9 * ENEMY_SPEED_UP)
        
        
        self.dino2.xScale = self.dino2Direction ? -1 : 1
        
        self.dino2.run(SKAction.sequence([wait, action])) {
            self.moveDino2()
        }
    }
    
    func removeDino2() {
        self.removeChildren(in: [self.dino2])
        
        let respawnTime = Int(arc4random_uniform(5))
        
        Timer.scheduledTimer(timeInterval: TimeInterval(respawnTime), target: self, selector: #selector(GameScene.addDino2), userInfo: nil, repeats: false)
    }
    
    func addDino3() {
        self.dino3 = SKSpriteNode(imageNamed: "dino3")
        
        self.dino3.xScale = -1
        
        self.createBlock(block: self.dino3, x: LEFT_PADDING + HALFBLOCK, y: HEIGHT - (2 * BLOCKSIZE) - TOP_PADDING - HALFBLOCK, category: PhysicsCategory.dino.rawValue)
        
        self.dino3.physicsBody = SKPhysicsBody(rectangleOf: self.dino3.size)
        self.dino3.physicsBody?.affectedByGravity =  false
        self.dino3.physicsBody?.categoryBitMask = PhysicsCategory.dino.rawValue
        self.dino3.physicsBody?.contactTestBitMask = PhysicsCategory.block.rawValue
        self.dino3.physicsBody?.collisionBitMask = 0
        
        self.dino1Direction = true
        
        self.moveDino3()
    }
    
    func moveDino3() {
        var dx = 0
        var dy = 0
        
        if arc4random_uniform(2) == 1 {
            dx = arc4random_uniform(2) == 1 ? 1 : -1
        } else {
            dy = arc4random_uniform(2) == 1 ? 1 : -1
        }
        
        if dx == 1 {
            self.dino3.xScale = 1
        } else if dx == -1 {
            self.dino3.xScale = -1
        }
        
        self.dino3.run(SKAction.repeatForever(SKAction.move(by: CGVector(dx: dx * BLOCKSIZE, dy: dy * BLOCKSIZE), duration: 1 * ENEMY_SPEED_UP)))
    }
    
    func removeDino3() {
        self.removeChildren(in: [self.dino3])
        
        let respawnTime = Int(arc4random_uniform(5))
        
        Timer.scheduledTimer(timeInterval: TimeInterval(respawnTime), target: self, selector: #selector(GameScene.addDino3), userInfo: nil, repeats: false)
    }
    
    func addDino4() {
        self.dino4 = SKSpriteNode(imageNamed: "dino4")
        
        self.createBlock(block: self.dino4, x: BLOCKSIZE, y: HEIGHT - BLOCKSIZE * 2, category: PhysicsCategory.immuneDino.rawValue)
        
        self.dino4.zPosition = 99
        
        self.moveDino4()
    }
    
    func moveDino4() {
        self.dino4Direction = !self.dino4Direction
        
        let wait = SKAction.wait(forDuration: 2.0, withRange: 1.0)
        
        let distance = WIDTH - BLOCKSIZE - (2 * LEFT_PADDING)
        
        let action = self.dino4Direction
            ? SKAction.move(by: CGVector(dx: -distance, dy: 0), duration: TimeInterval(WIDTH) * ENEMY_SPEED_UP / TimeInterval(BLOCKSIZE))
            : SKAction.move(by: CGVector(dx: distance, dy: 0), duration: TimeInterval(WIDTH) * ENEMY_SPEED_UP / TimeInterval(BLOCKSIZE))
        
        self.dino4.run(SKAction.sequence([wait, action])) {
            self.moveDino4()
        }
    }
    
    func removeDino4() {
        self.removeChildren(in: [self.dino1])
        
        let respawnTime = Int(arc4random_uniform(5))
        
        Timer.scheduledTimer(timeInterval: TimeInterval(respawnTime), target: self, selector: #selector(GameScene.addDino4), userInfo: nil, repeats: false)
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
        self.livesLabel.text = String(self.player.energy / 100)
        self.energyLabel.text = String(self.player.energy % 100)
    }
    
    func playerDied() {
        // TODO: reset
        print("player died. forever ey")
    }
    
    func addRandomBlockBlock() -> SKSpriteNode {
        let block = self.addRandomBlock("block", PhysicsCategory.block.rawValue)
        
        self.randomBlockCount += 1
        
        print(self.randomBlockCount, MAX_BLOCK_COUNT)
        
        if self.randomBlockCount >= MAX_BLOCK_COUNT {
            self.timer?.invalidate()
        }
        
        return block
    }
    
    /**
     * Add random block to the center. Max 15 blocks,
     * afterwhich we invalidate the timer.
     */
    func addRandomBlock(_ name: String, _ category: UInt32) -> SKSpriteNode {
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
        
        return block
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
                self.waterBlocks.append(block)
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
        self.caveman?.physicsBody?.contactTestBitMask = PhysicsCategory.block.rawValue | PhysicsCategory.water.rawValue | PhysicsCategory.star.rawValue | PhysicsCategory.food.rawValue | PhysicsCategory.dino.rawValue
        self.caveman?.physicsBody?.collisionBitMask = 0
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
        
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(throwRock))
        self.view?.addGestureRecognizer(tap)
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
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.block.rawValue) {
            self.caveman?.removeAllActions()
        }
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.water.rawValue) {
            let _ = self.player.decrementEnergy(self.player.energy)
            
            self.caveman?.removeAllActions()
        }
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.star.rawValue) {
            self.player.incrementStar(1)
            
            let star = contact.bodyA.categoryBitMask == PhysicsCategory.star.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            let starPosition = self.findBlockInInnerBlocksDictionary(node: star as! SKSpriteNode)
            
            self.innerBlocks.removeValue(forKey: starPosition)
            
            self.removeChildren(in: [star!])
            
            let _ = self.addRandomBlock("star", PhysicsCategory.star.rawValue)
        }
        
        if self.didContact(contact, PhysicsCategory.caveman.rawValue, PhysicsCategory.dino.rawValue) {
            let dino = contact.bodyA.categoryBitMask == PhysicsCategory.dino.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            if let d = dino as? SKSpriteNode {
                switch(d) {
                case self.dino1:
                    let _ = self.player.decrementEnergy(60)
                    break
                case self.dino2:
                    let _ = self.player.decrementEnergy(80)
                    break
                case self.dino3:
                    let _ = self.player.decrementEnergy(100)
                    break
                default:
                    break
                }
            }
        }
        
        if self.didContact(contact, PhysicsCategory.food.rawValue, PhysicsCategory.caveman.rawValue) {
            self.player.incrementEnergy(50)
            
            let food = contact.bodyA.categoryBitMask == PhysicsCategory.star.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            let foodPosition = self.findBlockInInnerBlocksDictionary(node: food as! SKSpriteNode)
            
            self.innerBlocks.removeValue(forKey: foodPosition)
            
            self.removeChildren(in: [food!])
            
            self.addFood()
        }
        
        if self.didContact(contact, PhysicsCategory.food.rawValue, PhysicsCategory.dino.rawValue) {
            let food = contact.bodyA.categoryBitMask == PhysicsCategory.food.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            let foodPosition = self.findBlockInInnerBlocksDictionary(node: food as! SKSpriteNode)
            
            self.innerBlocks.removeValue(forKey: foodPosition)
            
            self.removeChildren(in: [food!])
            
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(GameScene.addFood), userInfo: nil, repeats: false)
        }
        
        if self.didContact(contact, PhysicsCategory.block.rawValue, PhysicsCategory.dino.rawValue) || self.didContact(contact, PhysicsCategory.water.rawValue, PhysicsCategory.dino.rawValue) {
            let dino = contact.bodyA.categoryBitMask == PhysicsCategory.dino.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            if (dino == self.dino3) {
                self.dino3.removeAllActions()
                
                self.moveDino3()
            }
        }
        
        print(contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask)
        
        if self.didContact(contact, PhysicsCategory.rock.rawValue, PhysicsCategory.dino.rawValue) {
            let dino = contact.bodyA.categoryBitMask == PhysicsCategory.dino.rawValue ? contact.bodyA.node : contact.bodyB.node
            
            let dinoPosition = self.findBlockInInnerBlocksDictionary(node: dino as! SKSpriteNode)
            
            self.innerBlocks.removeValue(forKey: dinoPosition)
            
            // Random time between 1 and 5
            let randomTime = TimeInterval(arc4random_uniform(4)) + 1
            
            if let d = dino as? SKSpriteNode {
                switch (d) {
                case self.dino1:
                    let _ = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(GameScene.addDino1), userInfo: nil, repeats: false)
                    break
                case self.dino2:
                    let _ = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(GameScene.addDino2), userInfo: nil, repeats: false)
                    break
                case self.dino3:
                    let _ = Timer.scheduledTimer(timeInterval: randomTime, target: self, selector: #selector(GameScene.addDino3), userInfo: nil, repeats: false)
                    break
                default:
                    break
                }
            }
            
            self.removeChildren(in: [dino!])
        }
    }
    
    func addFood() {
        let foodBlock = self.addRandomBlock("food", PhysicsCategory.food.rawValue)
        
        foodBlock.physicsBody = SKPhysicsBody(rectangleOf: foodBlock.size)
        foodBlock.physicsBody?.affectedByGravity =  false
        foodBlock.physicsBody?.categoryBitMask = PhysicsCategory.food.rawValue
        foodBlock.physicsBody?.contactTestBitMask = PhysicsCategory.dino.rawValue
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
    
    func throwRock(gesture: UIGestureRecognizer) {
        if let tapGesture = gesture as? UITapGestureRecognizer {
            if self.player.rocks > 0 {
                self.player.decrementRock()
                let block = SKSpriteNode(imageNamed: "rock")
                var touchLocation: CGPoint = tapGesture.location(in: self.view)
                touchLocation = self.convertPoint(fromView: touchLocation)
                
                let cm = self.caveman!
                
                self.createBlock(block: block, x: Int(cm.position.x + 1), y: Int(cm.position.y + 1), category: PhysicsCategory.rock.rawValue)
                
                block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                block.physicsBody?.affectedByGravity =  false
                block.physicsBody?.categoryBitMask = PhysicsCategory.rock.rawValue
                block.physicsBody?.contactTestBitMask = PhysicsCategory.dino.rawValue
                block.physicsBody?.collisionBitMask = 0
                
                let distance = sqrt(pow(cm.position.x - touchLocation.x, 2.0) + pow(cm.position.y - touchLocation.y, 2.0))
                
                let dx = Int(touchLocation.x - cm.position.x)
                let dy = Int(touchLocation.y - cm.position.y)
                
                var movement = SKAction.move(by: CGVector(dx: dx, dy: dy), duration: SPEED * Double(distance / 50))
                movement = SKAction.repeatForever(movement)
                block.run(movement)
            }
        }
    }
}
