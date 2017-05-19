//
//  PostImageViewController.swift
//  SocialGram
//
//  Created by HONG LY on 5/16/17.
//  Copyright © 2017 HONG LY. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imgPost: UIImageView!
    @IBOutlet weak var msgTextField: UITextField!
    
    var soundPlayer: AVAudioPlayer?
    var elapsedTime: TimeInterval = 0
    
    @IBAction func selectAnImage(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        
        // Get image from Photo Library rather than camera
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        // Not allowed image editing
        imagePickerController.allowsEditing = false
        
        // Nothing happens when image is presented
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Check the existence of image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Set image to post
            imgPost.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

    func alert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func postImage(_ sender: Any) {
        
        // Stop other activities or user interact in the app
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Location to store the images on Server
        let post = PFObject(className: "Posts")
        
        // Get user message from text field to the server
        post["message"] = msgTextField.text
        
        // Get current user id from object id to the server
        post["userId"] = PFUser.current()?.objectId!
        
        // Get image from imgPost variable
        let imageData = UIImagePNGRepresentation(imgPost.image!)
        
        // Save image on Parse server as a Parse file
        let imageFile = PFFile(name: "image.png", data: imageData!)
        
        post["imageFile"] = imageFile
        
        post.saveInBackground { (success, error) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            // Check error
            if error != nil {
                
                self.alert(title: "Could not post image", message: "Please try again later")
                
            } else {
                
                // Successfully posted image
                self.alert(title: "Image Posted!", message: "Your image has been posted successfully")
                
                // Set message text field to empty
                self.msgTextField.text = ""
                
                // Set image back to original one
                self.imgPost.image = UIImage(named: "socialgram.png")
                
            }
            
        }
    }
    
    // Play or resume music button
    @IBAction func playMusic(_ sender: UIButton) {
        // play and resume
        if soundPlayer != nil{
            soundPlayer!.currentTime = elapsedTime
            soundPlayer!.play()
        }
    }
    
    // Pause music button
    @IBAction func pauseMusic(_ sender: UIButton) {
        if soundPlayer != nil{
            elapsedTime = soundPlayer!.currentTime
            soundPlayer!.pause()
        }
    }
    
    // Stop music button
    @IBAction func stopMusic(_ sender: UIButton) {
        if soundPlayer != nil{
            soundPlayer!.stop()
            elapsedTime = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // URL of the Song name and type
        let path = Bundle.main.path(forResource: "carefree", ofType: "mp3")
        
        // Get audio session to play in background
        let session = AVAudioSession.sharedInstance()
        
        let url = URL(fileURLWithPath: path!)
        
        do {
            // set up the player by loading the sound file
            try soundPlayer = AVAudioPlayer(contentsOf: url)
        }
            // catch the error if playback fails
        catch { print("file not availalbe")}
        
        do {
            // Play music in background
            // This will only allow music to play in background when user locks the screen or touch the home button. However, when user switch to other segues, the music will not play. The feature that allows music to be played in the whole app will be implemented in next version. 
            try session.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch { print("error playing music in background")}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
