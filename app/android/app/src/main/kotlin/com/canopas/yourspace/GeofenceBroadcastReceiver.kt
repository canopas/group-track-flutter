package com.canopas.yourspace

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.android.gms.location.Geofence
import com.google.android.gms.location.GeofenceStatusCodes
import com.google.android.gms.location.GeofencingEvent
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class GeofenceBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent) {
        val geofencingEvent = GeofencingEvent.fromIntent(intent)

        if (geofencingEvent.hasError()) {
            val errorMessage = GeofenceStatusCodes.getStatusCodeString(geofencingEvent.errorCode)
            Log.e("GeofenceReceiver", "Geofence error: $errorMessage")
            return
        }

        try {
            val geofenceTransition = geofencingEvent.geofenceTransition

            if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_ENTER ||
                geofenceTransition == Geofence.GEOFENCE_TRANSITION_EXIT
            ) {
                val triggeringGeofences = geofencingEvent.triggeringGeofences
                Log.d("GeofenceReceiver", "Geofence Alert received")

                triggeringGeofences?.forEach { geofence ->
                    val placeId = geofence.requestId
                    val method = if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_ENTER)
                        "onEnterGeofence"
                    else
                        "onExitGeofence"

                    handleGeofenceEvent(context, method, placeId)
                }
            } else {
                Log.e("GeofenceReceiver", "Geofence transition error: $geofenceTransition")
            }
        } catch (e: Exception) {
            Log.e("GeofenceReceiver", "Error while processing geofence alert: $e")
        }
    }

    private fun handleGeofenceEvent(context: Context?, method: String, placeId: String) {
        val flutterEngine = FlutterEngineCache.getInstance().get("geofence_engine")
        if (flutterEngine == null) {
            Log.d("GeofenceReceiver", "Geofence flutter engine is null")
            return
        }

        val methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "geofence_plugin")
        methodChannel.invokeMethod(method, mapOf("identifier" to placeId))
    }
}
