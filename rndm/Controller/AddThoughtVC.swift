//
//  AddThoughtVC.swift
//  rndm
//
//  Created by Thomas Pickup on 25/11/2018.
//  Copyright © 2018 reviseolog. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController, UITextViewDelegate {
    // Outlets
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var thoughtTxt: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    
    // Variables
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    
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
        guard let username = userNameTxt.text else { return }
        
        // Adds post to firestore collection
        Firestore.firestore().collection("thoughts").addDocument(data: [
            "category" : selectedCategory,
            "numComments" : 0,
            "numLikes" : 0,
            "thoughtTxt" : thoughtTxt.text,
            "timestamp" : FieldValue.serverTimestamp(),
            "username" : username
            ]) { (err) in
            if let err = err {
                debugPrint("Error adding document: \(err)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Checks if category is changed
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.funny.rawValue
        }
    }
    
}
