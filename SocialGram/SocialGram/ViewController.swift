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

    @IBOutlet weak var imageView: UIImageView!
    
    
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
    
    // Get image from Camera Roll
    @IBAction func importImage(_ sender: UIButton) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        // Get image from Photo Library rather than camera
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        // Not allowed image editing
        imagePickerController.allowsEditing = false
        
        // Nothing happens when image is presented
        self.present(imagePickerController, animated: true, completion: nil)
        
        
        
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

