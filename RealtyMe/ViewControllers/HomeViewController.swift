//
//  HomeViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 2/2/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var notificationToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    var count = 0
    var num = 20

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/2.1, height: collectionView.frame.width/2)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
// ????? TRIED TO COUNT NUMBER OF LISTINGS SO TILES WOULD REFLECT THAT BUT IT DIDNT WORK
//        db.collection("listings").getDocuments()
//        {
//            (querySnapshot, err) in
//            if let err = err
//            {
//                print("Error getting documents: \(err)");
//            }
//            else
//            {
//                for document in querySnapshot!.documents {
//                    self.count += 1
//                }
//                self.num = self.count
//            }
//        }
        return num //probs change to 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.backgroundColor = .gray //background color of cell
        cell.layer.cornerRadius = 8 //adds rounded corner to tiles
        return cell
    }
    
    
        fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")

        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up collection view colors & constraints
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        collectionView.showsVerticalScrollIndicator = false //makes scroll bar invisable

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func homeToolbarButtonTapped(_ sender: Any) {
        //do nothing, already here
    }
    
    @IBAction func messageToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeMessageSegue", sender: nil)
    }
    
    @IBAction func notificationToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToNotifSegue", sender: nil)
    }
    
    @IBAction func accountToolbarButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToAccountSegue", sender: nil)
    }
}

class CustomCell: UICollectionViewCell{

    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    override init(frame: CGRect) {

        super.init(frame: frame)
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
