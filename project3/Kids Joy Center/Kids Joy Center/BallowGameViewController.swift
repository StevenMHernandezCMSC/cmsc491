//
//  BallowGameViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/24/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class BallowGameViewController: UIViewController {
    
    var difficulty = -1
    
    var lastPairFound: Int64 = -1
    
    var scoreTimer: ScoreTimerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = "Pop the Balloons"
        
        /*
         * add score and timer
         */
        scoreTimer = ScoreTimerViewController()
        scoreTimer?.view.frame = CGRect(x: 0, y: 100, width: 1024, height: 45)
        self.scoreTimer?.seconds = self.difficulty == 0 ? 60 : self.difficulty == 1 ? 45 : 30 // ugly: {60, 45, 30}
        scoreTimer?.timerFinishedCallback = loserAlert
        self.view.addSubview((scoreTimer?.view)!)
        
        scoreTimer?.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func reset() {
        
    }
    
    func loserAlert() {
        let alert = UIAlertController(title: "You lose", message: "Play again?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: {
            (action) in
            self.reset()
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: {
            (action) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    func winnerAlert() {
        let alert = UIAlertController(title: "You win", message: "Play again?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: {
            (action) in
            self.reset()
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: {
            (action) in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
}
