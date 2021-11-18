//
//  ViewController.swift
//  MobileMapperFall2021
//
//  Created by Christopher Walter on 11/18/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate
{
    var currentLocation: CLLocation!
    
    let locationManager = CLLocationManager()
    
    var parks: [MKMapItem] = []

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        currentLocation = locations[0]
        
    }

    
    @IBAction func whenZoomTapped(_ sender: UIBarButtonItem)
    {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func whenSearchTapped(_ sender: UIBarButtonItem)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Taco"

        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start {
            response, error in
            guard let response = response else {
                print("No response found")
                return
            }
            print(response)
            for mapItem in response.mapItems
            {
                self.parks.append(mapItem)
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            }
            
            
            
        }
        
    }
    
}

