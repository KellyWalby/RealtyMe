//
//  AddListingViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/18/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class AddListingViewController: UIViewController {

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
    
    //variable to reference to db
    let db = Firestore.firestore()
    
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
            createListing.setData(["price": price, "address":address,"city":city,"state":state,"zipcode":zipcode,"sqFt":sqFt,"bathrooms":bathrooms,"bedrooms":bedrooms,"description":description]) {(error) in
                        if error != nil{
                            self.showError("Error saving user data.")
                        }
                    }
            //create message to tell user their profile has been updated and save
            //showConfirmation("Your listing was successfully created!")
            self.performSegue(withIdentifier: "CreatedListing" , sender: nil)
        }
    }
}
