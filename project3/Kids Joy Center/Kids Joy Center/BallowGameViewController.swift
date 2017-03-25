//
//  BallowGameViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/24/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit
import GameplayKit

class BallowGameViewController: UIViewController {
    
    let balloonImages = [UIImage](arrayLiteral: #imageLiteral(resourceName: "color1"),#imageLiteral(resourceName: "color2"),#imageLiteral(resourceName: "color3"),#imageLiteral(resourceName: "color4"),#imageLiteral(resourceName: "color5"),#imageLiteral(resourceName: "color6"),#imageLiteral(resourceName: "color7"),#imageLiteral(resourceName: "color8"),#imageLiteral(resourceName: "color9"),#imageLiteral(resourceName: "color10"))
    
    var difficulty = -1
    
    var lastPairFound: Int64 = -1
    
    var scoreTimer: ScoreTimerViewController?
    
    var balloons = [UIImageView]()
    
    var timer: Timer?
    
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
        
        startBalloonTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadBalloon() {
        let location = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [Int]((0...9)))[0] as! Int
        
        let balloon = UIImageView(frame: CGRect(x: 12 + (100 * location), y: 800, width: 100, height: 100));
        balloon.image = self.balloonImages[Int(arc4random() % 10)]
        let number = UIImageView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        number.image = numberImages[Int(arc4random() % 10)]
        balloon.addSubview(number)
        balloon.isUserInteractionEnabled = true
        self.balloons.append(balloon)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.pop(_:)))
        balloon.addGestureRecognizer(tap)
        self.view.addSubview(balloon)
        
        
        UIView.animate(withDuration: 8, delay: 0, options: .allowUserInteraction, animations:
            {
                balloon.frame = CGRect(x: 12 + (100 * location), y: -100, width: 99, height: 99)
        }) {_ in
            balloon.removeFromSuperview()
            
            self.balloons.remove(at: self.balloons.index(of: balloon)!)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self.view)
        
        for v in self.balloons {
            if v.layer.presentation()!.hitTest(touchLocation) != nil {
                if (v.image != nil) {
                    let image = (v.subviews[0] as! UIImageView).image
                    let score = numberImages.index(of: image!)
                    
                    self.scoreTimer?.incrementScore(score!)
                    
                    // hide balloon
                    v.image = nil
                }
            }
        }
        
        /*for i in 2...self.view.subviews.count {
         if self.view.subviews[i-1].layer.presentation()!.hitTest(touchLocation) != nil {
         print("touched subview \(i)")
         self.view.subviews[i-1].backgroundColor = UIColor.black
         }
         }*/
    }
    
    func pop(_ sender: UITapGestureRecognizer) {
        print("got em!", sender)
    }
    
    func stopBalloonTimer() {
        self.timer?.invalidate()
    }
    
    func startBalloonTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BallowGameViewController.loadBalloon), userInfo: nil, repeats: true)
    }
    
    func reset() {
        stopBalloonTimer()
        startBalloonTimer()
        self.scoreTimer?.score = 0
        self.scoreTimer?.seconds = self.difficulty == 0 ? 60 : self.difficulty == 1 ? 45 : 30 // ugly: {60, 45, 30}
        self.scoreTimer?.start()
    }
    
    func loserAlert() {
        self.stopBalloonTimer()
        
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
