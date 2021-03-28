//
//  CodableObjs.swift
//  Trafficker
//
//  Created by Jacky Wong on 28/3/21.
//

import Foundation

struct Response: Codable {
    
    struct Item: Codable {
        var cameras: [Camera]
        var timestamp: String
    }
    
    var items: [Item]
}

struct Camera: Codable {
    var timestamp: String
    var image: String
    var location: Location
    var camera_id: String
    
//    var image_metadata: ImageMetaData
    
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double
}

struct ImageMetaData {
    var height: Int
    var width: Int
    var md5: String
}
