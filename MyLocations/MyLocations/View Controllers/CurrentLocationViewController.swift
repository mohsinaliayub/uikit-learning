//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Mohsin Ali Ayub on 10.09.24.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    // MARK: Properties
    let locationManager = CLLocationManager()
    var location: CLLocation? {
        didSet {
            updateLabels()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
    }
    
    // MARK: Actions
    @IBAction func getLocation() {
        let authStatus = locationManager.authorizationStatus
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Helper Methods
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "Please enable location services for this app in Settings.",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
    
    func updateLabels() {
        guard let location else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap 'Get My Location' to Start"
            return
        }
        
        latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
        tagButton.isHidden = false
        messageLabel.text = ""
    }
}

// MARK: - Location Manager Delegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        location = newLocation
        print("didUpdateLocations: \(newLocation)")
    }
}
