//
//  GameOverScene.swift
//  MazeMan
//
//  Created by Steven Hernandez on 4/15/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOverScene: SKScene {
    
    var gameScene: SKScene?
    
    var player: Player?
    
    private var currentScoreLabel = SKLabelNode(fontNamed: "Helvetica")
    private var highscoresLabel = SKLabelNode(fontNamed: "Arial")
    private var beginGameLabel = SKLabelNode(fontNamed: "Arial")
    
    
    override func didMove(to view: SKView) {
        self.addHighScore()
        
        self.currentScoreLabel.text = "Current Score is \(self.player!.stars)"
        self.currentScoreLabel.position.x = CGFloat(WIDTH / 2)
        self.currentScoreLabel.position.y = CGFloat(HEIGHT / 2) + 200
        self.addChild(self.currentScoreLabel)
        
        self.highscoresLabel.text = "Highscores \(highscores[0]), \(highscores[1]), \(highscores[2])"
        self.highscoresLabel.position.x = CGFloat(WIDTH / 2)
        self.highscoresLabel.position.y = CGFloat(HEIGHT / 2)
        self.addChild(self.highscoresLabel)
        
        self.beginGameLabel.text = "Begin new Game"
        self.beginGameLabel.position.x = CGFloat(WIDTH / 2)
        self.beginGameLabel.position.y = CGFloat(HEIGHT / 2) - 200
        self.addChild(self.beginGameLabel)
    }
    
    func addHighScore() {
        var score = self.player!.stars
        
        print(score)
        
        for i in 0...2 {
            if score > highscores[i] {
                let t = score
                score = highscores[i]
                highscores[i] = t
            }
        }
        
        print(highscores)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view?.presentScene(self.gameScene!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
}
