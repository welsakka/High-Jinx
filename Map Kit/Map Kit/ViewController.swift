//
//  ViewController.swift
//  Map Kit
//
//  Created by Khaled Soliman on 5/17/20.
//  Copyright © 2020 TM Apps. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //setting zoom in perameter
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
            } else {
                //Add string showing it is off
        }
    }
    
    //goes through the checks of allowing location services
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
    
            
            //authorization for only app use
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
            
            //when they click deny send through here
        case .denied:
            //show alert how to turn on
            break
            
            //when person did not yet allow or deny
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
            //this is when parental controls on
        case .restricted:
            //show alert how to turn on
            break
            
            //we should never take location all the time
        case .authorizedAlways:
            break
            
            //think this for any case I forgot
        @unknown default:
            break
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    
    //this makes it so location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    //this is incase someone changes authorization after the fact
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
