//
//  ScoreTimerViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/23/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

var height = 45
var width = 30
let numberImages = [UIImage](arrayLiteral: #imageLiteral(resourceName: "cartoon-number-0"), #imageLiteral(resourceName: "cartoon-number-1"), #imageLiteral(resourceName: "cartoon-number-2"), #imageLiteral(resourceName: "cartoon-number-3"), #imageLiteral(resourceName: "cartoon-number-4"), #imageLiteral(resourceName: "cartoon-number-5"), #imageLiteral(resourceName: "cartoon-number-6"), #imageLiteral(resourceName: "cartoon-number-7"), #imageLiteral(resourceName: "cartoon-number-8"), #imageLiteral(resourceName: "cartoon-number-9"))

class ScoreTimerViewController: UIViewController {
    
    var timerFinishedCallback: (() -> ())?
    
    var score = 0
    var seconds = 3
    
    var timeLogo = UIImageView(frame: CGRect(x: 10, y: 0, width: 180, height: height));
    var minutes = UIImageView(frame: CGRect(x: 200, y: 0, width: width, height: height));
    var secondsTens = UIImageView(frame: CGRect(x: 200 + 15 + width, y: 0, width: width, height: height));
    var secondsOnes = UIImageView(frame: CGRect(x: 200 + 15 + width*2, y: 0, width: width, height: height));
    
    var scoreLogo = UIImageView(frame: CGRect(x: 1000 - width*3 - 200, y: 0, width: 200, height: height));
    var scoreHundreds = UIImageView(frame: CGRect(x: 1000 - width*3, y: 0, width: width, height: height));
    var scoreTens = UIImageView(frame: CGRect(x: 1000 - width*2, y: 0, width: width, height: height));
    var scoreOnes = UIImageView(frame: CGRect(x: 1000 - width, y: 0, width: width, height: height));
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeLogo.image = #imageLiteral(resourceName: "time")
        self.scoreLogo.image = #imageLiteral(resourceName: "score")
        
        self.view.addSubview(self.timeLogo)
        self.view.addSubview(self.minutes)
        self.view.addSubview(self.secondsTens)
        self.view.addSubview(self.secondsOnes)
        self.view.addSubview(self.scoreLogo)
        self.view.addSubview(self.scoreHundreds)
        self.view.addSubview(self.scoreTens)
        self.view.addSubview(self.scoreOnes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.start()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.timer?.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func incrementScore(_ x: Int) {
        self.score += x
        self.renderScore()
    }
    
    func decrementScore(_ x: Int) {
        self.score -= x
        self.renderScore()
    }
    
    func renderTimer() {
        self.minutes.image = numberImages[self.seconds / 60];
        self.secondsTens.image = numberImages[(self.seconds % 60) / 10];
        self.secondsOnes.image = numberImages[(self.seconds % 60) % 10];
    }
    
    func renderScore() {
        self.scoreOnes.image = numberImages[(self.score % 10) % 10];
        if score >= 10 {
            self.scoreTens.image = numberImages[(self.score / 10) % 10];
            if score >= 100 {
                self.scoreHundreds.image = numberImages[self.score / 100 % 10];
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ScoreTimerViewController.everySecond), userInfo: nil, repeats: true)
        
        self.renderTimer()
        self.renderScore()
    }
    
    func everySecond() {
        self.seconds -= 1
        if self.seconds <= 0 {
            self.seconds = 0
            self.timer?.invalidate()
            if let cb = self.timerFinishedCallback {
                cb()
            }
        }
        self.renderTimer()
    }
}
