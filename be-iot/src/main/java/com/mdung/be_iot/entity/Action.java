package com.mdung.be_iot.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "action")
public class Action {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;

    @Column(name = "device_id")
    private String deviceId;

    @Column(name = "appliance")
    private String appliance;

    @Column(name = "action")
    private String action;

    @Column(name = "time")
    private Long time;

    public Action() {
    }

    public Action(String deviceId, String appliance, String action, Long time) {
        this.deviceId = deviceId;
        this.appliance = appliance;
        this.action = action;
        this.time = time;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getAppliance() {
        return appliance;
    }

    public void setAppliance(String appliance) {
        this.appliance = appliance;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Long getTime() {
        return time;
    }

    public void setTime(Long time) {
        this.time = time;
    }
}
