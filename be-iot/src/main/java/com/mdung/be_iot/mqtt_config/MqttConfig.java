package com.mdung.be_iot.mqtt_config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mdung.be_iot.entity.DataSensor;
import com.mdung.be_iot.service.DataSensorService;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.integration.annotation.IntegrationComponentScan;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.channel.DirectChannel;
import org.springframework.integration.config.EnableIntegration;
import org.springframework.integration.mqtt.core.DefaultMqttPahoClientFactory;
import org.springframework.integration.mqtt.core.MqttPahoClientFactory;
import org.springframework.integration.mqtt.inbound.MqttPahoMessageDrivenChannelAdapter;
import org.springframework.integration.mqtt.outbound.MqttPahoMessageHandler;
import org.springframework.integration.mqtt.support.DefaultPahoMessageConverter;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessageHandler;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@Configuration
@EnableIntegration
@IntegrationComponentScan
public class MqttConfig {

    private DataSensorService dataSensorService;
    private ObjectMapper objectMapper;

    @Autowired
    public MqttConfig(DataSensorService dataSensorService, ObjectMapper objectMapper){
        this.dataSensorService = dataSensorService;
        this.objectMapper = objectMapper;
    }

    @Bean
    public MessageChannel mqttInputChannel() {
        return new DirectChannel();
    }

    @Bean
    public MqttPahoMessageDrivenChannelAdapter mqttInbound() {
        MqttPahoMessageDrivenChannelAdapter adapter =
                new MqttPahoMessageDrivenChannelAdapter("tcp://172.20.10.4:1883", mqttClientFactory(), "topic/temp-humidity-light", "topic/response");
        adapter.setCompletionTimeout(5000);
        adapter.setConverter(new DefaultPahoMessageConverter());
        adapter.setQos(0);
        adapter.setOutputChannel(mqttInputChannel());
        return adapter;
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttInputChannel")
    public MessageHandler handler() {
        return message -> {
            System.out.println("Received message: " + message);
            try {
                String payload = (String) message.getPayload();
                DataSensor dataSensor = objectMapper.readValue(payload, DataSensor.class);
                dataSensor.setTime(LocalDateTime.now());
                dataSensorService.createDataSensor(dataSensor);
                System.out.println("Saved data sensor: " + dataSensor);
            } catch (Exception e) {
                System.err.println("Failed to process message: " + e.getMessage());
            }
        };
    }

    @Bean
    public MqttPahoClientFactory mqttClientFactory() {
        DefaultMqttPahoClientFactory factory = new DefaultMqttPahoClientFactory();
        MqttConnectOptions options = new MqttConnectOptions();
        options.setServerURIs(new String[] {"tcp://172.20.10.4:1883"});
        options.setUserName("B21DCCN268");
        options.setPassword("123".toCharArray());
        factory.setConnectionOptions(options);
        return factory;
    }

    @Bean
    @ServiceActivator(inputChannel = "mqttOutboundChannel")
    public MessageHandler mqttOutbound() {
        MqttPahoMessageHandler messageHandler =
                new MqttPahoMessageHandler("BE_Pub_B21DCCN268", mqttClientFactory());
        messageHandler.setAsync(true);
        messageHandler.setDefaultTopic("topic/action");
        return messageHandler;
    }




}
