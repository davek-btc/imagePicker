//
//  ViewController.swift
//  pickingImages
//
//  Created by David Kayo on 5/6/17.
//  Copyright © 2017 David Kayo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate { // add protocal to the class declaration

    @IBOutlet weak var imagePickerView: UIImageView! // Outlet
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -4.0]
        
        textTop.text = "TOP"
        textTop.textAlignment = .justified
        textTop.defaultTextAttributes = memeTextAttributes
        
        textBottom.text = "BOTTOM"
        textBottom.textAlignment = .center
        textBottom.defaultTextAttributes = memeTextAttributes
    
        textTop.delegate = self
        textBottom.delegate = self
     
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func dismissKeyboard(){
        textTop.resignFirstResponder()
        textBottom.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(userText: UITextField!) -> Bool {
        
        textBottom.resignFirstResponder()
        textTop.resignFirstResponder()
        
        return true
    }
    
//    @IBAction func pickAnImage(_ sender: Any) { //Action/Func to button.
//   
//        let pickController = UIImagePickerController() //Creation of instances of object
//        pickController.delegate = self // set delegate before your pickController
//        self.present(pickController, animated: true, completion: nil)
//    
//    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    
    }
    
    @IBAction func selectCamera(_ sender: Any) {
    
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.present(imagePicker, animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //let UIImagePickerControllerReferenceURL: String
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
         print("Working keyboardWillShow")
        
        if textBottom.isFirstResponder {
             print("Working with in if statement")
            self.view.frame.origin.y = 0
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(_ notification:Notification) {
        
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            self.view.frame.origin.y = 0
        
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
}

    


