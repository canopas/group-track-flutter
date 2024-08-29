//
//  GeofencePlugin.swift
//  Runner
//
//  Created by Ishita on 27/08/24.
//

import Foundation
import CoreLocation
import Flutter
import UIKit

class GeofenceService: NSObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager!
    private var channel: FlutterMethodChannel?
    
    init(channel: FlutterMethodChannel? = nil) {
        super.init()
        self.locationManager = CLLocationManager()
        self.channel = channel
        self.locationManager.delegate = self
    }
    
    func startMonitoring(center: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        self.locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(identifier: String) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion, circularRegion.identifier == identifier {
                self.locationManager.stopMonitoring(for: region)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            channel?.invokeMethod("onEnterGeofence", arguments: ["identifier": circularRegion.identifier])
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            channel?.invokeMethod("onExitGeofence", arguments: ["identifier": circularRegion.identifier])
        }
    }
}
