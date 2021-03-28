//
//  TrafficCamera.swift
//  Trafficker
//
//  Created by Jacky Wong on 28/3/21.
//

import Foundation
import MapKit

class TrafficCamera: NSObject, MKAnnotation {
    
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    let imageURLString: String?
    
    init(title: String?, locationName: String?, camera: Camera) {
        
        self.title = title
        self.locationName = locationName
        
        self.imageURLString = camera.image
        self.coordinate = CLLocationCoordinate2D(latitude: camera.location.latitude,
                                                 longitude: camera.location.longitude)
        
        super.init()
    }
    
}
