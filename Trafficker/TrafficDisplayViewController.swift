//
//  TrafficDisplayViewController.swift
//  Trafficker
//
//  Created by Jacky Wong on 28/3/21.
//

import UIKit

class TrafficDisplayViewController: UIViewController {
    
    @IBOutlet var lastRefreshedLabel: UILabel!
    @IBOutlet var trafficImageView: UIImageView!
    
    var imageUrlString = ""
    
    let localDateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        
        return formatter
    }()
    
    private var _lastRefreshed: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        downloadImage(from: imageUrlString)
    }
    
    func updateLabelToCurrentTime() {


        // Printing a Date
        let date = Date()
        let currentDate = localDateFormatter.string(from: date)
        lastRefreshedLabel.text = "Last updated at: \n \(currentDate)"
    }
    
    func downloadImage(from urlString: String) {
        
        guard let url = URL(string: imageUrlString) else {
            return
        }
        
        print("Image download start")
        NetworkManager.shared.getTrafficImage(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Image downloaded")
            DispatchQueue.main.async() { [weak self] in
                self?.trafficImageView.image = UIImage(data: data)
                self?.updateLabelToCurrentTime()
            }
        }
    }
    
    @IBAction func refreshImage(_ sender: UIButton) {
        let diff = Date().timeIntervalSince1970 - _lastRefreshed
        let paused = Int(60 - diff)
        guard diff > 60 else {
            
            let alert = UIAlertController(title: "Oops",
                                          message: "You're refreshing too frequently, please try again in \(paused) seconds.",
                                          preferredStyle: .alert)
            
            let dismiss = UIAlertAction(title: "Okay", style: .default)
            
            alert.addAction(dismiss)
            present(alert, animated: true)
            
            return
            
        }
        _lastRefreshed = Date().timeIntervalSince1970
        downloadImage(from: imageUrlString)
    }
    
}
