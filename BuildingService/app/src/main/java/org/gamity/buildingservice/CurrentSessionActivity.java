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

public class CurrentSessionActivity extends AppCompatActivity {

    TextView textViewCntTime;
    private Timer timer;
    private SessionTimerTask sessionTimerTask;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.current_session);

        textViewCntTime = (TextView)findViewById(R.id.textViewCntTime);

        Button btnEndSession = (Button)findViewById(R.id.btnEndSession);
        Button buttonSOS = (Button)findViewById(R.id.buttonSOS);

        btnEndSession.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                closeCurrentBuildingSession();
                //if (getCoins)
                openGetCoin();
            }
        });

        buttonSOS.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                new SOS().call();
            }
        });

        if (timer != null) {
            timer.cancel();
        }
        timer = new Timer();
        sessionTimerTask = new SessionTimerTask();
        timer.schedule(sessionTimerTask, 1000, 1000);
    }

    private void openMainActivity () {
        Intent intent = new Intent();
        intent.setClass(CurrentSessionActivity.this, MainActivity.class);
        startActivity(intent);
    }

    private void openGetCoin () {
        Intent intent = new Intent();
        intent.setClass(CurrentSessionActivity.this, GetCoinActivivty.class);
        startActivity(intent);
    }

    private void openNewSession () {
        Intent intent = new Intent();
        intent.setClass(CurrentSessionActivity.this, NewSessionActivity.class);
        startActivity(intent);
    }

    private void closeCurrentBuildingSession () {
        if (MainActivity.getBuildingSession() != null) { MainActivity.getBuildingSession().close(); }
    }

    public class SessionTimerTask extends TimerTask {
        @Override
        public void run() {
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
            final String textDate = simpleDateFormat.format(new Date(calendar.getTime().getTime() - MainActivity.getBuildingSession().getStartTime().getTime()));
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    textViewCntTime.setText(textDate);
                }
            });
        }
    }


}
