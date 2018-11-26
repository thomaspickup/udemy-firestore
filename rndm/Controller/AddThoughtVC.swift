//
//  AddThoughtVC.swift
//  rndm
//
//  Created by Thomas Pickup on 25/11/2018.
//  Copyright © 2018 reviseolog. All rights reserved.
//

import UIKit

class AddThoughtVC: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var thoughtTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initial UI Set Up
        postBtn.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My Random Thought..."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self
    }
    
    // Removes placeholder text when user starts to type.
    func textViewDidBeginEditing(_ textView: UITextView) {
        thoughtTxt.text = ""
        thoughtTxt.textColor = UIColor.darkGray
    }
    
    // Checks if button is pressed
    @IBAction func postBtnTapped(_ sender: Any) {
    }
    
    // Checks if category is changed
    @IBAction func categoryChanged(_ sender: Any) {
    }
    
}
