//
//  NetworkManager.swift
//  Trafficker
//
//  Created by Jacky Wong on 28/3/21.
//

import Foundation

enum HttpMethod: String {
    case get = "get"
    case post = "post"
}

let sgLTATrafficImagesURLString : String = "https://api.data.gov.sg/v1/transport/traffic-images"

class NetworkManager {
    
    static let shared = NetworkManager()
    
    
    
    func getTrafficDatas(_ withDate: Date = Date(), completion:@escaping (Data?, Error?) -> Void) -> Void {
        
        var request = URLRequest(url: URL(string:"\(sgLTATrafficImagesURLString)")!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = HttpMethod.get.rawValue
        
        let sessionTask = URLSession(configuration: .default).dataTask(with: request) { (data, response, error) in
            
            if (data != nil){
                completion (data, nil)
            }
            
            if (error != nil) {
                completion (nil,error!)
            }
        }
        sessionTask.resume()
    }
    
    func getTrafficImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
