package org.gamity.buildingservice.context;

import android.content.Context;

public class ContextKeeper {
    public static Context context;

    public ContextKeeper(Context context) {
        this.context = context;
    }

    public static Context getContext () {
        return context;
    }
}
