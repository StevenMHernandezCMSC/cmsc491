//
//  ViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/22/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var memoryGameButton = UIImageView(frame: CGRect(x: 100, y: 100, width: 99, height: 99));
    var sortingGameButton = UIImageView(frame: CGRect(x: 200, y: 100, width: 99, height: 99));
    var balloonGameButton = UIImageView(frame: CGRect(x: 300, y: 100, width: 99, height: 99));

    var easyButton = UIImageView(frame: CGRect(x: 100, y: 200, width: 99, height: 99));
    var mediumButton = UIImageView(frame: CGRect(x: 200, y: 200, width: 99, height: 99));
    var hardButton = UIImageView(frame: CGRect(x: 300, y: 200, width: 99, height: 99));

    var startButton = UIImageView(frame: CGRect(x: 200, y: 400, width: 99, height: 99));
    
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
        
        self.view.addSubview(memoryGameButton)
        self.view.addSubview(sortingGameButton)
        self.view.addSubview(balloonGameButton)
        self.view.addSubview(easyButton)
        self.view.addSubview(mediumButton)
        self.view.addSubview(hardButton)
        self.view.addSubview(startButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print(self.gameSelected, self.mode, "n")
        
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
            view.alpha = 0.8
        }
    }
    
    func errorAlert(_ message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        errorAlert.addAction(action)
        
        present(errorAlert, animated: true, completion: nil)
    }
    
}

