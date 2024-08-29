import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {

    var geofencePlugin: GeofenceService?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        let key = Bundle.main.object(forInfoDictionaryKey: "ApiMapKey")
        GMSServices.provideAPIKey(key as! String)

        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let geofenceChannel = FlutterMethodChannel(name: "geofence_plugin", binaryMessenger: controller.binaryMessenger)

        geofencePlugin = GeofenceService(channel: geofenceChannel)

        geofenceChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            if call.method == "startMonitoring" {
                if let args = call.arguments as? [String: Any],
                   let lat  = args["latitude"] as? Double,
                   let lng = args["longitude"] as? Double,
                   let radius = args["radius"] as? Double,
                   let id = args["identifier"] as? String {
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    self.geofencePlugin?.startMonitoring(center: center, radius: radius, identifier: id)
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

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
