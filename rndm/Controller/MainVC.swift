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
    private var handle: AuthStateDidChangeListenerHandle?
    
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
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
                
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil {
            thoughtsListener.remove()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
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
        if (selectedCategory == ThoughtCategory.popular.rawValue) {
            thoughtsListener = thoughtsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, err) in
                    if let err = err {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        self.thoughts.removeAll()
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }
        } else {
            thoughtsListener = thoughtsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener { (snapshot, err) in
                    if let err = err {
                        debugPrint("Error fetching docs: \(err)")
                    } else {
                        self.thoughts.removeAll()
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
            }
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("Error signing out: \(signoutError)")
        }
    }
}

