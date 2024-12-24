//
//  UnifiedLocationManager.swift
//  Runner
//
//  Created by Radhika S on 17/12/24.
//


import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    private var manager: CLLocationManager
    private var trackingInvoked: Bool = false
    private let distanceThreshold: CLLocationDistance = 10.0
    
    @Published var lastLocation = CLLocation()
  
    private override init() {
        self.manager = CLLocationManager()
        super.init()
        manager.delegate = self
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
    }
    
    func startLocationUpdates() {
        if manager.authorizationStatus == .notDetermined {
            return
        }
        guard !trackingInvoked else {
            return
        }
        trackingInvoked = true
        manager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        self.trackingInvoked = false
        manager.stopUpdatingLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            startLocationUpdates()
        } else {
            stopLocationUpdates()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let lastUpdateTime = lastLocation.timestamp
        let hasLastLocation = lastLocation.coordinate.latitude != 0 && lastLocation.coordinate.longitude != 0
        let timeInterval = Date().timeIntervalSince(lastUpdateTime)
        if (timeInterval >= 10 || !hasLastLocation) && lastLocation != currentLocation {
            lastLocation = currentLocation
        }
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
