package com.mdung.be_iot.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "action")
public class Action {
    @Setter
    @Getter
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;

    @Setter
    @Getter
    @Column(name = "device_id")
    private String deviceId;

    @Setter
    @Getter
    @Column(name = "appliance")
    private String appliance;

    @Setter
    @Getter
    @Column(name = "appliance_code")
    private String applianceCode;

    @Setter
    @Getter
    @Column(name = "action")
    private String action;

    @Setter
    @Getter
    @Column(name = "action_code")
    private String actionCode;

    @Setter
    @Getter
    @Column(name = "time")
    private LocalDateTime time;

    public Action() {
    }

    public Action(String deviceId, String appliance, String applianceCode, String action, String actionCode, LocalDateTime time) {
        this.deviceId = deviceId;
        this.appliance = appliance;
        this.applianceCode = applianceCode;
        this.action = action;
        this.actionCode = actionCode;
        this.time = time;
    }

    @Override
    public String toString() {
        return "Action{" +
                "id=" + id +
                ", deviceId='" + deviceId + '\'' +
                ", appliance='" + appliance + '\'' +
                ", applicanceId='" + applianceCode + '\'' +
                ", action='" + action + '\'' +
                ", actionId='" + actionCode + '\'' +
                ", time=" + time +
                '}';
    }
}
