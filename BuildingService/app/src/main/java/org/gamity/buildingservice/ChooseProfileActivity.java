package org.gamity.buildingservice;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

import androidx.appcompat.app.AppCompatActivity;

public class ChooseProfileActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile);

        ImageButton imageViewEl = (ImageButton)findViewById(R.id.imageViewEl);
        ImageButton imageViewM = (ImageButton)findViewById(R.id.imageViewM);

        imageViewEl.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                openNewSession();
            }
        });
    }

    private void openNewSession() {
        Intent intent = new Intent();
        intent.setClass(ChooseProfileActivity.this, NewSessionActivity.class);
        startActivity(intent);
    }
}
