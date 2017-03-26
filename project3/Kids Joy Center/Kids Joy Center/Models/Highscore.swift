//
//  Highscore.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/25/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Highscore: NSObject, NSCoding {
    var score: Int = -1
    var difficulty: Int = -1
    
    required init?(coder aDecoder: NSCoder) {
        self.score = Int(aDecoder.decodeInt32(forKey: "score"))
        self.difficulty = Int(aDecoder.decodeInt32(forKey: "difficulty"))
    }
    
    init(difficulty: Int, score: Int) {
        self.difficulty = difficulty
        self.score = score
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.score, forKey: "score")
        aCoder.encode(self.difficulty, forKey: "difficulty")
    }
    
    func difficultyString() -> String {
        switch (self.difficulty) {
        case 0:
            return "Easy"
        case 1:
            return "Medium"
        case 2:
            return "Hard"
        default:
            return "???"
        }
    }
}
