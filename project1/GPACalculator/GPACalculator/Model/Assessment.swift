//
//  Assessment.swift
//  GPACalculator
//
//  Created by Steven Hernandez on 2/9/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Assessment {
    var point: Int;
    var max: Int;
    var percentage: Int;
    
    init(_ point: Int, _ max: Int, _ percentage: Int) {
        self.point = point
        self.max = max
        self.percentage = percentage
    }
    
    func validate() -> String? {
        if self.point < 0 {
            return "You can't earn negative points."
        }
        
        if self.point > self.max {
            return "You can't earn more than the max points."
        }
        
        if self.max == 0, self.percentage != 0 {
            return "Max can't be 0, otherwise we would divide by zero"
        }
        
        return nil
    }
    
    func getWeight() -> Double {
        if (self.percentage == 0) {
            return 0;
        }

        return (Double(self.point) / Double(self.max)) * Double(self.percentage)
    }
}
