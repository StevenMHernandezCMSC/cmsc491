//
//  MemoryGameViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/22/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class MemoryGameViewController: UIViewController {
    
    var difficulty = -1
    
    var blockHeight = 100
    var blockPadding = 10
    
    var items = [UIImageView]();

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        let horizontalCount = self.difficulty == 0 ? 3 : self.difficulty == 1 ? 4 : 5
        let topPadding = (768 - (4 * blockHeight) - (3 * blockPadding)) / 2
        let leftPadding = (1024 - (horizontalCount * blockHeight) - ((horizontalCount - 1) * blockPadding)) / 2
        
        for y in 0...3 {
            for x in 0...(horizontalCount - 1) {
                print(x,y)
                let button = UIImageView(frame: CGRect(x: leftPadding + ((blockHeight + blockPadding) * x),
                                                       y: topPadding + ((blockHeight + blockPadding) * y),
                                                       width: blockHeight, height: blockHeight));
                
                self.makeViewTappable(v: button, action: #selector(self.test(_:)))
                self.items.append(button)
                self.view.addSubview(button)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func test(_ sender: UITapGestureRecognizer) {
        print(items.index(of: sender.view as! UIImageView)!)
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
}
