//
//  UserTableViewController.swift
//  SocialGram
//
//  Created by HONG LY on 5/15/17.
//  Copyright © 2017 HONG LY. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {

    var usernames = [""]
    var userIDs = [""]
    // Store which user is following whom
    var isFollowing = ["" : false]
    
    var refresher: UIRefreshControl!
    
    // Logout button
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)

    }
    
    // Pull to refresh method
    func refresh() {
        // Query user from server
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if error != nil {
                
                print(error!)
                
            }
            // objects contain all users
            else if let users = objects {
                
                // clear space in first row since usernames or userIDs are initialized with empty string
                self.usernames.removeAll()
                self.userIDs.removeAll()
                self.isFollowing.removeAll()
                
                for object in users {
                    
                    // Cast object to PFUser
                    if let user = object as? PFUser {
                        
                        // Hides current user (me as the user)
                        if user.objectId != PFUser.current()?.objectId {
                            
                            // Sperate usernames from emails
                            let usernameArray = user.username!.components(separatedBy: "@")
                            
                            // Append all users in arrays
                            self.usernames.append(usernameArray[0])
                            self.userIDs.append(user.objectId!)
                            
                            // Query Followers class
                            let query = PFQuery(className: "CFollowers")
                            
                            // Find sepcfic types of data
                            // Check to see follower is following current users
                            query.whereKey("follower", equalTo: (PFUser.current()?.objectId)!)
                            
                            // Query user that they are following is the current user
                            query.whereKey("following", equalTo: user.objectId!)
                            
                            // Search objects in the background
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let objects = objects {
                                    
                                    // Find relationship in the followers class
                                    if objects.count > 0 {
                                        
                                        self.isFollowing[user.objectId!] = true
                                        
                                    } else {
                                        
                                        self.isFollowing[user.objectId!] = false
                                        
                                    }
                                    
                                    // Reload data
                                    if self.isFollowing.count == self.usernames.count {
                                        
                                        self.tableView.reloadData()
                                        
                                        // When it is done, cancel the refresh
                                        self.refresher.endRefreshing()
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    // Shows navigationn bar back
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        refresh()
        
        refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        // When refresher is activated when refresh method
        refresher.addTarget(self, action: #selector(UserTableViewController.refresh), for: UIControlEvents.valueChanged)
        
        // Add refresher to the table
        tableView.addSubview(refresher)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Displays users in table
        cell.textLabel?.text = usernames[indexPath.row]
        
        // Check to see if the user is being followed or not
        if isFollowing[userIDs[indexPath.row]]! {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            
        }
        
        return cell
    }
 
    // Unfollow users function by de-selecting checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // A cell that is clicked
        let cell = tableView.cellForRow(at: indexPath)
        
        if isFollowing[userIDs[indexPath.row]]! {
            
            isFollowing[userIDs[indexPath.row]] = false
            
            // Unfollow users
            cell?.accessoryType = UITableViewCellAccessoryType.none
            
            let query = PFQuery(className: "CFollowers")
            
            query.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            query.whereKey("following", equalTo: userIDs[indexPath.row])
            
            query.findObjectsInBackground(block: { (objects, error) in
                
                if let objects = objects {
                    
                    for object in objects {
                        
                        object.deleteInBackground()
                        
                    }
                    
                }
                
            })
            
        } else {
            
            isFollowing[userIDs[indexPath.row]] = true
            
            // Add a check mark next to user name indicating they are following other users
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            
            let following = PFObject(className: "CFollowers")
            
            // Get current user
            following["follower"] = PFUser.current()?.objectId
            
            // Get user ID to following column
            following["following"] = userIDs[indexPath.row]
            
            following.saveInBackground()
            
        }
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
