//
//  FeedTableViewController.swift
//  SocialGram
//
//  Created by HONG LY on 5/16/17.
//  Copyright © 2017 HONG LY. All rights reserved.
//

import UIKit
import Parse

class FeedTableViewController: UITableViewController {

    // Store unique username from user id
    var users = [String: String]()
    
    var messages = [String]()
    var usernames = [String]()
    
    // Store image files
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            // If get some user objects
            if let users = objects {
                
                // Avoid loading twice
                self.users.removeAll()
                
                // Loop through the array users
                for object in users {
                    
                    // Cast each item in the array to PFUser
                    if let user = object as? PFUser {
                        
                        // Add to user dictionary using object id
                        self.users[user.objectId!] = user.username!
                        
                    }
                }
                
            }
            
            let getFollowedUsersQuery = PFQuery(className: "CFollowers")
            
            // Get all of the followers from server well. However, when there are thousands of users, the app will not handle such a large numbers of users since the codes below try to loop through each user's posts everytime. Therefore, the more users, the more time comsuing and more likely to get error since the app will loop all users' posts. 
            getFollowedUsersQuery.whereKey("follower", equalTo: (PFUser.current()?.objectId!)!)
            
            getFollowedUsersQuery.findObjectsInBackground(block: { (objects, error) in
                
                if let followers = objects {
                    
                    for follower in followers {
                        
                            // Get users that are following
                            let followedUser = follower["following"] as! String
                            
                            // Get all posts from class post
                            let query = PFQuery(className: "Posts")
                            
                            // Look for all posts that were posted by the user
                            query.whereKey("userId", equalTo: followedUser)
                            
                            query.findObjectsInBackground(block: { (objects, error) in
                                
                                if let posts = objects {
                                    
                                    for post in posts {
                                        
                                            // Retrieve messages
                                            self.messages.append(post["message"] as! String)
                                            
                                            // Retrieve image files
                                            self.imageFiles.append(post["imageFile"] as! PFFile)
                                            
                                            // Get usernames from user id
                                            self.usernames.append(self.users[post["userId"] as! String]!)
                                            
                                            // Update and reload the table
                                            self.tableView.reloadData()
                                        
                                    }
                                }
                            })
                    }
                }
            })
        })
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
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        
        // Retrieve image files from Parse Server
        imageFiles[indexPath.row].getDataInBackground { (data, error) in
            
            // Check if there are images on the server
            if let imageData = data {
                
                if let downloadedImage = UIImage(data: imageData) {
                    
                    cell.postedImage.image = downloadedImage
                    
                }
                
            }
            
        }
        
        // default image
        cell.postedImage.image = UIImage(named: "socialgram.png")
        
        cell.usernameLabel.text = usernames[indexPath.row]
        
        cell.messageLabel.text = messages[indexPath.row]
        
        return cell
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
