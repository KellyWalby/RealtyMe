//
//  MessageViewController.swift
//  RealtyMe
//
//  Created by Kelly Walby on 3/1/21.
//  Copyright © 2021 Kelly Walby. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MessageViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    struct houseData {
        var profileDocID = [String]() //listing addresses, also used to count how many listing are in db so that many cells are made
        var profileName = [String]() //listing prices
        var imageArray = ["IMG_5841","IMG_5843","IMG_5842"] //listing image unique names (as in firebase storage)
        var lastMessageArray = [String]()
        let imageview = UIImageView() //image for each cell
        let profileNameLabel = UILabel()
        let lastMessageLabel = UILabel()
    }
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser?.uid
    var data = houseData() //init of struct
    
    func loadProfileName() {
        db.collection("users").document(uid!).collection("messages").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.data.profileName.append(document.documentID)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func loadlastMessage() {
        db.collection("users").document(uid!).collection("messages").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.data.lastMessageArray.append(document.data()["lastMessage"] as! String)
                }
            }
            self.tableView.reloadData()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.profileName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTable
        if data.profileName.count > 0 && indexPath.row < data.profileName.count && data.lastMessageArray.count > 0 && indexPath.row < data.lastMessageArray.count && data.imageArray.count > 0 && indexPath.row < data.imageArray.count  {
            let name = data.profileName[indexPath.row]
            cell.myLabel1.text = name
            let message = data.lastMessageArray[indexPath.row]
            cell.myLabel2.text = message
            let image = data.imageArray[indexPath.row]
            cell.myImageView.image = UIImage(named: image)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "MessageTableToMessageChain", sender: nil)
    }
    
    
    @IBOutlet weak var homeToolbarButton: UIBarButtonItem!
    @IBOutlet weak var messageToolbarButton: UIBarButtonItem!
    @IBOutlet weak var accountToolbarButton: UIBarButtonItem!
    
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = self.view.frame
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(CustomTable.self, forCellReuseIdentifier: "cell")
        loadProfileName()
        loadlastMessage()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
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

class CustomTable: UITableViewCell{
    
    public let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.backgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) //super light gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public let myLabel1: UILabel = {
        let profileName = UILabel()
        return profileName
    }()
    
    public let myLabel2: UILabel = {
        let lastMessage = UILabel()
        lastMessage.font = lastMessage.font.withSize(14)
        return lastMessage
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style:.subtitle,reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myImageView)
        contentView.addSubview(myLabel1)
        contentView.addSubview(myLabel2)
        
        myImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        myImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myLabel1.frame = CGRect(x: 56,
                                y: contentView.frame.origin.y - 10,
                                width: contentView.frame.width,
                                height: contentView.frame.height)
        myLabel2.frame = CGRect(x: 56,
                                y: contentView.frame.origin.y + 12,
                                width: contentView.frame.width,
                                height: contentView.frame.height)
    }
}
