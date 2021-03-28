//
//  ViewController.swift
//  Trafficker
//
//  Created by Jacky Wong on 28/3/21.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    private let sgLat = 1.3521
    private let sgLong = 103.8198
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let sgInitialLocation = CLLocation(latitude: sgLat,
                                           longitude: sgLong)
        
        centerMapOnLocation(sgInitialLocation)
        
        
    }
    
    // Map func
    func centerMapOnLocation(_ location: CLLocation) {
        
        // Size of Singapore ~ 728 * 1000
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 50.0,
                                                  longitudinalMeters: regionRadius * 50.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

