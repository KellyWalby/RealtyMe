//
//  notifViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/8/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit

class notifViewController: UIViewController {
    
    
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolbarButton: UIBarButtonItem!
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
        self.performSegue(withIdentifier: "NotifToHomeSegue", sender: nil)
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "NotifToMessageSegue", sender: nil)
    }
    
    @IBAction func notificationToolbarButtonTapped(_ sender: Any) {
        //do nothing since it is already here
    }
    
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "NotifToAccountSegue", sender: nil)
    }
}
