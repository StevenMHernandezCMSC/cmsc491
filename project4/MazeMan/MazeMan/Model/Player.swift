//
//  Player.swift
//  MazeMan
//
//  Created by Steven Hernandez on 4/8/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Player {
    var lives = 3
    var energy = 100
    var rocks = 10
    var stars = 0
    
    var energyTimer: Timer?
    
    /**
     * Called whenever GUI should be rerendered with new player data.
     * For example, when energy is lost.
     */
    public var rerenderCallback: (() -> Void)?
    
    /**
     * Called after player loses all life.
     *
     * Passes remaining lives after death as a parameter.
     * If player has 3 lives, then loses all energy, passes in `2`.
     */
    public var deathCallback: ((Int) -> Void)?
    
    init() {
        self.startEnergyTimer()
    }
    
    /**
     * Passes remaining lives after death as a parameter.
     * If player has 3 lives, then loses all energy, passes in `2`.
     */
    func loseLife() -> Int {
        self.lives -= 1
        self.energy = 100
        
        self.energyTimer?.invalidate()
        
        if (self.lives >= 0) {
            self.startEnergyTimer()
        }
        
        return self.lives
    }
    
    /**
     * Decrement Player's Energy
     *
     * Returns whether the player died.
     */
    func decrementEnergy(_ value: Int) -> Bool {
        self.energy -= value
        
        self.rerenderCallback!()
        
        if self.energy > 0 {
            return true
        } else {
            self.deathCallback!(self.loseLife())
            return false
        }
    }
    
    func incrementStar(_ value: Int) {
        self.stars += value
        
        self.rerenderCallback!()
    }
    
    func startEnergyTimer() {
        self.energyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Player.loseEnergyEverySecond), userInfo: nil, repeats: true)
    }
    
    @objc func loseEnergyEverySecond() {
        let _ = self.decrementEnergy(1)
    }
}
