package com.mdung.be_iot.rest;

import com.mdung.be_iot.base.BaseResponse;
import com.mdung.be_iot.base.Status;
import com.mdung.be_iot.dto.ActionInputDto;
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

    @PostMapping("/turn-on-off-light")
    @Operation(summary = "Publish message to mqtt")
    public BaseResponse<Boolean> changeLight(
            @RequestBody ActionInputDto actionInputDto) {
        String action = actionInputDto.getActionCode().equals("on") ? "Bật" : "Tắt";
        actionService.createAction(new Action(actionInputDto.getDeviceId(), "Đèn", "light", action, actionInputDto.getActionCode(), System.currentTimeMillis()));
        for (long i = 0; i < 10000000000L; i++) {
            if (i == 0) {
                mqttService.turnLight(actionInputDto.getActionCode());
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

    @PostMapping("/turn-on-off-fan")
    @Operation(summary = "Publish message to mqtt")
    public BaseResponse<Boolean> changeFan(
            @RequestBody ActionInputDto actionInputDto) {
        String action = actionInputDto.getActionCode().equals("on") ? "Bật" : "Tắt";
        actionService.createAction(new Action(actionInputDto.getDeviceId(), "Quạt", "fan", action, actionInputDto.getActionCode(), System.currentTimeMillis()));
        for (long i = 0; i < 10000000000L; i++) {
            if (i == 0) {
                mqttService.turnFan(actionInputDto.getActionCode());
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


    @PostMapping("/turn-on-off-air-condition")
    @Operation(summary = "Publish message to mqtt")
    public BaseResponse<Boolean> changeAirCondition(
            @RequestBody ActionInputDto actionInputDto) {
        String action = actionInputDto.getActionCode().equals("on") ? "Bật" : "Tắt";
        actionService.createAction(new Action(actionInputDto.getDeviceId(), "Điều hoà", "air_condition", action, actionInputDto.getActionCode(), System.currentTimeMillis()));
        for (long i = 0; i < 10000000000L; i++) {
            if (i == 0) {
                mqttService.turnAirConditioner(actionInputDto.getActionCode());
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
