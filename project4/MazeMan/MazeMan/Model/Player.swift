//
//  Player.swift
//  MazeMan
//
//  Created by Steven Hernandez on 4/8/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Player {
    var energy = 300
    var rocks = 10
    var stars = 0
    
    var energyTimer: Timer?
    var rockTimer: Timer?
    
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
    public var deathCallback: (() -> ())?
    
    init() {
        self.startTimers()
    }
    
    func reset() {
        self.energy = 300
        self.rocks = 10
        self.stars = 0
        self.startTimers()
    }
    
    func stop() {
        self.endTimers()
    }
    
    /**
     * Decrement Player's Energy
     *
     * Returns whether the player died.
     */
    func decrementEnergy(_ value: Int) -> Bool {
        if self.energy - value > 0 {
            self.energy -= value
        
            self.rerenderCallback!()
        
            return true
        } else {
            self.energy = 0
            
            self.rerenderCallback!()
            
            self.deathCallback!()
            
            return false
        }
    }
    
    func incrementEnergy(_ value: Int) {
        if self.energy + value >= 300 {
            self.energy = 300
        } else {
            self.energy += value
        }
        
        self.rerenderCallback!()
    }
    
    func incrementStar(_ value: Int) {
        self.stars += value
        
        self.rerenderCallback!()
    }
    
    func decrementRock() {
        self.rocks -= 1
        
        self.rerenderCallback!()
    }
    
    func startTimers() {
        self.energyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Player.loseEnergyEverySecond), userInfo: nil, repeats: true)
        self.rockTimer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(Player.increaseRockCount), userInfo: nil, repeats: true)
    }
    
    func endTimers() {
        self.energyTimer?.invalidate()
        self.rockTimer?.invalidate()
    }
    
    @objc func loseEnergyEverySecond() {
        let _ = self.decrementEnergy(1)
    }
    
    @objc func increaseRockCount() {
        self.rocks = self.rocks + 5 >= 20 ? 20 : self.rocks + 5
        
        self.rerenderCallback!()
    }
}
