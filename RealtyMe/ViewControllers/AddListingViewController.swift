//
//  AddListingViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/18/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AddListingViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var squareFtTextField: UITextField!
    @IBOutlet weak var numBathroomsTextField: UITextField!
    @IBOutlet weak var addListingButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var numBedroomsTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var listingImage: UIImageView!
    
    //variable to reference to db
    let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var listingPic = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //hide error label
        errorLabel.alpha = 0
        //confirmationLabel.alpha = 0
        //style elements
        Utilities.styleTextField(priceTextField)
        Utilities.styleTextField(addressTextField)
        Utilities.styleTextField(cityTextField)
        Utilities.styleTextField(stateTextField)
        Utilities.styleTextField(zipcodeTextField)
        Utilities.styleTextField(squareFtTextField)
        Utilities.styleTextField(numBathroomsTextField)
        Utilities.styleTextField(numBedroomsTextField)
        Utilities.styleTextView(descriptionTextView)
        Utilities.styleFilledButton(addListingButton)
        
        listingImage.translatesAutoresizingMaskIntoConstraints = false
        listingImage.contentMode = .scaleAspectFit
        listingImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        listingImage.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfileImageView(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        guard let uid = Auth.auth().currentUser?.uid //unwrap safetly in case user is not logged in
        else {
            return //user is not logged in
        }
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        let imageName = NSUUID().uuidString
        storage.child("listingImages/\(imageName).png").putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("failed to upload")
                return
            }
            self.storage.child("listingImages/\(imageName).png").downloadURL (completion: {url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                //update user data
                print("Download URL: \(urlString)")
                UserDefaults.standard.set(urlString, forKey: "url") //idk what this does
                //let error = self.validateFields()
                //self.picName.text = imageName+".png"
                if error != nil {
                    //Something wrong with the fields
                    self.showError("Error")
                }
                else {
                    //create cleaned versions of the data
//                    let price = self.priceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let address = self.addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let city = self.cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let state = self.stateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let zipcode = self.zipcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let sqFt = self.squareFtTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let bathrooms = self.numBathroomsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let bedrooms = self.numBedroomsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//                    let description = self.descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                    self.listingPic = imageName+".png"
                    //self.listingImage.image = UIImage(named: self.listingPic)
                    
                    
//                    //create new listing
//                    let createListing = self.db.collection("listings").document(address)
//                    createListing.setData(["price": price, "address":address,"city":city,"state":state,"zipcode":zipcode,"sqFt":sqFt,"bathrooms":bathrooms,"bedrooms":bedrooms,"description":description,"listingImage":picture]) {(error) in
//                                if error != nil{
//                                    self.showError("Error saving user data.")
//                                }
//                    }
                }
            })
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    func showError(_ message:String){
        errorLabel.text = message //creates error message
        errorLabel.alpha = 1 //shows message to user
}
    
//    func showConfirmation(_ message:String){
//        confirmationLabel.text = message //creates error message
//        confirmationLabel.alpha = 1 //shows message to user
//}

    
    //checks to make sure info is correct
    func validateFields() -> String?{
        
        //checks that all fields are filled in
        if priceTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || zipcodeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || numBedroomsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || numBathroomsTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || descriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || squareFtTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        if listingPic == "" {
            return "Please add a photo of the listing."
        }
        return nil
    }
    

    @IBAction func addListingButtonTapped(_ sender: Any) {
        //validate the fields
        let error = validateFields()
        
        if error != nil {
            //Something wrong with the fields
            showError(error!)
        }
        else {
            //create cleaned versions of the data
            let price = priceTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let address = addressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let city = cityTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let state = stateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let zipcode = zipcodeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let sqFt = squareFtTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bathrooms = numBathroomsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bedrooms = numBedroomsTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let description = descriptionTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create new listing
            let createListing = db.collection("listings").document(address)
            createListing.setData(["price": price, "address":address,"city":city,"state":state,"zipcode":zipcode,"sqFt":sqFt,"bathrooms":bathrooms,"bedrooms":bedrooms,"description":description, "listingImage":self.listingPic]) {(error) in
                        if error != nil{
                            self.showError("Error saving user data.")
                        }
                    }
            //create message to tell user their profile has been updated and save
            //showConfirmation("Your listing was successfully created!")
            //self.performSegue(withIdentifier: "CreatedListing" , sender: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
