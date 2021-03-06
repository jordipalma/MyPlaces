//
//  DetailController.swift
//  MyPlaces
//
//  Created by Jordi Palma Sanchez on 20/9/18.
//  Copyright © 2018 Exploracat. All rights reserved.
//

import UIKit
import Photos

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
    let m_location_manager:ManagerLocation = ManagerLocation.shared()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constraintHeight.constant = 400
        
        viewPicker.delegate = self
        viewPicker.dataSource = self

        
        //configurem imageView
        imagePicked.contentMode = .scaleAspectFit
        
        //complimentem les dades del Place seleccionat
        if place != nil {
            textName.text = place!.name
            textDescription.text = place!.description
            viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
            
            if place!.hasImage{
                imagePicked.image = UIImage(contentsOfFile: m_provider.GetPathImage(p: place!))
            }else{
                imagePicked.image = UIImage(named: "placeholder")
            }
            
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
        
        //verifiquem que tenim accés a la llibreria de fotos
        //checkPermission()
 
    }
    
    /*
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
            case .authorized: print("Access is granted by user")
            case .notDetermined: PHPhotoLibrary.requestAuthorization({
                (newStatus) in print("status is \(newStatus)")
                if newStatus == PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }})
            case .restricted:
                print("User do not have access to photo album.")
            case .denied:
                print("User has denied the permission.")
        }
    }
    */


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
            
            //com que es tracta d'una referència, si actualitzem aquí també s'actualitza a l'array del manager
            place!.name = textName.text ?? ""
            place!.description = textDescription.text ?? ""
            
            //haurem d'actualitzar se el place té imatge o no
            //pl.hasImage
            

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
            
            var pl:Place
            switch type{
            case .GenericPlace:
                pl = Place(type: type, name: name, description: descrip, image_in: data)
            case .TouristicPlace:
                pl = PlaceTourist(name: name, description: descrip, discount_tourist: "10?", image_in: data)
            }
            
            pl.location = m_location_manager.getLocation()
            
            //actualitzem la propietat
            self.place = pl
            
            //afegim el place a través del ManagerPlaces
            m_provider.append(pl)
        }
        m_provider.updateObservers()
        
        //tornem a la tableView
        dismiss(animated:true, completion: nil)
    }
    
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        print("removeButtonPressed")
        //Fem servir el mètode remove de ManagerPlaces passant com a paràmetre place
        if self.place != nil {
            m_provider.remove(self.place!)

            m_provider.updateObservers()
            
            //tornem a la tableView
            dismiss(animated:true, completion: nil)
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        print("cancelButtonPressed")
        
        //tornem a la tableView
        dismiss(animated:true, completion: nil)
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
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        view.endEditing(true)
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated:true, completion: nil)
    }
    
}
