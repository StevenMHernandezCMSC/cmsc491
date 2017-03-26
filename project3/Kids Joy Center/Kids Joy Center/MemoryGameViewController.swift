//
//  MemoryGameViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/22/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit
import GameplayKit
import AVFoundation

class MemoryGameViewController: UIViewController {
    var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768));
    
    var soundPlayer = AVAudioPlayer()
    let audioPath = Bundle.main.path(forResource: "cheer", ofType: "mp3")
    
    var difficulty = -1
    
    var lastPairFound: Int64 = -1
    
    var blockHeight = 100
    var blockPadding = 10
    
    var itemViews = [UIImageView]()
    var itemImages = [UIImage]()
    
    var selectedItem: Int?
    var interactionEnabled = true;
    
    let allImages = [UIImage](arrayLiteral: #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "cat"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "gator"), #imageLiteral(resourceName: "giraffe"), #imageLiteral(resourceName: "horse"), #imageLiteral(resourceName: "lion"), #imageLiteral(resourceName: "monkey"), #imageLiteral(resourceName: "rooster"), #imageLiteral(resourceName: "zebra"));
    
    var scoreTimer: ScoreTimerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Memory Game"
        
        self.view.backgroundColor = UIColor.white
        
        self.bgImage.image = #imageLiteral(resourceName: "background")
        self.bgImage.alpha = 0.3
        self.view.addSubview(bgImage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
         * reset
         */
        itemViews = [UIImageView]()
        itemImages = [UIImage]()
        interactionEnabled = true
        
        /*
         * add score and timer
         */
        scoreTimer = ScoreTimerViewController()
        scoreTimer?.view.frame = CGRect(x: 0, y: 100, width: 1024, height: 45)
        scoreTimer?.seconds = self.difficulty == 0 ? 120 : self.difficulty == 1 ? 105 : 90 // ugly: {120, 105, 90}
        scoreTimer?.timerFinishedCallback = timeUp
        self.view.addSubview((scoreTimer?.view)!)
        
        let horizontalCount = self.difficulty == 0 ? 3 : self.difficulty == 1 ? 4 : 5 // ugly: {3,4,5}
        
        /*
         * determine the random set of images.
         */
        for n in 0...((horizontalCount * 2) - 1)  {
            // Add two of the item
            self.itemImages.append(self.allImages[n])
            self.itemImages.append(self.allImages[n])
        }
        
        /*
         * randomise the set
         */
        self.itemImages = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.itemImages) as! [UIImage]
        
        /*
         * build the image views
         */
        let topPadding = (768 - (4 * blockHeight) - (3 * blockPadding)) / 2
        let leftPadding = (1024 - (horizontalCount * blockHeight) - ((horizontalCount - 1) * blockPadding)) / 2
        
        /*
         * Add all the image views
         */
        for y in 0...3 {
            for x in 0...(horizontalCount - 1) {
                let button = UIImageView(frame: CGRect(x: leftPadding + ((blockHeight + blockPadding) * x),
                                                       y: topPadding + ((blockHeight + blockPadding) * y),
                                                       width: blockHeight, height: blockHeight));
                
                self.makeViewTappable(v: button, action: #selector(self.flip(_:)))
                self.itemViews.append(button)
                self.view.addSubview(button)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /**
     * Click on a card. If a card was clicked previously, check if they match.
     */
    func flip(_ sender: UITapGestureRecognizer) {
        if (self.interactionEnabled) {
            let view = sender.view as! UIImageView
            let index = itemViews.index(of: view)!
            
            view.image = self.itemImages[index]
            
            if let previous = self.selectedItem {
                self.interactionEnabled = false

                if self.itemImages[previous] == self.itemImages[index] {
                    // images are the same
                    self.interactionEnabled = true
                    // disable interaction on these views
                    self.itemViews[index].isUserInteractionEnabled = false
                    self.itemViews[previous].isUserInteractionEnabled = false
                    
                    //play sound
                    do{
                        soundPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
                        
                        soundPlayer.play()
                    }
                    catch{  }
                    
                    // determine score
                    let date = NSDate()
                    let time = Int64(date.timeIntervalSince1970)
                    if time - self.lastPairFound <= 3 {
                        self.scoreTimer?.incrementScore(5)
                    } else if time - self.lastPairFound <= 7 {
                        self.scoreTimer?.incrementScore(4)
                    } else {
                        self.scoreTimer?.incrementScore(3)
                    }
                    self.lastPairFound = Int64(date.timeIntervalSince1970)
                    
                    if (self.checkIfAllCardsAreFlipped()) {
                        self.winnerAlert()
                        self.scoreTimer?.stopTimer()
                        // TODO: save to highscores
                    }
                } else {
                    // images are different
                    
                    // wait one second before allowing interactions again
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        view.image = nil
                        self.itemViews[previous].image = nil
                        
                        self.interactionEnabled = true
                    }
                }
                self.selectedItem = nil
            } else {
                self.selectedItem = index
            }
        }
    }
    
    func makeViewTappable(v: UIImageView, action: Selector?)
    {
        v.backgroundColor = UIColor.gray
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1.0
        v.layer.cornerRadius = 5.0
        let tap = UITapGestureRecognizer(target: self, action: action)
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(tap)
    }
    
    func reset() {
        /*
         * reset
         */
        itemImages = [UIImage]()
        interactionEnabled = true
        for (i, view) in self.itemViews.enumerated() {
            view.isUserInteractionEnabled = true
            self.itemViews[i].image = nil
        }
        self.selectedItem = nil
        
        /*
         * add score and timer
         */
        scoreTimer?.seconds = self.difficulty == 0 ? 120 : self.difficulty == 1 ? 105 : 90 // ugly: {120, 105, 90}
        scoreTimer?.score = 0
        scoreTimer?.start()
        
        
        let horizontalCount = self.difficulty == 0 ? 3 : self.difficulty == 1 ? 4 : 5 // ugly: {3,4,5}
        
        /*
         * determine the random set of images.
         */
        for n in 0...((horizontalCount * 2) - 1)  {
            // Add two of the item
            self.itemImages.append(self.allImages[n])
            self.itemImages.append(self.allImages[n])
        }
        
        /*
         * randomise the set
         */
        self.itemImages = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self.itemImages) as! [UIImage]
    }
    
    func timeUp() {
        let alert = UIAlertController(title: "You lose", message: "Play again?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: {
            (action) in
            // TODO:
            self.reset()
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: {
            (action) in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    func winnerAlert() {
        highscoreManager.addHighScore(score: (self.scoreTimer?.score)!, game: Game.memory, difficulty: self.difficulty)
        
        let alert = UIAlertController(title: "You win", message: "Play again?", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .default, handler: {
            (action) in
            // TODO:
            self.reset()
        })
        let no = UIAlertAction(title: "No", style: .cancel, handler: {
            (action) in
            _ = self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(yes)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    func checkIfAllCardsAreFlipped() -> Bool {
        for view in self.itemViews {
            if view.image == nil {
                return false
            }
        }
        return true
    }
}
