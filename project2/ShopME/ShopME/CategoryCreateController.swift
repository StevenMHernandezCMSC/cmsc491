//
//  ItemControllerViewController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/24/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

protocol CategoryCreateControllerDelegate
{
    func categoryCreateControllerResponse(category: Category)
}

class CategoryCreateController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTextLabel: UITextField!

    var selectImage:UIImage?
    
    var delegate: CategoryCreateControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Category"
        
        itemImageView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addImagePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.selectImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.itemImageView.image = self.selectImage
        
        self.itemImageView.isHidden = false
        
        dismiss(animated: true, completion: nil)
    }
    
    func errorAlert(_ message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        errorAlert.addAction(action)
        
        present(errorAlert, animated: true, completion: nil)
    }

    @IBAction func addCategory(_ sender: Any) {
        if let title = self.titleTextLabel.text {
            if let image = self.selectImage {
                for category in store.categories {
                    if category.title == title {
                        self.delegate?.categoryCreateControllerResponse(category: category)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                }
                
                let newCategory = Category(title.lowercased(), image)

                store.categories.insert(newCategory, at: 0)
                
                self.delegate?.categoryCreateControllerResponse(category: newCategory)
                
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.errorAlert("Please add a category icon.")
            }
        } else {
            self.errorAlert("Please set a category title")
        }
    }

    @IBAction func cancel(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
