//
//  LiveLocationUpdates.swift
//  Runner
//
//  Created by Ishita on 16/12/24.
//

import Foundation
import CoreLocation

class LiveLocationUpdates {
    static let shared = LiveLocationUpdates()
    private var previousLocation: CLLocation? = nil
    private let distanceThreshold: CLLocationDistance = 150.0
    
    @Published var lastLocation = CLLocation()
    
    @available(iOS 17.0, *)
    func startLocationUpdate() {
        Task {
            do {
                let locationUpdates = CLLocationUpdate.liveUpdates(.fitness)
                for try await update in locationUpdates {
                    if let currentLocation = update.location {
                        if previousLocation == nil {
                            previousLocation = currentLocation
                            lastLocation = currentLocation
                            continue
                        }
                        
                        if let previousLocation = previousLocation {
                            let distanceMoved = currentLocation.distance(from: previousLocation)
                            if distanceMoved >= distanceThreshold || update.isStationary {
                                self.previousLocation = currentLocation
                                self.lastLocation = currentLocation
                            }
                        }
                        
                        if update.isStationary { break }
                    }
                }
            } catch {
                debugPrint("An error occurred: \(error.localizedDescription)")
            }
        }
    }
}
