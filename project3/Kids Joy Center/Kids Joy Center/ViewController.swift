//
//  ViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/22/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

// Global
var highscoreManager = HighscoreManager()

class ViewController: UIViewController {
    var bgImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 1024, height: 768));
    
    var memoryGameButton = UIImageView(frame: CGRect(x: 67, y: 100, width: 250, height: 250));
    var sortingGameButton = UIImageView(frame: CGRect(x: 382, y: 100, width: 250, height: 250));
    var balloonGameButton = UIImageView(frame: CGRect(x: 697, y: 100, width: 250, height: 250));

    var easyButton = UIImageView(frame: CGRect(x: 400, y: 500, width: 75, height: 75));
    var mediumButton = UIImageView(frame: CGRect(x: 475, y: 500, width: 75, height: 75));
    var hardButton = UIImageView(frame: CGRect(x: 550, y: 500, width: 75, height: 75));

    var startButton = UIImageView(frame: CGRect(x: 437, y: 600, width: 150, height: 75));
    
    var mode = -1;
    var gameSelected = -1;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mode = -1
        gameSelected = -1
        
        self.makeViewTappable(v: memoryGameButton, action: #selector(self.gameSelect(_:)))
        self.makeViewTappable(v: sortingGameButton, action: #selector(self.gameSelect(_:)))
        self.makeViewTappable(v: balloonGameButton, action: #selector(self.gameSelect(_:)))
        self.makeViewTappable(v: easyButton, action: #selector(self.modeSelect(_:)))
        self.makeViewTappable(v: mediumButton, action: #selector(self.modeSelect(_:)))
        self.makeViewTappable(v: hardButton, action: #selector(self.modeSelect(_:)))
        self.makeViewTappable(v: startButton, action: #selector(self.start(_:)))
        
        self.bgImage.image = #imageLiteral(resourceName: "back-main")
        self.bgImage.alpha = 0.3
        
        memoryGameButton.image = #imageLiteral(resourceName: "memory")
        sortingGameButton.image = #imageLiteral(resourceName: "sorting-icon")
        balloonGameButton.image = #imageLiteral(resourceName: "balloon-game-logo1")
        
        easyButton.image = #imageLiteral(resourceName: "easy")
        mediumButton.image = #imageLiteral(resourceName: "medium")
        hardButton.image = #imageLiteral(resourceName: "hard")
        
        startButton.image = #imageLiteral(resourceName: "PlayButton")
        
        self.view.addSubview(bgImage)
        self.view.addSubview(memoryGameButton)
        self.view.addSubview(sortingGameButton)
        self.view.addSubview(balloonGameButton)
        self.view.addSubview(easyButton)
        self.view.addSubview(mediumButton)
        self.view.addSubview(hardButton)
        self.view.addSubview(startButton)
        
        let logo = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        logo.contentMode = .scaleAspectFit
        logo.image = #imageLiteral(resourceName: "star")
        
        navigationItem.titleView = logo
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Highscores", style: .plain, target: self, action: #selector(popUp))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeViewTappable(v: UIImageView, action: Selector?)
    {
        let tap = UITapGestureRecognizer(target: self, action: action)
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(tap)
    }
    
    func gameSelect(_ sender: UITapGestureRecognizer) {
        if sender.view == memoryGameButton {
            gameSelected = 0
        } else {
            self.fadeOut(memoryGameButton)
        }
        if sender.view == sortingGameButton {
            gameSelected = 1
        } else {
            self.fadeOut(sortingGameButton)
        }
        if sender.view == balloonGameButton {
            gameSelected = 2
        } else {
            self.fadeOut(balloonGameButton)
        }
        
        self.fadeIn(sender.view as! UIImageView)
    }
    
    func modeSelect(_ sender: UITapGestureRecognizer) {
        if sender.view == easyButton {
            mode = 0
        } else {
            self.fadeOut(easyButton)
        }
        if sender.view == mediumButton {
            mode = 1
        } else {
            self.fadeOut(mediumButton)
        }
        if sender.view == hardButton {
            mode = 2
        } else {
            self.fadeOut(hardButton)
        }
        
        self.fadeIn(sender.view as! UIImageView)
    }

    func start(_ sender: UITapGestureRecognizer) {
        if self.gameSelected == -1 {
            self.errorAlert("Please select a game to play")
        } else if self.mode == -1 {
            self.errorAlert("Please select a difficulty")
        } else {
            switch (self.gameSelected) {
            case 0:
                let vc = MemoryGameViewController()
                vc.difficulty = self.mode
                self.navigationController?.pushViewController(vc, animated: true);
                break
            case 1:
                let vc = SortingGameViewController()
                vc.difficulty = self.mode
                self.navigationController?.pushViewController(vc, animated: true);
                break
            case 2:
                let vc = BallowGameViewController()
                vc.difficulty = self.mode
                self.navigationController?.pushViewController(vc, animated: true);
                break
            default:
                break
            }
        }
    }
    
    func fadeIn(_ view: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1.0
        }
    }
    
    func fadeOut(_ view: UIImageView) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0.6
        }
    }
    
    func errorAlert(_ message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        errorAlert.addAction(action)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
    
    func popUp() {
        let newVC = HighScoresViewController()
        newVC.view.backgroundColor = UIColor.gray
        
        newVC.modalPresentationStyle = .popover
        newVC.modalTransitionStyle = .coverVertical
        
        newVC.preferredContentSize = CGSize(width: 450, height: 450)
        
        let pop = newVC.popoverPresentationController
        pop?.barButtonItem = navigationItem.rightBarButtonItem
        
        //vc.modalTransitionStyle = .crossDissolve
        present(newVC, animated: true, completion: nil)
        
        
    }
    
}

