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
    
    let mapSegue = "mapSegue"
    let camIdentifier = "cameraId"
    
    var cameras: [Camera] = [Camera]() {
        didSet {
            var trafficCams = [TrafficCamera]()
            
            for camera in cameras {
                // add map annotation
                let annotation = TrafficCamera(title: "Title",
                                               locationName: "LocationName",
                                               camera: camera)
                trafficCams.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mapView.addAnnotations(trafficCams)
            }
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let sgInitialLocation = CLLocation(latitude: sgLat,
                                           longitude: sgLong)
        
        centerMapOnLocation(sgInitialLocation)
        
        NetworkManager.shared.getTrafficDatas {(data, error) in
            if let data = data {
                
                if let response = try? JSONDecoder().decode(Response.self, from: data) {
                    
                    if let item = response.items.first {
                        self.cameras = item.cameras
                    }
                }
            }
        }
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let imageURL = sender as? String,
           segue.identifier == mapSegue,
           let vc = segue.destination as? TrafficDisplayViewController {
            
            vc.imageUrlString = imageURL
            
        }
    }
    
    
}

// MARK:- MapView Delegate and funcs
extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? TrafficCamera else {
            return nil
        }
        
        
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: camIdentifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: camIdentifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(#function)
        
        guard let _ = view.rightCalloutAccessoryView, let camera = view.annotation as? TrafficCamera else {
            return
        }
        
        self.performSegue(withIdentifier: mapSegue, sender: camera.imageURLString)
        
    }
}
