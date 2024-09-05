package com.canopas.yourspace

import android.Manifest
import android.app.PendingIntent
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.Geofence.GEOFENCE_TRANSITION_ENTER
import com.google.android.gms.location.Geofence.GEOFENCE_TRANSITION_EXIT
import com.google.android.gms.location.GeofencingClient
import com.google.android.gms.location.GeofencingRequest
import com.google.android.gms.location.LocationServices
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await

class MainActivity : FlutterFragmentActivity() {
    private val channel = "geofence_plugin"
    private val engine = "geofence_engine"
    private lateinit var methodChannel: MethodChannel

    private lateinit var geofencingClient: GeofencingClient
    private val geofences = mutableMapOf<String, Geofence>()

    private val geofencePendingIntent: PendingIntent by lazy {
        val intent = Intent(this, GeofenceBroadcastReceiver::class.java)
        PendingIntent.getBroadcast(
            this,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        FlutterEngineCache.getInstance().put(engine, flutterEngine)
        geofencingClient = LocationServices.getGeofencingClient(this)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startMonitoring" -> {
                    CoroutineScope(Dispatchers.IO).launch { deregisterGeofence() }
                    CoroutineScope(Dispatchers.IO).launch { delay(1000) }

                    val locations = call.argument<List<Map<String, Any>>>("locations")
                    if (locations != null) {
                        val locationDataList = locations.map { locationMap ->
                            LocationData(
                                latitude = locationMap["latitude"] as Double,
                                longitude = locationMap["longitude"] as Double,
                                radius = locationMap["radius"] as Double,
                                identifier = locationMap["identifier"] as String
                            )
                        }
                        addGeofences(locationDataList)
                        result.success(true)
                    } else {
                        result.error("Invalid Arguments", "Locations data is null", null)
                    }
                }

                "stopMonitoring" -> {
                    val identifier = call.argument<String>("identifier")
                    if (identifier != null) {
                        stopGeofenceMonitoring(identifier)
                        result.success(true)
                    } else {
                        result.error("Invalid Arguments", "Identifier is null", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun addGeofences(places: List<LocationData>) {
        places
            .filterNot { apiPlace -> apiPlace.latitude == 0.0 || apiPlace.longitude == 0.0 || apiPlace.radius == 0.0 }
            .forEach { apiPlace ->
                val key = apiPlace.identifier
                val geofence = createGeofences(key, apiPlace)
                geofences[key] = geofence
            }
        registerGeofence()
    }

    private fun createGeofences(
        key: String,
        place: LocationData,
    ): Geofence {
        return Geofence.Builder()
            .setRequestId(key)
            .setCircularRegion(place.latitude, place.longitude, place.radius.toFloat())
            .setTransitionTypes(GEOFENCE_TRANSITION_ENTER or GEOFENCE_TRANSITION_EXIT)
            .setExpirationDuration(Geofence.NEVER_EXPIRE)
            .build()
    }

    private fun registerGeofence() {
        if (geofences.isEmpty()) return

        val request = GeofencingRequest.Builder().also { request ->
            request.setInitialTrigger(GeofencingRequest.INITIAL_TRIGGER_ENTER)
            request.addGeofences(geofences.values.toList())
        }.build()

        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        geofencingClient.addGeofences(request, geofencePendingIntent).run {
            addOnSuccessListener {
                Log.d("MainActivity", "RegisterGeofence: Success")
            }
            addOnFailureListener {
                Log.d("MainActivity", "RegisterGeofence: Failed")
            }
        }
    }

    private suspend fun deregisterGeofence() = kotlin.runCatching {
        geofencingClient.removeGeofences(geofences.keys.toList()).await()
        geofences.clear()
    }

    private fun stopGeofenceMonitoring(identifier: String) {
        val geofenceIds = listOf(identifier)
        geofencingClient.removeGeofences(geofenceIds)
            .addOnSuccessListener {
                Log.d("MainActivity", "Geofence with ID $identifier removed successfully.")
                geofences.remove(identifier)
            }
            .addOnFailureListener { e ->
                Log.d("MainActivity", "Failed to remove geofence with ID $identifier", e)
            }
    }
}

data class LocationData(
    val latitude: Double,
    val longitude: Double,
    val radius: Double,
    val identifier: String
)
