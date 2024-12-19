import CoreLocation
import FirebaseMessaging
import Flutter
import GoogleMaps
import CoreLocation
import Combine

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    var geofencePlugin: GeofenceService?
    var lastUpdateTime: Date?
    private var cancellables = Set<AnyCancellable>()
    
    override func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate =
            self as UNUserNotificationCenterDelegate
        }
        
        let key = Bundle.main.object(forInfoDictionaryKey: "ApiMapKey")
        GMSServices.provideAPIKey(key as! String)
        
        getLocationMethodRegistration()
        geofencePluginRegistration()
        registerLocationChannel()
        
        if #available(iOS 17.0, *) {
            let liveLocationUpdates = LiveLocationUpdates.shared
            
            liveLocationUpdates.startLocationUpdate()
            
            liveLocationUpdates.$lastLocation.sink(receiveValue: { [weak self] location in
                self?.sendLocationToFlutter(location: location)
            }).store(in: &cancellables)
        } else {
            let locationsHandler = LocationsHandler.shared
            if locationsHandler.updatesStarted {
                locationsHandler.startLocationUpdates()
            }
            locationsHandler.$lastLocation.sink(receiveValue: { [weak self] location in
                self?.sendLocationToFlutter(location: location)
            }).store(in: &cancellables)
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func getLocationMethodRegistration() {
        let controller: FlutterViewController =
        window?.rootViewController as! FlutterViewController
        let locationChannel = FlutterMethodChannel(
            name: "com.grouptrack/current_location",
            binaryMessenger: controller.binaryMessenger)
        
        locationChannel.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            
            if call.method == "getCurrentLocation" {
                LocationsHandler.shared.getCurrentLocation(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    func sendLocationToFlutter(location: CLLocation) {
        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude,
            "timestamp": location.timestamp.timeIntervalSince1970 * 1000,
        ]
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let controller = self.window?.rootViewController as? FlutterViewController {
                let methodChannel = FlutterMethodChannel(name: "com.grouptrack/location", binaryMessenger: controller.binaryMessenger)
                methodChannel.invokeMethod("onLocationUpdate", arguments: locationData)
            }
        }
    }
}

// Geofence methods
extension AppDelegate {
    private func registerLocationChannel() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "com.grouptrack/location", binaryMessenger: controller.binaryMessenger
        )
        
        channel.setMethodCallHandler { [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard self != nil else { return }
            if call.method == "startTracking" {
                LocationsHandler.shared.startLocationUpdates()
                result(true)
            } else if call.method == "stopTracking" {
                LocationsHandler.shared.stopLocationUpdates()
                result(true)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func geofencePluginRegistration() {
        let controller: FlutterViewController =
        window?.rootViewController as! FlutterViewController
        let geofenceChannel = FlutterMethodChannel(
            name: "geofence_plugin", binaryMessenger: controller.binaryMessenger
        )
        
        geofencePlugin = GeofenceService(channel: geofenceChannel)
        
        geofenceChannel.setMethodCallHandler { [weak self]
            (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            if call.method == "startMonitoring" {
                if let args = call.arguments as? [String: Any],
                   let lat = args["latitude"] as? Double,
                   let lng = args["longitude"] as? Double,
                   let radius = args["radius"] as? Double,
                   let id = args["identifier"] as? String {
                    let center = CLLocationCoordinate2D(
                        latitude: lat, longitude: lng)
                    self.geofencePlugin?.startMonitoring(
                        center: center, radius: radius, identifier: id)
                    result(nil)
                }
            } else if call.method == "stopMonitoring" {
                if let args = call.arguments as? [String: Any],
                   let id = args["identifier"] as? String {
                    self.geofencePlugin?.stopMonitoring(identifier: id)
                    result(nil)
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
