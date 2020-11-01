package org.gamity.buildingservice.sessions;

import java.time.LocalDateTime;
import java.util.Date;

public class BuildingSession {

    Date startTime;

    public BuildingSession (Date startTime) {
        this.startTime = startTime;
    }

    public Date getStartTime () {
        return startTime;
    }

    public void close () {

    }
}
