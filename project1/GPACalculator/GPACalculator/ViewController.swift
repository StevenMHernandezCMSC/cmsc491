//
//  ViewController.swift
//  GPACalculator
//
//  Created by Steven Hernandez on 2/7/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var courseTitleTextField: UITextField!
    @IBOutlet weak var assignmentPointTextField: UITextField!
    @IBOutlet weak var assignmentMaxTextField: UITextField!
    @IBOutlet weak var assignmentPercentageTextField: UITextField!
    @IBOutlet weak var midtermPointTextField: UITextField!
    @IBOutlet weak var midtermMaxTextField: UITextField!
    @IBOutlet weak var midtermPercentageTextField: UITextField!
    @IBOutlet weak var finalPointTextField: UITextField!
    @IBOutlet weak var finalMaxTextField: UITextField!
    @IBOutlet weak var finalPercentageTextField: UITextField!
    @IBOutlet weak var creditsTextField: UITextField!
    
    @IBOutlet weak var course1TextField: UILabel!
    @IBOutlet weak var course2TextField: UILabel!
    @IBOutlet weak var course3TextField: UILabel!
    @IBOutlet weak var course4TextField: UILabel!
    @IBOutlet weak var gpaTextField: UILabel!
    
    @IBOutlet weak var deleteCourseButton: UIButton!
    @IBOutlet weak var deleteCourseIdTextField: UITextField!
    
    var courseTextFields = [UILabel?]()

    var student = Student()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        courseTextFields.append(course1TextField)
        courseTextFields.append(course2TextField)
        courseTextFields.append(course3TextField)
        courseTextFields.append(course4TextField)
        
        // We start with text here so that the text areas are visible when we are building the layout
        // Just to ease initial development
        self.renderChalkboard()

        deleteCourseButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addCourse(_ sender: Any) {
        if  let title = self.courseTitleTextField!.text,
            let assignmentPoint = Int(self.assignmentPointTextField!.text!),
            let assignmentMax = Int(self.assignmentMaxTextField!.text!),
            let assignmentPercent = Int(self.assignmentPercentageTextField!.text!),
            let midtermPoint = Int(self.midtermPointTextField!.text!),
            let midtermMax = Int(self.midtermMaxTextField!.text!),
            let midtermPercent = Int(self.midtermPercentageTextField!.text!),
            let finalPoint = Int(self.finalPointTextField!.text!),
            let finalMax = Int(self.finalMaxTextField!.text!),
            let finalPercent = Int(self.finalPercentageTextField!.text!),
            let credits = Int(self.creditsTextField!.text!)
        {
            let assignments = Assessment(assignmentPoint, assignmentMax, assignmentPercent)
            let midterm = Assessment(midtermPoint, midtermMax, midtermPercent)
            let final = Assessment(finalPoint, finalMax, finalPercent)
            let course = Course(title, credits: credits, assignments: assignments, midterm: midterm, final: final)
            
            if let err = course.validate() {
                self.errorAlert(err)
            } else {
                if (self.student.courses.contains(where: {$0.name == course.name})) {
                    self.errorAlert("\(course.name) has already been added.")
                } else {
                    if !self.student.addCourse(course) {
                        self.errorAlert("A maximum of 4 classes can be added.")
                    } else {
                        print(course.getPercentageGrade())
                    }
                }
            }
        } else {
            self.errorAlert("Please fill in all fields.")
        }
        
        self.renderChalkboard();
        
        if student.courses.count > 0 {
            deleteCourseButton.isEnabled = true
        }
    }
    
    @IBAction func deleteCourse(_ sender: Any) {
        if let index = Int(self.deleteCourseIdTextField!.text!) {
            if self.student.removeCourse(index) {
                self.renderChalkboard();
            } else {
                self.errorAlert("Course \(index) doesn't exist")
            }
        } else {
            self.errorAlert("Please input a course number.")
        }
        
        if student.courses.count == 0 {
            deleteCourseButton.isEnabled = false
        }
    }
    
    func renderChalkboard() {
        for (index, textField) in self.courseTextFields.enumerated() {
            if let field = textField {
                if self.student.courses.count > index {
                    let course = self.student.courses[index]
                    field.text = "\(index + 1). \(course.name)"
                } else {
                    field.text = ""
                }
            }
        }
        
        if let gpa = self.student.getGPA() {
            gpaTextField.text = "GPA: \(gpa)"
        } else {
            gpaTextField.text = "GPA:"
        }
        
        gpaTextField.textColor = self.getGPAColor()
    }
    
    func getGPAColor() -> UIColor {
        if let gpa = self.student.getGPA() {
            if gpa > 3.0 {
                return UIColor(red:0.15, green:0.68, blue:0.38, alpha:1.0)
            } else if gpa > 2.0 {
                return UIColor(red:0.90, green:0.49, blue:0.13, alpha:1.0)
            } else {
                return UIColor(red:0.91, green:0.30, blue:0.24, alpha:1.0)
            }
        } else {
            return UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0)
        }
    }
    
    func errorAlert(_ message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        errorAlert.addAction(action)
        
        present(errorAlert, animated: true, completion: nil)
    }
}

