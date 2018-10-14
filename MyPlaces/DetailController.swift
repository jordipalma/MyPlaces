//
//  DetailController.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    
    // Places types
    let pickerElems1 = ["Generic place", "Touristic place"]
    
    var place:Place? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constraintHeight.constant = 400
        
        viewPicker.delegate = self
        viewPicker.dataSource = self

        
        if place != nil {
            textName.text = place!.name
            textDescription.text = place!.description
            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
            
            
        }
        
        
    }
    
    @IBAction func selectImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
    
    
    }
    
    
    @IBAction func removeButtonPressed(_ sender: Any) {
    
    
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // *************************************************************
    // * UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ picker: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerElems1.count
    }
    func pickerView(_ picker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElems1[row]
    }
    // *************************************************************
    
    // *************************************************************
    // * UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        //let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        view.endEditing(true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil) }
    
}
