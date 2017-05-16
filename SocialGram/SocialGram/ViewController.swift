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

    var signupMode = true
    
    // Spinner variable shows the app is still processing
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBOutlet weak var switchSingupMode: UIButton!
    
    // Alert function
    func alert(title: String, message: String) {
        
        // Control alert on the screen
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Create an alert
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            // Dismiss when user presses the button
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        // Displays the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func signupOrLogin(_ sender: AnyObject) {
        
        // Check if email or password is empty
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            alert(title: "Form error!", message: "Please enter an email and password")
            
        } else {
            
            // Set CG Rectangle to 50px of width and height
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            // Location of the indicator (spinner)
            activityIndicator.center = self.view.center
            
            // Hides indicator when it is stopped
            activityIndicator.hidesWhenStopped = true
            
            // Indicator with gray color
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            // Add new view to existing View Controller
            view.addSubview(activityIndicator)
            
            // Diplays indicator
            activityIndicator.startAnimating()
            
            // Stop other activities or user interact in the app
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if signupMode {
                
                // Sign up new account based on username/email and password working with Parse Server
                
                let user = PFUser()
                
                // Get data from text fields
                user.username = emailTextField.text
                user.email = emailTextField.text
                user.password = passwordTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    // After sign up process is finished, the indicator is stopped from running
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    // When the error is detected
                    if error != nil {
                        
                        // Displays an error
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        // If there is an error, then get error variable inside user info array
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.alert(title: "Signup Error", message: displayErrorMessage)
                        
                    } else {
                        
                        // New user is signed up
                        print("user signed up")
                        
                        // Show user table after user has signed up
                        self.performSegue(withIdentifier: "UserTable", sender: self)
                        
                    }
                    
                    
                })
                
                
            } else {
                
                // Login mode
                
                // No need to create user with all the fields again, PFUser class has a function for login with username
                PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
                    // Stops the indicator (spinner)
                    self.activityIndicator.stopAnimating()
                    
                    // Enable user interaction in the app
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            displayErrorMessage = errorMessage
                        }
                        self.alert(title: "Login Error", message: displayErrorMessage)
        
                    } else {
                        
                        print("Successfully logged in")
                        
                        // Showo user table when user has successfully logged in
                        self.performSegue(withIdentifier: "UserTable", sender: self)
                        
                    }
                })
            }
        }
    }
    
    // Login function
    @IBAction func switchSignupMode(_ sender: UIButton) {
        
        if signupMode {
            
            // Change to login mode
            signupOrLogin.setTitle("Log In", for: [])
            
            switchSingupMode.setTitle("Sign Up", for: [])
            
            MessageLabel.text = "Not having an account?"
            
            signupMode = false
        }
        else{
            
            // Change to signup mode
            signupOrLogin.setTitle("Sign Up", for: [])
            
            switchSingupMode.setTitle("Log In", for: [])
            
            MessageLabel.text = "Already have an account?"
            
            signupMode = true
        }
    }
    
    
    
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
    
    
    // When user is already logged in, then jumps to user table directly
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            performSegue(withIdentifier: "UserTable", sender: self)
        }
        
        // Hides navigation bar
        self.navigationController?.navigationBar.isHidden = true
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

