package org.gamity.buildingservice;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

import androidx.appcompat.app.AppCompatActivity;

import org.gamity.buildingservice.sessions.BuildingSession;

import java.time.LocalDateTime;
import java.util.Calendar;

public class NewSessionActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.new_session);

        Button btnStartSession = (Button)findViewById(R.id.btnStartSession);
        Button buttonLogOff = (Button)findViewById(R.id.buttonLogOff);
        ImageButton imageButtonRole = (ImageButton)findViewById(R.id.imageButtonRole);

        btnStartSession.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                newBuildingSession();
                openCurrentSession();
            }
        });

        buttonLogOff.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                closeCurrentBuildingSession();
                stopConnectionService();
                openNewSession();
            }
        });

        imageButtonRole.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                openChooseProfile();
            }
        });
    }

    private void openCurrentSession () {
        Intent intent = new Intent();
        intent.setClass(NewSessionActivity.this, CurrentSessionActivity.class);
        startActivity(intent);
    }

    private void openChooseProfile() {
        Intent intent = new Intent();
        intent.setClass(NewSessionActivity.this, ChooseProfileActivity.class);
        startActivity(intent);
    }

    @SuppressLint("NewApi")
    private void newBuildingSession () {
        MainActivity.buildingSession = new BuildingSession(Calendar.getInstance().getTime());
    }

    private void closeCurrentBuildingSession () {
        if (MainActivity.getBuildingSession() != null) { MainActivity.buildingSession.close(); }
    }

    private void stopConnectionService () {
        if (MainActivity.connectionService != null) { MainActivity.connectionService.stop(); }
    }

    private void openNewSession () {
        Intent intent = new Intent();
        intent.setClass(NewSessionActivity.this, MainActivity.class);
        startActivity(intent);
    }
}
