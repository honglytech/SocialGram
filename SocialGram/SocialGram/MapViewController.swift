//
//  MapViewController.swift
//  SocialGram
//
//  Created by HONG LY on 5/18/17.
//  Copyright © 2017 HONG LY. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Declare CLLocationManger to get current user's location
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        // Set an accuracy level to the highest one
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Request user for authorization to use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        // Start location updates
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = manager.location?.coordinate{
            
            // Get location details from latitude and longitude
            let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            // This is the region showing on the map with latitudeDelta and longtitudeDelta 0.02 refers how close the map will zoom in
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
            self.map.setRegion(region, animated: true)
            
            // Clear annotations or it will appear every time user change location
            self.map.removeAnnotations(self.map.annotations)
            
            // Adding an annotation to show where the current user is
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = location
            
            // Annotation title that allows user to show the title when the user press on the annotation pin
            annotation.title = "Your current location"
            
            self.map.addAnnotation(annotation)
        }
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
