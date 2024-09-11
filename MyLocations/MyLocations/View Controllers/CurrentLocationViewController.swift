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
    var updatingLocation = false
    var lastLocationError: Error?
    
    // Reverse Geocoding
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?

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
        
        if updatingLocation {
            stopLocationManager()
            updateLabels()
        } else {
            lastGeocodingError = nil
            placemark = nil
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
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
        configureGetButton()
        guard let location else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            updateStatusMessage()
            return
        }
        
        latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
        longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
        tagButton.isHidden = false
        messageLabel.text = ""
        updateAddressLabel()
        
        func updateAddressLabel() {
            if let placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
        }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        // housenumber
        if let tmp = placemark.subThoroughfare {
            line1 += tmp + " "
        }
        // street name
        if let tmp = placemark.thoroughfare {
            line1 += tmp
        }
        
        var line2 = ""
        // city
        if let tmp = placemark.locality {
            line2 += tmp + " "
        }
        // state or province
        if let tmp = placemark.administrativeArea {
            line2 += tmp + " "
        }
        // postal code
        if let tmp = placemark.postalCode {
            line2 += tmp + " "
        }
        
        return line1 + "\n" + line2
    }
    
    func updateStatusMessage() {
        let statusMessage: String
        if let error = lastLocationError as? NSError {
            if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                statusMessage = "Location Services Disabled"
            } else {
                statusMessage = "Error Getting Location"
            }
        } else if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            statusMessage = "Location Services Disabled"
        } else if updatingLocation {
            statusMessage = "Searching..."
        } else {
            statusMessage = "Tap 'Get My Location' to Start"
        }
        
        messageLabel.text = statusMessage
    }
    
    func configureGetButton() {
        let title = updatingLocation ? "Stop" : "Get My Location"
        getButton.setTitle(title, for: .normal)
    }
    
    // MARK: Location Manager
    
    func startLocationManager() {
        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways else { return }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        updatingLocation = true
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }
}

// MARK: - Location Manager Delegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("didFailWithError: \(error.localizedDescription)")
        
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocations: \(newLocation)")
        
        // cached result - discard it.
        if newLocation.timestamp.timeIntervalSinceNow < -5 { return }
        
        // accuracy less than 0 means an invalid measurement - discard it.
        if newLocation.horizontalAccuracy < 0 { return }
        
        // if there's no previous reading, save it.
        // if there's a previous reading and new reading is more accurate than the previous one. Save it.
        // greater horizontal accuracy means a less accurate result. 100 meters is worse than 10 meters.
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            // new location's accuracy is equal to or better than the desired accuracy, stop location updates.
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("** We're done! **")
                stopLocationManager()
                reverseGeocodeLocation(newLocation)
            }
            
            // clear the last error and save it.
            lastLocationError = nil
            location = newLocation
        }
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        guard !performingReverseGeocoding else { return }
        
        print("** Going to geocode")
        performingReverseGeocoding = true
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            self.lastGeocodingError = error
            if error == nil, let places = placemarks, !places.isEmpty {
                self.placemark = places.last
            } else {
                self.placemark = nil
            }
            
            self.performingReverseGeocoding = false
            self.updateLabels()
        }
    }
}
