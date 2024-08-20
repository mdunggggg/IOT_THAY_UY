package com.mdung.be_iot.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "data_sensor")
public class DataSensor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private long id;

    @Column(name = "temperature")
    private double temperature;

    @Column(name = "humidity")
    private double humidity;

    @Column(name = "time")
    private Long time;

    public DataSensor() {
    }

    public DataSensor(double temperature, double humidity, Long time) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.time = time;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getTemperature() {
        return temperature;
    }

    public void setTemperature(double temperature) {
        this.temperature = temperature;
    }

    public double getHumidity() {
        return humidity;
    }

    public void setHumidity(double humidity) {
        this.humidity = humidity;
    }

    public Long getTime() {
        return time;
    }

    public void setTime(Long time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "DataSensor{" +
                "id=" + id +
                ", temperature=" + temperature +
                ", humidity=" + humidity +
                ", time=" + time +
                '}';
    }
}
