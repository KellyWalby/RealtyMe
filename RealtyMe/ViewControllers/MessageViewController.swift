//
//  MessageViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/1/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func homeToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "MessageToHomeSegue", sender: nil)
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        //do nothing
    }
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "MessageToAccountSegue", sender: nil)
    }
}
