package com.mdung.be_iot.rest;

import com.mdung.be_iot.entity.Action;
import com.mdung.be_iot.mqtt_config.MqttGateway;
import com.mdung.be_iot.service.ActionService;
import com.mdung.be_iot.service.MqttService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Pattern;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/mqtt")
@Tag(name = "Mqtt broker", description = "API for mqtt")
public class MqttController {
    private MqttService mqttService;
    private ActionService actionService;

    @Autowired
    public MqttController(MqttService mqttService, ActionService actionService) {
        this.mqttService = mqttService;
        this.actionService = actionService;
    }

    @GetMapping("/turn-on-off-light")
    @Operation(summary = "Publish message to mqtt")
    public String changeLight(
            @Parameter(
                    description = "The action to perform on the light",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"on", "off"})
            )
            @RequestParam String message, @RequestParam String deviceId) {

        mqttService.turnLight(message);
        actionService.createAction(new Action(deviceId, "light", message, System.currentTimeMillis()));
        return "Message published!";
    }

    @GetMapping("/turn-on-off-fan")
    @Operation(summary = "Publish message to mqtt")
    public String changeFan(
            @Parameter(
                    description = "The action to perform on the fan",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"on", "off"})
            )
            @RequestParam String message, @RequestParam String deviceId) {

        mqttService.turnFan(message);
        actionService.createAction(new Action(deviceId, "fan", message, System.currentTimeMillis()));
        return "Message published!";
    }


    @GetMapping("/turn-on-off-air-condition")
    @Operation(summary = "Publish message to mqtt")
    public String changeAirCondition(
            @Parameter(
                    description = "The action to perform on the air-condition",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"on", "off"})
            )
            @RequestParam String message, @RequestParam String deviceId) {

        mqttService.turnAirConditioner(message);
        actionService.createAction(new Action(deviceId, "air-conditioner", message, System.currentTimeMillis()));
        return "Message published!";
    }




}
