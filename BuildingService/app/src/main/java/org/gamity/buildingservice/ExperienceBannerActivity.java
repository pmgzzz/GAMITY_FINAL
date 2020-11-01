package org.gamity.buildingservice;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import org.gamity.buildingservice.sessions.SOS;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

public class ExperienceBannerActivity extends AppCompatActivity {

        @Override
        protected void onCreate(Bundle savedInstanceState) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.experience);

            Button btnOk = (Button)findViewById(R.id.btnOk);

            btnOk.setOnClickListener(new View.OnClickListener(){
                public void onClick(View arg0) {
                    openNewSession();
                }
            });
        }

        private void openNewSession() {
            Intent intent = new Intent();
            intent.setClass(ExperienceBannerActivity.this, NewSessionActivity.class);
            startActivity(intent);
        }



}
