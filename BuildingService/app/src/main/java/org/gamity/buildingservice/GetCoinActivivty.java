package org.gamity.buildingservice;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;

import androidx.appcompat.app.AppCompatActivity;

public class GetCoinActivivty extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.victory_exp);

        ImageButton imageButtonGetCoins = (ImageButton)findViewById(R.id.imageButtonGetCoins);

        imageButtonGetCoins.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                openNewSession();
            }
        });
    }

    private void openNewSession () {
        Intent intent = new Intent();
        intent.setClass(GetCoinActivivty.this, NewSessionActivity.class);
        startActivity(intent);
    }
}
