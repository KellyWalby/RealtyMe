//
//  forgotPassViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/8/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class forgotPassViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var resetPassButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var confirmationMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set UI elements
        //hides error & confirmation label  initially
        errorLabel.alpha = 0
        confirmationMessage.alpha = 0
        Utilities.styleTextField(emailTextField)
        Utilities.styleFilledButton(resetPassButton)
    }
    
    @IBAction func resetPassButtonTapped(_ sender: Any) {
        //validate text fields
        let error = validateFields()
        
        if error != nil {
            //Something wrong with the fields
            showError(error!)
        } else {
            let auth = Auth.auth()
            auth.sendPasswordReset(withEmail: emailTextField.text!) { (error) in
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                self.showMessage()
            }
        }
    }
    
    //checks to make sure info is correct
    func validateFields() -> String?{
        
        //checks that email field is filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        return nil
    }
    
    func showError(_ message:String){
        errorLabel.text = message //creates error message
        errorLabel.alpha = 1 //shows message to user
        
}
    func showMessage(){
        confirmationMessage.text = "A password reset email has to be sent!" //create confirmation message
        confirmationMessage.alpha = 1 //shows message to user
    }
}
