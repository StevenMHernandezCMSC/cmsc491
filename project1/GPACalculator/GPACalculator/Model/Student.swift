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
        if self.courses.count > index - 1, index > 0 {
            self.courses.remove(at: index - 1)

            return true
        }

        return false;
    }
    
    func getGPA() -> Double? {
        if self.courses.count == 0 {
            return nil
        }

        var gradePoints = 0;
        var hoursAttempted = 0;
        
        for course in self.courses {
            gradePoints += course.getGradePoints()
            hoursAttempted += course.credits
        }
        
        return Double(gradePoints) / Double(hoursAttempted)
    }
}
