package com.mdung.be_iot.rest;

import com.mdung.be_iot.base.BaseResponse;
import com.mdung.be_iot.base.Status;
import com.mdung.be_iot.entity.Action;
import com.mdung.be_iot.service.ActionService;
import com.mdung.be_iot.service.MqttService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.integration.annotation.ServiceActivator;
import org.springframework.integration.mqtt.support.MqttHeaders;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageHandler;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CountDownLatch;

@RestController
@RequestMapping("/api/v1/mqtt")
@Tag(name = "Mqtt broker", description = "API for mqtt")
public class MqttController {
    private MqttService mqttService;
    private ActionService actionService;

    String light = null;
    String fan = null;
    String airConditioner = null;

    @Autowired
    public MqttController(MqttService mqttService, ActionService actionService) {
        this.mqttService = mqttService;
        this.actionService = actionService;
    }

    @GetMapping("/turn-on-off-light")
    @Operation(summary = "Publish message to mqtt")
    public BaseResponse<Boolean> changeLight(
            @RequestParam String deviceId,
            @Parameter(
                    description = "The action to perform on the light",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"on", "off"})
            )
            @RequestParam String actionCode) {
        String action = actionCode.equals("on") ? "Bật" : "Tắt";
        actionService.createAction(new Action(deviceId, "Đèn", "light", action, actionCode, System.currentTimeMillis()));
        for (long i = 0; i < 10000000000L; i++) {
            if (i == 0) {
                mqttService.turnLight(actionCode);
            }
            if (light != null) {
                light = null;
                System.out.println("light: " + light);
                return BaseResponse.success(
                        true
                );
            }
        }
        return BaseResponse.error(
                new Status(400, "Not response")
        );
    }

    @GetMapping("/turn-on-off-fan")
    @Operation(summary = "Publish message to mqtt")
    public BaseResponse<Boolean> changeFan(
            @RequestParam String deviceId,
            @Parameter(
                    description = "The action to perform on the light",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"on", "off"})
            )
            @RequestParam String actionCode) {
        String action = actionCode.equals("on") ? "Bật" : "Tắt";
        actionService.createAction(new Action(deviceId, "Quạt", "fan", action, actionCode, System.currentTimeMillis()));
        for (long i = 0; i < 10000000000L; i++) {
            if (i == 0) {
                mqttService.turnFan(actionCode);
            }
            if (fan != null) {
                fan = null;
                System.out.println("fan: " + fan);
                return BaseResponse.success(
                        true
                );
            }
        }
        return BaseResponse.error(
                new Status(400, "Not response")
        );
    }


    @GetMapping("/turn-on-off-air-condition")
    @Operation(summary = "Publish message to mqtt")
    public BaseResponse<Boolean> changeAirCondition(
            @RequestParam String deviceId,
            @Parameter(
                    description = "The action to perform on the light",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"on", "off"})
            )
            @RequestParam String actionCode) {
        String action = actionCode.equals("on") ? "Bật" : "Tắt";
        actionService.createAction(new Action(deviceId, "Điều hoà", "air_condition", action, actionCode, System.currentTimeMillis()));
        for (long i = 0; i < 10000000000L; i++) {
            if (i == 0) {
                mqttService.turnAirConditioner(actionCode);
            }
            if (airConditioner != null) {
                airConditioner = null;
                System.out.println("airConditioner: " + airConditioner);
                return BaseResponse.success(
                        true
                );
            }
        }
        return BaseResponse.error(
                new Status(400, "Not response")
        );
    }

    @ServiceActivator(inputChannel = "mqttInputChannel")
    public void handleMessage(String message) {
        if (message.equals("on light") || message.equals("off light")) {
            light = message;
        }
        if (message.equals("on fan") || message.equals("off fan")) {
            fan = message;
        }
        if (message.equals("on air-condition") || message.equals("off air-condition")) {
            airConditioner = message;
        }
    }


}
