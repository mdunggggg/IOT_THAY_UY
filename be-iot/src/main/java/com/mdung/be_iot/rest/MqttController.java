package com.mdung.be_iot.rest;

import com.mdung.be_iot.mqtt_config.MqttGateway;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/mqtt")
@Tag(name = "Mqtt broker", description = "API for mqtt")
public class MqttController {
    private MqttGateway mqttGateway;

    @Autowired
    public MqttController(MqttGateway mqttGateway) {
        this.mqttGateway = mqttGateway;
    }

    @GetMapping("/publish")
    @Operation(summary = "Publish message to mqtt")
    public String publish(@RequestParam String message) {
        mqttGateway.sendToMqtt(message,"topic/change_light");
        return "Message published!";
    }
}
