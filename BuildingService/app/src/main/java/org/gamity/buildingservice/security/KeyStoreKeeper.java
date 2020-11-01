package org.gamity.buildingservice.security;

import android.content.Context;

import androidx.security.crypto.MasterKey;

import java.io.IOException;
import java.security.GeneralSecurityException;


public class KeyStoreKeeper {
    Context context;
    MasterKey mainKey;

    public KeyStoreKeeper ( Context context ) throws GeneralSecurityException, IOException {
        this.context = context;
        mainKey = new MasterKey.Builder( context )
                .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
                .build();
    }

    public MasterKey getMasterKey () {
        return mainKey;
    }

    public Context getContext () {
        return context;
    }
}
