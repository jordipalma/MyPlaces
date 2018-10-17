//
//  DetailController.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import UIKit

class DetailController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var keyboardHeight:CGFloat!
    var activeField: UIView!
    var lastOffset:CGPoint!
    
    // Places types
    let pickerElems1 = ["Generic place", "Touristic place"]
    
    
    var place:Place? = nil
    let m_provider:ManagerPlaces = ManagerPlaces.shared()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constraintHeight.constant = 400
        
        viewPicker.delegate = self
        viewPicker.dataSource = self

        //complimentem les dades del Place seleccionat
        if place != nil {
            textName.text = place!.name
            textDescription.text = place!.description
            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
        }else{
            //es tractarà d'un nou place. Canviem els noms.
            btnUpdate.setTitle("New", for: .normal)
        }
        
        
        // Soft keyboard Control
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        textName.delegate = self
        textDescription.delegate = self
 
    }
    
    //mètodes pel control del teclat
    
    @objc func showKeyboard(notification: Notification) {
        if(activeField != nil){
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            keyboardHeight = keyboardViewEndFrame.size.height
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            let collapseSpace = keyboardHeight - distanceToBottom
            if collapseSpace > 0 {
                self.scrollView.setContentOffset(CGPoint(x: self.lastOffset.x, y: collapseSpace + 10), animated: false)
                self.constraintHeight.constant += self.keyboardHeight
            } else{
                keyboardHeight = nil
            }
        }
    }
    
    // Hide soft keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func hideKeyboard(notification: Notification) {
        if(keyboardHeight != nil){
            self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: self.lastOffset.y)
            self.constraintHeight.constant -= self.keyboardHeight
        }
        keyboardHeight = nil
    }
    
    @objc func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if(activeField==textView) {
            activeField?.resignFirstResponder()
            activeField = nil
            return true
        }
        return false
    }
    
    
    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(activeField==textField) {
            activeField?.resignFirstResponder()
            activeField = nil
            return true
        }
        return false
    }
    
    
    
    //accions per als butons
    @IBAction func selectImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }

    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        
        //en funció de si tenim place o no sabrem si és un update o un new
        if place != nil {
            print("updateButtonPressed")
            //De moment només permetem modificar name i description
            //IMPORTANT: En una primera fase de les modificacions no permetrem canviar el tipus del place ni la imatge
            
            let pl = m_provider.GetItemById(id: self.place!.id)
            pl.name = textName.text ?? ""
            pl.description = textDescription.text ?? ""
            
            //TODO: actualitzar le place a través del manager no?
            
        }else{
            print("newButtonPressed")
            //creem un nou place
            
            let type: Place.PlacesTypes = Place.PlacesTypes.init(rawValue: viewPicker.selectedRow(inComponent: 0))!
            let name = textName.text ?? ""
            let descrip = textDescription.text ?? ""
            var data:Data? = nil
            if imagePicked.image != nil {
                data = imagePicked.image!.jpegData(compressionQuality: 1.0)
            }
            let pl = Place(type: type, name: name, description: descrip, image_in: data)
            pl.location = ManagerLocation.GetLocation()
            
            //actualitzem la propietat
            self.place = pl
            
            //afegim el place a través del ManagerPlaces
            m_provider.append(pl)
            
        }
    }
    
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        print("removeButtonPressed")
        //Fem servir el mètode remove de ManagerPlaces passant com a paràmetre place
        if self.place != nil {
            m_provider.remove(self.place!)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("cancelButtonPressed")
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
