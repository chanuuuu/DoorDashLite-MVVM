//
//  AddressViewController.swift
//  DoorDash_Lite
//
//  Created by chanikya on 6/4/18.
//  Copyright © 2018 chanikya. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class AddressViewController: UIViewController  {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var selectedAddress: UILabel!
    
    let locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D(latitude: 51.50007773,
                                          longitude: -0.1246402)       // Default Location to center the region when user's location is not available
    var annotation = MKPointAnnotation()
    var isLocationIdentified = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Choose an Address"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        self.mapView.delegate = self

        // For use when the app is open & in background
        locationManager.requestWhenInUseAuthorization()
        
        // If location services is enabled get the users location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver food we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getAddressFromLatLon(latitude: Double, longitude: Double) {
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:latitude, longitude: longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                guard let pm = placemarks else {
                    self.selectedAddress.text = "Address not found"
                    return
                }
                //let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality!  // + ", "
                    }
//                    if pm.country != nil {
//                        addressString = addressString + pm.country! + ", "
//                    }
//                    if pm.postalCode != nil {
//                        addressString = addressString + pm.postalCode! + " "
//                    }
                    self.selectedAddress.text = addressString
                }
        })
    }
    
    @IBAction func confirmAddressButtonPressed(_ sender: Any) {
        // Saving the selected latitude and longitude in the UserDefaults
        UserDefaults.standard.set(["latitude": annotation.coordinate.latitude, "longitude" : annotation.coordinate.longitude], forKey: "selectedAddress")
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddressViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // If no address was selected, use device's location to center the region of the map
        if !self.isLocationIdentified {
            if let location = locations.first {
                userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                      longitude: location.coordinate.longitude)
                
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegion(center: userLocation, span: span)
                mapView.setRegion(region, animated: true)
                
                annotation.coordinate = userLocation
                mapView.addAnnotation(annotation)
                self.isLocationIdentified = true
            }
        }
    }
    
    // If access denied give the user option to change it
    func locationManager(_ _manager: CLLocationManager, didChangeAuthorization status : CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
}

extension AddressViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Always add annotation at the center of the region and remove previous center's annotation
        let centre = mapView.region.center
        mapView.removeAnnotation(self.annotation)
        annotation.coordinate = centre
        mapView.addAnnotation(annotation)
        self.getAddressFromLatLon(latitude: centre.latitude, longitude: centre.longitude)
    }
}
