//
//  HighscoreManager.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/25/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

enum Game {
    case memory
    case sorting
    case balloon
}

class HighscoreManager {
    var highscores = [Game: [Highscore]]()
    
    init() {
        self.loadAll()
    }
    
    func addHighScore(score: Int, game: Game, difficulty: Int) {
        var s = Highscore(difficulty: difficulty, score: score)
        for i in 0...4 {
            if (i + 1) > (highscores[game]?.count)! {
                highscores[game]?.append(s)
                break;
            } else if s.score > (highscores[game]?[i])!.score {
                let t = s
                s = (highscores[game]?[i])!
                highscores[game]?[i] = t
            }
        }
        
        self.storeAll()
    }
    
    func loadAll() {
        highscores[Game.memory] = self.load(key: "highscores_memory")
        highscores[Game.sorting] = self.load(key: "highscores_sorting")
        highscores[Game.balloon] = self.load(key: "highscores_balloon")
    }
    
    func load(key: String) -> [Highscore] {
        if let a = UserDefaults.standard.object(forKey: key) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: a) as! [Highscore]
        } else {
            return [Highscore]()
        }
    }
    
    func storeAll() {
        self.store(scores: highscores[Game.memory]!, key: "highscores_memory")
        self.store(scores: highscores[Game.sorting]!, key: "highscores_sorting")
        self.store(scores: highscores[Game.balloon]!, key: "highscores_balloon")
    }
    
    func store(scores: [Highscore], key: String) {
        let a = NSKeyedArchiver.archivedData(withRootObject: scores)
        UserDefaults.standard.set(a, forKey: key)
        UserDefaults.standard.synchronize()
    }
}
