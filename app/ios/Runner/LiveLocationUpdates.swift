//
//  LiveLocationUpdates.swift
//  Runner
//
//  Created by Ishita on 16/12/24.
//

import Foundation
import CoreLocation

@available(iOS 17.0, *)
class LiveLocationUpdates {
    static let shared = LiveLocationUpdates()
    private var previousLocation: CLLocation? = nil
    private let distanceThreshold: CLLocationDistance = 150.0
    
    private var backgroundActivity: CLBackgroundActivitySession?
    
    @Published var lastLocation = CLLocation()
    
    func startLocationUpdate() {
        Task {
            do {
                self.backgroundActivity = CLBackgroundActivitySession()
                
                let locationUpdates = CLLocationUpdate.liveUpdates(.fitness)
                for try await update in locationUpdates {
                    if let currentLocation = update.location {
                        self.handleLocationUpdate(currentLocation, isStationary: update.isStationary)
                    }
                }
            } catch {
                debugPrint("An error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleLocationUpdate(_ currentLocation: CLLocation, isStationary: Bool) {
        if previousLocation == nil {
            previousLocation = currentLocation
            lastLocation = currentLocation
            return
        }
        
        if let previousLocation = previousLocation {
            let distanceMoved = currentLocation.distance(from: previousLocation)
            if distanceMoved >= distanceThreshold || isStationary {
                self.previousLocation = currentLocation
                self.lastLocation = currentLocation
            }
        }
    }
}
