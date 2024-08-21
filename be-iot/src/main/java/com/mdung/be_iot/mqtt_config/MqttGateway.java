package com.mdung.be_iot.mqtt_config;

import org.springframework.integration.annotation.MessagingGateway;
import org.springframework.messaging.handler.annotation.Header;

@MessagingGateway(defaultRequestChannel = "mqttOutboundChannel")
public interface MqttGateway {

    void sendToMqtt(String data);

    void sendToMqtt(String data, @Header("mqtt_topic") String topic);
}
