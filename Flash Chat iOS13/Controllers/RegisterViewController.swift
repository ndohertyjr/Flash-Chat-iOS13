//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        //Allow users to register with firebase
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) {authResult, error in
                if error != nil {
                    let alert = UIAlertController(title: "Registration Error", message: "Please enter an email and password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: {_ in
                        print("Error occured during registration:")
                        print(error!)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //Navigate to chat view controller
                    self.performSegue(withIdentifier: "RegisterToChat", sender: self)
                }
            }
        }
        

        
    }
    
}
