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
    private var bgActivitySession: Any?
    private var trackingInvoked: Bool = false
    private let distanceThreshold: CLLocationDistance = 10.0
    
    @Published var lastLocation = CLLocation()
    @Published
    var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveLocationUpdatesStarted") {
        didSet {
            UserDefaults.standard.set(updatesStarted, forKey: "liveLocationUpdatesStarted")
        }
    }
    
    @Published
    var bgActivitySessionStarted: Bool = UserDefaults.standard.bool(forKey: "BGActivitySessionStarted") {
        didSet {
            if #available(iOS 17.0, *) {
                bgActivitySessionStarted ? self.bgActivitySession = CLBackgroundActivitySession(): (self.bgActivitySession as? CLBackgroundActivitySession)?.invalidate()
            }
            UserDefaults.standard.set(bgActivitySessionStarted, forKey: "BGActivitySessionStarted")
        }
    }
    
    private override init() {
        self.manager = CLLocationManager()
        super.init()
        if #unavailable(iOS 17.0) {
            manager.delegate = self
            manager.distanceFilter = 10
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false
        }
    }
    
    func startLocationUpdates() {
        if manager.authorizationStatus == .notDetermined {
            return
        }
        guard !trackingInvoked else {
            return
        }
        bgActivitySessionStarted = false
        updatesStarted = true
        trackingInvoked = true
        if #available(iOS 17.0, *) {
            startLiveLocationUpdates()
        } else {
            manager.startUpdatingLocation()
        }
        
    }
    
    func stopLocationUpdates() {
        self.updatesStarted = false
        self.trackingInvoked = false
        if #available(iOS 17.0, *) {
            bgActivitySessionStarted = false
            bgActivitySession = nil
        } else {
            manager.stopUpdatingLocation()
        }
    }
    
    @available(iOS 17.0, *)
    private func startLiveLocationUpdates() {
        
        Task {
            do {
                bgActivitySessionStarted = true
              
                let locationUpdates = CLLocationUpdate.liveUpdates()
                    .filter { [weak self] update in
                        guard let self = self else { return false }
                        let distanceMoved = (update.location?.distance(from: lastLocation) ?? 0.0)
                        let hasLastLocation = lastLocation.coordinate.latitude != 0 && lastLocation.coordinate.longitude != 0

                        return distanceMoved >= distanceThreshold || !hasLastLocation
                    }

                for try await update in locationUpdates {
                    if !self.updatesStarted { break }
                    if let currentLocation = update.location {
                        onLocationChanged(location: currentLocation)
                        if update.isStationary { break }
                    }
                    
                }
            } catch {
                print("Error with live updates: \(error.localizedDescription)")
            }
        }
    }
    
    private func onLocationChanged(location: CLLocation) {
        let lastUpdateTime = lastLocation.timestamp
        let hasLastLocation = lastLocation.coordinate.latitude != 0 && lastLocation.coordinate.longitude != 0
        let timeInterval = Date().timeIntervalSince(lastUpdateTime)
        if (timeInterval >= 10 || !hasLastLocation) && lastLocation != location {
            lastLocation = location
        }
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
        onLocationChanged(location: currentLocation)
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
