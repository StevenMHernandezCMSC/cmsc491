//
//  Student.swift
//  GPACalculator
//
//  Created by Steven Hernandez on 2/9/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import Foundation

class Student {
    var courses = [Course]()
    
    func addCourse(_ course: Course) -> Bool {
        if courses.count >= 4 {
            return false
        }

        courses.append(course)
        
        return true
    }
    
    func removeCourse(_ index: Int) -> Bool {
        // TODO
        return false
    }
    
    func getGPA() -> Double {
        return 0
    }
    
    func getGPAColor() -> String {
        // TODO: handle color correctly
        if self.getGPA() > 3.0 {
            return "green"
        } else if self.getGPA() > 2.0 {
            return "orange"
        } else {
            return "red"
        }
    }
}
