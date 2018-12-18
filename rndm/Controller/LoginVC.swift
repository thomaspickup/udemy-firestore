//
//  LoginVC.swift
//  rndm
//
//  Created by Thomas Pickup on 26/11/2018.
//  Copyright © 2018 reviseolog. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    // Outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createUserBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginBtn.layer.cornerRadius = 10
        createUserBtn.layer.cornerRadius = 10
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailTxt.text,
            let password = passwordTxt.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
