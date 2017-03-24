//
//  MemoryGameViewController.swift
//  Kids Joy Center
//
//  Created by Steven Hernandez on 3/22/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit
import GameplayKit

class MemoryGameViewController: UIViewController {
    
    var difficulty = -1
    
    var blockHeight = 100
    var blockPadding = 10
    
    var itemViews = [UIImageView]()
    var itemImages = [UIImage]()
    
    var selectedItem: Int?
    var interactionEnabled = true;
    
    let allImages = [UIImage](arrayLiteral: #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "cat"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "gator"), #imageLiteral(resourceName: "giraffe"), #imageLiteral(resourceName: "horse"), #imageLiteral(resourceName: "lion"), #imageLiteral(resourceName: "monkey"), #imageLiteral(resourceName: "rooster"), #imageLiteral(resourceName: "zebra"));
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Memory Game"
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
         * reset
         */
        itemViews = [UIImageView]()
        itemImages = [UIImage]()
        interactionEnabled = true
        
        let horizontalCount = self.difficulty == 0 ? 3 : self.difficulty == 1 ? 4 : 5 // ugly: {3,4,5}
        
        print(horizontalCount * 2)
        
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
        
        print(self.itemImages)
        
        /*
         * build the image views
         */
        let topPadding = (768 - (4 * blockHeight) - (3 * blockPadding)) / 2
        let leftPadding = (1024 - (horizontalCount * blockHeight) - ((horizontalCount - 1) * blockPadding)) / 2
        
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
}
