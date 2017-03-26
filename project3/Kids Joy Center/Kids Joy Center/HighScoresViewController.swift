//
//  HighScoresViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/25/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let fr = CGRect(x: 0, y: 0, width: 450, height: 450)
        let table = UITableView(frame: fr)
        table.dataSource = self
        self.view.addSubview(table)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch (section) {
        case 0:
            return "Memory Game"
        case 1:
            return "Sorting Game"
        case 2:
            return "Balloon Game"
        default:
            return "???"
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return (highscoreManager.highscores[Game.memory]?.count)!
        case 1:
            return (highscoreManager.highscores[Game.sorting]?.count)!
        case 2:
            return (highscoreManager.highscores[Game.balloon]?.count)!
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        var str = String(indexPath.row + 1) + ". "
        
        switch (indexPath.section) {
        case 0:
            let highscore = highscoreManager.highscores[Game.memory]![indexPath.row]
            str += String(highscore.score) + " (" + highscore.difficultyString() + ")"
            break;
        case 1:
            let highscore = highscoreManager.highscores[Game.sorting]![indexPath.row]
            str += String(highscore.score) + " (" + highscore.difficultyString() + ")"
            break;
        case 2:
            let highscore = highscoreManager.highscores[Game.balloon]![indexPath.row]
            str += String(highscore.score) + " (" + highscore.difficultyString() + ")"
            break;
        default:
            break;
        }
        
        cell.textLabel?.text = str
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
