//
//  SortingGameViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/24/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class SortingGameViewController: UIViewController {
    
    var difficulty = -1
    
    var lastPairFound: Int64 = -1
    
    var imageCount = -1
    var width = -1
    var correctImageCount = 0
    
    var scoreTimer: ScoreTimerViewController?
    
    var itemViews = [UIImageView]()
    var itemImages = [UIImage]()
    
    var landVehicleImages = [UIImage]()
    var seaVehicleImages = [UIImage]()
    var airVehicleImages = [UIImage](arrayLiteral: #imageLiteral(resourceName: "balloon-game-logo2"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.title = "Sorting the Vehicles"
        
        /*
         * add background
         */
        let backgroundImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768));
        backgroundImage.image = #imageLiteral(resourceName: "air-land-water")
        self.view.addSubview(backgroundImage)
        
        /*
         * add score and timer
         */
        scoreTimer = ScoreTimerViewController()
        scoreTimer?.view.frame = CGRect(x: 0, y: 700, width: 1024, height: 45)
        scoreTimer?.seconds = self.difficulty == 0 ? 60 : self.difficulty == 1 ? 45 : 30 // ugly: {60, 45, 30}
        scoreTimer?.timerFinishedCallback = loserAlert
        self.view.addSubview((scoreTimer?.view)!)
        scoreTimer?.start()
        
        self.imageCount = self.difficulty == 0 ? 8 : self.difficulty == 1 ? 10 : 12 // ugly: {8, 10, 12}
        self.width = (1000 / self.imageCount) - 20;

        let a = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: width + 100));
        a.backgroundColor = UIColor.gray
        a.alpha = 0.5
        self.view.addSubview(a)
        
        /*
         * add image views for each vehicle
         */
        for x in 0...(self.imageCount - 1) {
            let button = UIImageView(frame: self.getLocationInTopBar(i: x));
            button.image = #imageLiteral(resourceName: "balloon-game-logo2")
            
            self.makeViewTappable(v: button, action: #selector(self.drag(_:)))
            self.itemViews.append(button)
            self.view.addSubview(button)
        }
    }
    
    func makeViewTappable(v: UIImageView, action: Selector?)
    {
        v.backgroundColor = UIColor.gray
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 5.0
        let tap = UIPanGestureRecognizer(target: self, action: action)
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(tap)
    }
    
    var offsetX: CGFloat = 0.0;
    var offsetY: CGFloat = 0.0;
    
    func drag(_ sender: UIPanGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.began) {
            offsetX = (sender.view?.center.x)! - sender.location(in: self.view).x
            offsetY = (sender.view?.center.y)! - sender.location(in: self.view).y
        }
        
        let x = sender.location(in: self.view).x + offsetX
        let y = sender.location(in: self.view).y + offsetY
        
        sender.view?.center = CGPoint(x: x, y: y)

        if (sender.state == UIGestureRecognizerState.ended) {
            let location = self.getLocation((sender.view?.center)!)
            let imageView = sender.view as! UIImageView
            
            switch location {
            case 0:
                if !self.airVehicleImages.contains(imageView.image!) {
                    returnToStartPosition(view: sender.view! as! UIImageView)
                    return
                }
                break;
            case 1:
                if !self.seaVehicleImages.contains(imageView.image!) {
                    returnToStartPosition(view: sender.view! as! UIImageView)
                    return
                }
                break;
            case 2:
                if !self.landVehicleImages.contains(imageView.image!) {
                    returnToStartPosition(view: sender.view! as! UIImageView)
                    return
                }
                break;
            default:
                returnToStartPosition(view: sender.view! as! UIImageView)
                return;
            }
            
            imageView.isUserInteractionEnabled = false
            
            self.correctImageCount += 1

            // determine score
            let date = NSDate()
            let time = Int64(date.timeIntervalSince1970)
            if time - self.lastPairFound <= 2 {
                self.scoreTimer?.incrementScore(5)
            } else if time - self.lastPairFound <= 4 {
                self.scoreTimer?.incrementScore(4)
            } else {
                self.scoreTimer?.incrementScore(3)
            }
            self.lastPairFound = Int64(date.timeIntervalSince1970)
            
            if self.correctImageCount == self.imageCount {
                self.scoreTimer?.stopTimer()
                self.winnerAlert()
            }
        }
    }
    
    func reset() {
        // TODO: shuffle images

        for (i,view) in self.itemViews.enumerated() {
            view.isUserInteractionEnabled = true
            view.frame = getLocationInTopBar(i: i)
        }

        correctImageCount = 0
        
        self.scoreTimer?.seconds = self.difficulty == 0 ? 60 : self.difficulty == 1 ? 45 : 30 // ugly: {60, 45, 30}
        self.scoreTimer?.score = 0
        self.scoreTimer?.start()
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
    
    func returnToStartPosition(view: UIImageView) {
        let newFrame = self.getLocationInTopBar(i: self.itemViews.index(of: view)!)
        
        let distance = sqrt(pow(newFrame.origin.x - view.center.x, 2.0) + pow(newFrame.origin.y - view.center.y, 2.0))
        
        UIView.animate(withDuration: 0.004 * Double(distance)) {
            view.frame = newFrame
        }
    }
    
    func getLocationInTopBar(i: Int) -> CGRect {
        return CGRect(x: (20 * (i + 1)) + (width * i), y: 80, width: width, height: width)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * return the Int index in -> (sky,water,land)
     *
     *        Images
     *---------(width[of images] + 100)---------
     *
     *          Sky
     * _______(y:433)_______
     *             |
     *    Water    | (x: 720)
     * _______(y:615)_______
     *         |
     *  Water  |(x:500)
     */
    func getLocation(_ point: CGPoint) -> Int {
        let x = point.x
        let y = point.y
        
        print(x,y)
        
        if y < CGFloat(width) + 100 {
            return -1
        }
        if y < 433 {
            return 0;
        }
        if (y < 615 && x < 720) || (x < 500) {
            return 1;
        }
        return 2
    }
}
