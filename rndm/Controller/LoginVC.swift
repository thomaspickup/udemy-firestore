//
//  LoginVC.swift
//  rndm
//
//  Created by Thomas Pickup on 26/11/2018.
//  Copyright © 2018 reviseolog. All rights reserved.
//

import UIKit

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
    }
    
    @IBAction func createUserBtnTapped(_ sender: Any) {
    }
}
