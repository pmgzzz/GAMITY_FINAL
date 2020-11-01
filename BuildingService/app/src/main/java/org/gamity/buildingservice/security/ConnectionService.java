package org.gamity.buildingservice.security;

public class ConnectionService {
    private String user;
    private String phone;
    private String snils;
    private String password;

    public ConnectionService (String phone, String snils, String password) {
        this.phone = phone;
        this.snils = snils;
        this.password = password;
    }

    public void connect () {

    }

    public void stop () {

    }
}
