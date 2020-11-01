package org.gamity.buildingservice;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;

import android.annotation.SuppressLint;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;

import org.gamity.buildingservice.additional.AutoCompleteLoginStore;
import org.gamity.buildingservice.security.ConnectionService;
import org.gamity.buildingservice.security.Cryptographer;
import org.gamity.buildingservice.security.KeyStoreKeeper;
import org.gamity.buildingservice.context.ContextKeeper;
import org.gamity.buildingservice.security.LocationReceiver;
import org.gamity.buildingservice.sessions.BuildingSession;

import java.io.IOException;
import java.security.GeneralSecurityException;
import java.util.Calendar;

public class MainActivity extends AppCompatActivity implements
        GoogleApiClient.OnConnectionFailedListener,
        GoogleApiClient.ConnectionCallbacks {

    public static ConnectionService connectionService;
    public static BuildingSession buildingSession;

    private Cryptographer cryptographer;

    private GoogleApiClient client;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        ContextKeeper.context = getApplicationContext();
        try {
            cryptographer = new Cryptographer(new KeyStoreKeeper(ContextKeeper.getContext()));
        } catch (GeneralSecurityException | IOException e) {
            e.printStackTrace();
        }

        client = new GoogleApiClient.Builder(this)
                .enableAutoManage(this, this)
                .addApi(LocationServices.API)
                .addConnectionCallbacks(this)
                .build();

        client.connect();

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        AutoCompleteLoginStore autoCompleteLoginStore = new AutoCompleteLoginStore(cryptographer);
        Button btnLogin = (Button) findViewById(R.id.btnLogin);

        final EditText editTextNumberPassword = (EditText) findViewById(R.id.editTextNumberPassword);
        final TextView textViewLogo = (TextView) findViewById(R.id.textViewLogo);
        final AutoCompleteTextView autoCompleteTextViewPhone = findViewById(R.id.autoCompleteTextViewPhone);
        autoCompleteTextViewPhone.setAdapter(new ArrayAdapter<>(this,
                android.R.layout.simple_dropdown_item_1line, autoCompleteLoginStore.getPhoneArray()));
        final AutoCompleteTextView autoCompleteTextViewSnils = findViewById(R.id.autoCompleteTextViewSnils);
        autoCompleteTextViewSnils.setAdapter(new ArrayAdapter<>(this,
                android.R.layout.simple_dropdown_item_1line, autoCompleteLoginStore.getSnilsArray()));

        btnLogin.setOnClickListener(new View.OnClickListener() {
            public void onClick(View arg0) {
                try {
                    autoCompleteLoginStore.appendPhoneList(autoCompleteTextViewPhone.getText().toString());
                    autoCompleteLoginStore.appendSnilsList(autoCompleteTextViewSnils.getText().toString());
                } catch (IOException | GeneralSecurityException e) {
                    e.printStackTrace();
                }
                connectionService = new ConnectionService(autoCompleteTextViewPhone.getText().toString(),
                        autoCompleteTextViewSnils.getText().toString(),
                        editTextNumberPassword.getText().toString());
                openNewSessionThrouExpBanner();
            }
        });
    }

    public static BuildingSession getBuildingSession() {
        return buildingSession;
    }

    private void openMainActivity() {
        Intent intent = new Intent();
        intent.setClass(MainActivity.this, MainActivity.class);
        startActivity(intent);
    }

    private void openNewSession() {
        Intent intent = new Intent();
        intent.setClass(MainActivity.this, NewSessionActivity.class);
        startActivity(intent);
    }

    private void openNewSessionThrouExpBanner () {
        Intent intent = new Intent();
        intent.setClass(MainActivity.this, ExperienceBannerActivity.class);
        startActivity(intent);
    }

    @SuppressLint("NewApi")
    private void newBuildingSession() {
        buildingSession = new BuildingSession(Calendar.getInstance().getTime());
    }

    private void closeCurrentBuildingSession() {
        if (buildingSession != null) {
            buildingSession.close();
        }
    }

    private void stopConnectionService() {
        if (connectionService != null) {
            connectionService.stop();
        }
    }

    @Override
    public void onConnectionFailed(@NonNull ConnectionResult connectionResult) {
        try {
            throw new Exception(connectionResult.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onConnected(@Nullable Bundle bundle) {

        Intent intent = new Intent(ContextKeeper.getContext(), LocationReceiver.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(ContextKeeper.getContext(), 0, intent, PendingIntent.FLAG_CANCEL_CURRENT);

        if (ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        PendingResult result =
                LocationServices.FusedLocationApi.requestLocationUpdates(
                        client, LocationRequest.create(), pendingIntent);

        result.setResultCallback(new ResultCallback() {
            @Override
            public void onResult(@NonNull Result result) {
                Log.d("MainActivity", "Result: " + result.getStatus().getStatusMessage());
            }

            public void onResult(@NonNull Status status) {
                Log.d("MainActivity", "Result: " + status.getStatusMessage());
            }
        });

    }

    @Override
    public void onConnectionSuspended(int i) {

    }
}