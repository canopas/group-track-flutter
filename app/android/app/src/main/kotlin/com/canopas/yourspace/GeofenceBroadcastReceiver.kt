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
    private val tag = "XXX GeofenceReceiver"
    override fun onReceive(context: Context?, intent: Intent) {
        Log.d(tag, "Received geofence intent:$intent")
        val geofencingEvent = GeofencingEvent.fromIntent(intent)
        if (geofencingEvent == null) {
            Log.e(tag, "GeofencingEvent is null")
            return
        } else {
            Log.d(tag, "GeofencingEvent extracted successfully")
        }
        if (geofencingEvent.hasError()) {
            val errorMessage = GeofenceStatusCodes.getStatusCodeString(geofencingEvent.errorCode)
            Log.e(tag, "Geofence error: $errorMessage")
            return
        }

        try {
            val geofenceTransition = geofencingEvent.geofenceTransition
            Log.d(tag, "Geofence transition: $geofenceTransition")

            if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_ENTER ||
                geofenceTransition == Geofence.GEOFENCE_TRANSITION_EXIT
            ) {

                val triggeringGeofences = geofencingEvent.triggeringGeofences
                Log.d(tag, "Geofence Alert received")

                triggeringGeofences?.forEach { geofence ->
                    val placeId = geofence.requestId
                    val method = if (geofenceTransition == Geofence.GEOFENCE_TRANSITION_ENTER)
                        "onEnterGeofence"
                    else
                        "onExitGeofence"
                    Log.d(tag, "Geofence transition: $placeId, $geofenceTransition")

                    handleGeofenceEvent(context, method, placeId)
                }
            } else {
                Log.e(tag, "Geofence transition error: $geofenceTransition")
            }
        } catch (e: Exception) {
            Log.e(tag, "Error while processing geofence alert: $e")
        }
    }

    private fun handleGeofenceEvent(context: Context?, method: String, placeId: String) {
        Log.d(tag, "Geofence handel event")
        val flutterEngine = FlutterEngineCache.getInstance().get("geofence_engine")
        if (flutterEngine == null) {
            Log.d(tag, "Geofence flutter engine is null")
            return
        }
        Log.d(tag, "Geofence flutter engine created")
        val methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "geofence_plugin")
        Log.d(tag, "Geofence called method channel:$method")
        methodChannel.invokeMethod(method, mapOf("identifier" to placeId))
    }
}
