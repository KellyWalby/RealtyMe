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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
