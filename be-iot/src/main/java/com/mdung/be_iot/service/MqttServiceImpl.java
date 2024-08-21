package com.mdung.be_iot.service;

import com.mdung.be_iot.entity.Action;
import com.mdung.be_iot.mqtt_config.MqttGateway;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MqttServiceImpl implements MqttService{

    private MqttGateway mqttGateway;

    @Autowired
    public MqttServiceImpl(MqttGateway mqttGateway) {
        this.mqttGateway = mqttGateway;
    }

    @Override
    public void turnLight(String message) {
        mqttGateway.sendToMqtt(message + " light");

    }

    @Override
    public void turnFan(String message) {
        mqttGateway.sendToMqtt(message + " fan");

    }

    @Override
    public void turnAirConditioner(String message) {
        mqttGateway.sendToMqtt(message + " air-condition");
    }
}
