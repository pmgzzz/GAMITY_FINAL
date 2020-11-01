package org.gamity.buildingservice.security;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.location.Location;

import com.google.android.gms.location.LocationResult;

import java.util.List;

public final class LocationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if (LocationResult.hasResult(intent)) {
            LocationResult result = LocationResult.extractResult(intent);
            if (result != null) {
                List<Location> locations = result.getLocations();
                Location lastLocation = result.getLastLocation();

                for (Location location : locations) {
                    System.out.println("longitude=" + location.getLongitude() + " latitude=" + location.getLatitude() + " altitude=" + location.getAltitude() );
                }

            }
        }
    }
    private void send_location (Location location) {

    }
}
