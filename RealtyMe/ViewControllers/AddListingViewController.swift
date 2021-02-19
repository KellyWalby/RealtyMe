//
//  AddListingViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/18/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //hide error label
        errorLabel.alpha = 0
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBAction func addListingButtonTapped(_ sender: Any) {
    }
}
