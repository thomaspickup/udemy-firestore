//
//  ViewController.swift
//  rndm
//
//  Created by Thomas Pickup on 25/11/2018.
//  Copyright © 2018 reviseolog. All rights reserved.
//

import UIKit
import Firebase

enum ThoughtCategory : String {
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}
class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // Outlets
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    @IBOutlet private weak var tableView: UITableView!
    
    // Variables
    private var thoughts = [Thought]()
    private var thoughtsCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        thoughtsCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        thoughtsListener.remove()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        // Changes value of selectedCategory based on selected segment
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        case 3:
            selectedCategory = ThoughtCategory.popular.rawValue
        default:
            selectedCategory = ThoughtCategory.funny.rawValue
        }
        
        thoughtsListener.remove()
        setListener()
    }
    
    func setListener() {
        thoughtsListener = thoughtsCollectionRef.whereField("category", isEqualTo: selectedCategory).addSnapshotListener { (snapshot, err) in
            if let err = err {
                debugPrint("Error fetching docs: \(err)")
            } else {
                self.thoughts.removeAll()
                
                guard let snap = snapshot else { return }
                for document in snap.documents {
                    let data = document.data()
                    
                    let username = data[USERNAME] as? String ?? "Anonymous"
                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
                    let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
                    let numLikes = data[NUM_LIKES] as? Int ?? 0
                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
                    let documentID = document.documentID
                    
                    let newThought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentID)
                    
                    self.thoughts.append(newThought)
                }
                self.tableView.reloadData()
            }
        }
    }
}

