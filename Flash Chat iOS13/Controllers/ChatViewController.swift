//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var UILogoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let firebaseAuth = Auth.auth()
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = Constants.appName
        tableView.dataSource = self
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener {(querySnapshot, error) in
            self.messages = []
            if let err = error {
                print("Error retrieving messages: \(err)")
            } else {
                if let queryDocs = querySnapshot?.documents{
                    for document in queryDocs {
                        let data = document.data()
                        if let sender = data[Constants.FStore.senderField] as? String,
                           let messageBody = data[Constants.FStore.bodyField] as? String {
                            let fullMessage = Message(sender: sender, body: messageBody)
                            self.messages.append(fullMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1,section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.collectionName).addDocument(data: [
                Constants.FStore.senderField: messageSender,
                Constants.FStore.bodyField: messageBody,
                Constants.FStore.dateField: Date().timeIntervalSince1970
            ]) {(error) in
                if let e = error {
                    print("Error saving message: \(e)")
                } else {
                    print("Successfully saved to Firebase!")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
        
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            
        }
    }
    
}

//MARK: TableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
            as! MessageCell
        cell.label?.text = message.body
        
        // Message from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.label.textColor = UIColor(named: Constants.BrandColors.purple)
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.lightPurple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.label.textColor = UIColor(named: Constants.BrandColors.lightPurple)
            cell.messageBubble.backgroundColor = UIColor(named: Constants.BrandColors.purple)

        }
        
        return cell
    }
}


