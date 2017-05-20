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
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var MessageLabel: UILabel!
    
    @IBOutlet weak var signupOrLogin: UIButton!
    
    @IBOutlet weak var switchSignupMode: UIButton!
    
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
    
    // Switch between signup and login buttons 
    @IBAction func switchSignupMode(_ sender: UIButton) {
        
        if signupMode {
            
            // Change to login mode
            signupOrLogin.setTitle("Log In", for: [])
            
            switchSignupMode.setTitle("Sign Up", for: [])
            
            MessageLabel.text = "Not having an account?"
            
            signupMode = false
        }
        else{
            
            // Change to signup mode
            signupOrLogin.setTitle("Sign Up", for: [])
            
            switchSignupMode.setTitle("Log In", for: [])
            
            MessageLabel.text = "Already have an account?"
            
            signupMode = true
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        // Hides navigation bar
        self.navigationController?.navigationBar.isHidden = true
    }
 
    func dismissKeyboard() {
        // Ends editing on the text field by bringing the keyboard down
        view.endEditing(true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Look for gesture that taps anywhere on the screen and dismiss the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

