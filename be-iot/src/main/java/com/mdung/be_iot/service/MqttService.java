package com.mdung.be_iot.service;

public interface MqttService {
    void turnLight(String message);
    void turnFan(String message);
    void turnAirConditioner(String message);
}
