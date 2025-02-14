//
//  Course.swift
//  GPACalculator
//
//  Created by Steven Hernandez on 2/7/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Course {
    var name: String;
    var credits: Int;
    var assignments: Assessment;
    var midterm: Assessment;
    var final: Assessment;

    init(_ name: String, credits: Int, assignments: Assessment, midterm: Assessment, final: Assessment) {
        self.name = name;
        self.credits = credits;
        self.assignments = assignments;
        self.midterm = midterm;
        self.final = final;
    }
    
    func validate() -> String? {
        if self.assignments.percentage + self.midterm.percentage + self.final.percentage != 100 {
            return "Percentages do not add up to 100."
        }
        
        if let e = self.assignments.validate() {
            return e
        }
        
        if let e = self.midterm.validate() {
            return e
        }
        
        if let e = self.final.validate() {
            return e
        }
        
        return nil
    }
    
    func getPercentageGrade() -> Double {
        return self.assignments.getWeight() + self.midterm.getWeight() + self.final.getWeight()
    }
    
    func getGradePoints() -> Int {
        return self.credits * self.getGradeValue()
    }
    
    func getGradeValue() -> Int {
        let percentage = self.getPercentageGrade()
        
        if percentage >= 90 {
            return 4
        } else if percentage >= 80 {
            return 3
        } else if percentage >= 70 {
            return 2
        } else if percentage >= 60 {
            return 1
        } else {
            return 0
        }
    }
    
    func getLetterGrade() -> Character {
        return ["F", "D", "C", "B", "A"][self.getGradeValue()]
    }
}
