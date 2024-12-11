//
//  LocationManager.swift
//  Runner
//
//  Created by Radhika S on 04/12/24.
//

import CoreLocation

class LocationsHandler: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationsHandler()
    private let manager: CLLocationManager
    
    @Published var lastLocation = CLLocation()
    
    @Published
    var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveLocationUpdatesStarted") {
        didSet {
            UserDefaults.standard.set(updatesStarted, forKey: "liveLocationUpdatesStarted")
        }
    }
    
    private override init() {
        self.manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }
    
    func startLocationUpdates() {
        if self.manager.authorizationStatus == .notDetermined {
            print("startLocationUpdates: permission notDetermined")
            return
        }
        updatesStarted = true
        print("startLocationUpdates: startUpdatingLocation......")
        manager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        manager.stopUpdatingLocation()
        updatesStarted = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            updatesStarted = true
            self.manager.startUpdatingLocation()
        } else {
            updatesStarted = false
            self.manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        
        let lastUpdateTime = lastLocation.timestamp
        
        let timeInterval = Date().timeIntervalSince(lastUpdateTime)
        if timeInterval < 10 {
            return
        }
        
        print("Got location update: \(currentLocation.coordinate.latitude):\(currentLocation.coordinate.longitude)")
        
        lastLocation = currentLocation
    }
    
    func getCurrentLocation(result: @escaping FlutterResult) {
        guard let location = self.manager.location else {
            result(FlutterError(code: "LOCATION_ERROR", message: "Location data not available", details: nil))
            return
        }
        
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": location.timestamp.timeIntervalSince1970 * 1000
        ]
        result(locationData)
    }
}
