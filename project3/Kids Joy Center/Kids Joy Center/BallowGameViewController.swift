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
    
    var speedRatio = 1.0
    
    var lastPairFound: Int64 = -1
    
    var scoreTimer: ScoreTimerViewController?
    
    var balloons = [UIImageView]()
    
    var pointRangeMax = 0
    
    var timer: Timer?
    var bonusTimer: Timer?
    var killerTimer: Timer?
    
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
        
        self.speedRatio = self.difficulty == 0 ? 1.0 : self.difficulty == 1 ? 0.8 : 0.6 // ugly: {1.0, 0.8, 0.6}
        
        self.pointRangeMax = self.difficulty == 0 ? 9 : self.difficulty == 1 ? 7 : 5 // ugly: {9, 7, 5}
        
        startBalloonTimer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadBalloon() {
        var selectedLocations = [Int]()
        
        print(Int(arc4random() % UInt32(difficulty + 1)))
        
        for _ in 0...Int(arc4random() % UInt32(difficulty + 1)) {
            var location = -1
            repeat {
                location = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [Int]((0...9)))[0] as! Int
            } while (selectedLocations.contains(location))
            selectedLocations.append(location)
            
            let balloon = UIImageView(frame: CGRect(x: 12 + (100 * location), y: 800, width: 100, height: 100));
            balloon.image = self.balloonImages[Int(arc4random() % 10)]
            let number = UIImageView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
            number.image = numberImages[Int(arc4random() % UInt32(self.pointRangeMax + 1))]
            balloon.addSubview(number)
            balloon.isUserInteractionEnabled = true
            self.balloons.append(balloon)
            self.view.addSubview(balloon)
            
            UIView.animate(withDuration: 8 * speedRatio, delay: 0, options: .allowUserInteraction, animations:
                {
                    balloon.frame = CGRect(x: 12 + (100 * location), y: -100, width: 99, height: 99)
            }) {_ in
                balloon.removeFromSuperview()
                
                self.balloons.remove(at: self.balloons.index(of: balloon)!)
            }
        }
    }
    
    func loadBonusBalloon() {
        let location = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [Int]((0...9)))[0] as! Int
        
        let balloon = UIImageView(frame: CGRect(x: 12 + (100 * location), y: 800, width: 100, height: 100));
        balloon.image = self.balloonImages[Int(arc4random() % 10)]
        let number = UIImageView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        number.image = #imageLiteral(resourceName: "star")
        balloon.addSubview(number)
        balloon.isUserInteractionEnabled = true
        self.balloons.append(balloon)
        self.view.addSubview(balloon)
        
        UIView.animate(withDuration: 4 * speedRatio, delay: 0, options: .allowUserInteraction, animations:
            {
                balloon.frame = CGRect(x: 12 + (100 * location), y: -100, width: 99, height: 99)
        }) {_ in
            balloon.removeFromSuperview()
            
            self.balloons.remove(at: self.balloons.index(of: balloon)!)
        }
    }
    
    func loadKillerBalloon() {
        let location = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: [Int]((0...9)))[0] as! Int
        
        let balloon = UIImageView(frame: CGRect(x: 12 + (100 * location), y: 800, width: 100, height: 100));
        balloon.image = self.balloonImages[Int(arc4random() % 10)]
        let number = UIImageView(frame: CGRect(x: 25, y: 25, width: 50, height: 50))
        number.image = #imageLiteral(resourceName: "skull")
        balloon.addSubview(number)
        balloon.isUserInteractionEnabled = true
        self.balloons.append(balloon)
        self.view.addSubview(balloon)
        
        UIView.animate(withDuration: 10 * speedRatio, delay: 0, options: .allowUserInteraction, animations:
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
                    
                    if image == #imageLiteral(resourceName: "skull") {
                        loserAlert();
                    } else if image == #imageLiteral(resourceName: "star") {
                        self.speedRatio *= 2.0
                        // only for 5 seconds
                        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(BallowGameViewController.decreaseSpeed), userInfo: nil, repeats: false)
                    } else {
                        let score = numberImages.index(of: image!)
                        
                        self.scoreTimer?.incrementScore(score!)
                    }
                    
                    // hide balloon
                    v.image = nil
                }
            }
        }
    }
    
    func decreaseSpeed() {
        self.speedRatio /= 2.0
    }
    
    func stopBalloonTimer() {
        self.timer?.invalidate()
        self.bonusTimer?.invalidate()
        self.killerTimer?.invalidate()
    }
    
    func startBalloonTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(BallowGameViewController.loadBalloon), userInfo: nil, repeats: true)
        self.bonusTimer = Timer.scheduledTimer(timeInterval: 5.0 + Double(arc4random() % 20), target: self, selector: #selector(BallowGameViewController.loadBonusBalloon), userInfo: nil, repeats: true)
        self.killerTimer = Timer.scheduledTimer(timeInterval: 5.0 + Double(arc4random() % 20), target: self, selector: #selector(BallowGameViewController.loadKillerBalloon), userInfo: nil, repeats: true)
    }
    
    func reset() {
        for v in self.balloons {
            v.removeFromSuperview()
        }
        
        stopBalloonTimer()
        startBalloonTimer()
        self.scoreTimer?.score = 0
        self.scoreTimer?.seconds = self.difficulty == 0 ? 60 : self.difficulty == 1 ? 45 : 30 // ugly: {60, 45, 30}
        self.scoreTimer?.start()
    }
    
    func loserAlert() {
        self.scoreTimer?.stopTimer()
        
        self.stopBalloonTimer()
        
        let alert = UIAlertController(title: "Game Over", message: "Play again?", preferredStyle: .alert)
        
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
