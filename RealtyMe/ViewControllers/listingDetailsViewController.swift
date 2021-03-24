//
//  listingDetailsViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/23/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit

class listingDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    
    @IBOutlet weak var listingImage: UIImageView!
    
    @IBOutlet weak var listingStreetName: UILabel!
    
    @IBOutlet weak var listingAddress: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var listingSqFt: UILabel!
    
    @IBOutlet weak var bookmark: UIButton!
    
    @IBOutlet weak var listingFeatures: UILabel!
    
    @IBOutlet weak var listingDescription: UITextView!
    
    @IBOutlet weak var bedrooms: UILabel!
    
    @IBOutlet weak var bathrooms: UILabel!
    
    @IBOutlet weak var yearBuilt: UILabel!
    
    @IBOutlet weak var extraFeature1: UILabel!
    
    @IBOutlet weak var extraFeature2: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listingImage.image = UIImage(named: "IMG_5797")
//        listingStreetName.text = "2685 Riviera Dr. S."
//        listingAddress.text = "White Bear Lake, MN, 55110"
//        listingPrice.text = "$600,000"
//        listingSqFt.text = "4,000"
//        listingDescription.text = "Great place to raise a family!"
//        bedrooms.text = "Bedrooms: 3"
//        bathrooms.text = "Bathrooms: 3"
//        yearBuilt.text = "1983"
//        extraFeature1.text = "Built-in Pool"
//        extraFeature2.text = "Home Movie Theater"
        
        listingDescription.isEditable = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToHome", sender: nil)
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToMessage", sender: nil)
    }
    
    @IBAction func notificationToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToNotif", sender: nil)
    }
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ListingDetailsToAccount", sender: nil)
    }
}
