//
//  HomeViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/2/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var HomeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var MessageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var NotificationToolbarButton: UIBarButtonItem!
    
    @IBOutlet weak var AccountToolbarButton: UIBarButtonItem!
    
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


//    @IBAction func AccountToolbarButtonTapped(_ sender: Any) {
//        
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let accountView = storyboard.instantiateViewController(identifier: Constants.Storyboard.accountViewController) as? AccountViewController
//        self.present(accountView!, animated: true, completion: nil)
//    }
    
}
