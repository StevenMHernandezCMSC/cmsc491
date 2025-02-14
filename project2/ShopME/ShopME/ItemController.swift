//
//  ItemControllerViewController.swift
//  ShopME
//
//  Created by Steven Hernandez on 2/18/17.
//  Copyright © 2017 Steven Hernandez. All rights reserved.
//

import UIKit

class ItemController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, CategoryCreateControllerDelegate {

    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var selectImage:UIImage?
    
    var picker = UIPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add Product"

        // Do any additional setup after loading the view.

        itemImageView.isHidden = true

        picker.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryTextField.inputView = picker
        categoryTextField.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addImagePressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }

    @IBAction func onCancel(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func onSave(_ sender: Any) {
        if let name = self.nameTextField!.text,
           let category = self.categoryTextField!.text?.lowercased(),
           let description = self.descriptionTextField!.text,
            let price = self.priceTextField!.text,
            name != "",
            category != "",
            description != "",
            price != "",
           let image = self.selectImage {
            if let priceDouble = Double(price) {
                let cents = Int(priceDouble * 100)
                let item = Item(name, description, cents, image)
                
                for c in store.categories {
                    if (c.title.lowercased() == category.lowercased()) {
                        c.items.insert(item, at: 0)
                    }
                }
                
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.errorAlert("There was an error reading price")
            }
        } else {
            self.errorAlert("Please fill out all fields and upload an image")
        }
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
    
    func numberOfComponents(in: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return store.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return store.categories[row].title.capitalized
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryTextField.text = store.categories[row].title.capitalized
    }

    func donePicker (sender:UIBarButtonItem)
    {
        if (sender.title == "Cancel") {
            self.categoryTextField.text = nil
        }
        
        self.categoryTextField.endEditing(true)
    }

    @IBAction func newCategory(_ sender: Any) {
        performSegue(withIdentifier: "categoryCreate", sender: self)
    }

    func categoryCreateControllerResponse(category: Category)
    {
        self.categoryTextField.text = category.title
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categoryCreate"{
            if let destinationVC = segue.destination as? CategoryCreateController {
                destinationVC.delegate = self
            }
        }
    }
}
