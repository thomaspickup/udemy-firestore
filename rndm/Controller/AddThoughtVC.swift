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
    @IBOutlet private weak var categorySegment: UISegmentedControl!
    @IBOutlet private weak var userNameTxt: UITextField!
    @IBOutlet private weak var thoughtTxt: UITextView!
    @IBOutlet private weak var postBtn: UIButton!
    
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
        // Builds Array to add to collection
        guard let username = userNameTxt.text else { return }
        let dataString = [CATEGORY : selectedCategory, NUM_COMMENTS : 0, NUM_LIKES : 0, THOUGHT_TXT : thoughtTxt.text, TIMESTAMP : FieldValue.serverTimestamp(), USERNAME : username ] as [String : Any]
        
        // Adds array to firestore collection
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: dataString) { (err) in
            if let err = err {
                // Prints error if any
                debugPrint("Error adding document: \(err)")
            } else {
                // Returns to the main screen if post sucessful
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Checks if category is changed
    @IBAction func categoryChanged(_ sender: Any) {
        // Changes value of selectedCategory based on selected segment
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
