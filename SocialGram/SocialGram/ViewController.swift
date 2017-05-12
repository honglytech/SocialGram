//
//  ViewController.swift
//  SocialGram
//
//  Created by HONG LY on 4/28/17.
//  Copyright © 2017 HONG LY. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // Spinner variable shows the app is still processing
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    
    /*
    // Get the image to Image View
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Returns image itself
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            imageView.image = image
        }
        else{
            print("Error in getting the image")
        }
        
        // Closes Image Picker Controller
        self.dismiss(animated: true, completion: nil)
    }
    */
     
    // Get image from Camera Roll
    @IBAction func importImage(_ sender: UIButton) {
        
        /*
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        // Get image from Photo Library rather than camera
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        // Not allowed image editing
        imagePickerController.allowsEditing = false
        
        // Nothing happens when image is presented
        self.present(imagePickerController, animated: true, completion: nil)
        */
    }
    
    // Alert function
    @IBAction func alert(_ sender: UIButton) {
        
        // Control and display alert on the screen
        let alertController = UIAlertController(title: "Hi", message: "Are you sure?", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            print("button pressed")
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
            print("No button pressed")
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        // Displays the alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Pause app function using Spinner
    @IBAction func pause(_ sender: UIButton) {
        
        // Set CG Rectangle to 50px of width and height
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        // Location
        activityIndicator.center = self.view.center
        
        // Hides indicator when it is stopped
        activityIndicator.hidesWhenStopped = true
        
        // Indicator style with gray color
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        // Add new view to existing View Controller
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        // Stop other activities or user interact in the app
        //UIApplication.shared.beginIgnoringInteractionEvents()
        
        
    }
    
    // Stop Indicator function
    @IBAction func restore(_ sender: UIButton) {
        activityIndicator.stopAnimating()
        
        // Enable user interaction to use the app again
        //UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /*
        let testObject = PFObject(className: "TestObject3")
        
        testObject["foo"] = "bar"
        
        testObject.saveInBackground { (success, error) -> Void in
            
            if success {
                
                print("Object has been saved.")
                
            } else {
                
                if error != nil {
                    
                    print (error)
                    
                } else {
                    
                    print ("Error")
                }
                
            }
            
        }
        */
        
        /*
        // get & update data from server
        let query = PFQuery(className: "Users")
        
        // get object
        query.getObjectInBackground(withId: "FlmMnJgfI1"){
            (object, error) in
            
            if error != nil {
                print(error)
            }
            else{
                if let user = object{
                    /*
                    print(user)
                    print(user["name"])
                    */
         
                    /*
                    //update data
                    user["name"] = "hong"
                    user.saveInBackground(block: { (success, error) in
                        if success {
                            print("saved")
                        }
                        else {
                            print("error")
                        }
                    })
                    */
                }
            }
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

