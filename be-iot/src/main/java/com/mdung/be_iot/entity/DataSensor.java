package com.mdung.be_iot.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Entity
@Table(name = "data_sensor")
public class DataSensor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @Getter
    @Setter
    private long id;

    @Column(name = "temperature")
    @Getter
    @Setter
    private double temperature;

    @Getter
    @Setter
    @Column(name = "humidity")
    private double humidity;

    @Getter
    @Setter
    @Column(name = "light")
    private double light;

    @Getter
    @Setter
    @Column(name = "windy")
    private Double windy;

    @Getter
    @Setter
    @Column(name = "time")
    private LocalDateTime time;

    public DataSensor() {
    }

    public DataSensor(double temperature, double humidity, LocalDateTime time) {
        this.temperature = temperature;
        this.humidity = humidity;
        this.time = time;
    }

    @Override
    public String toString() {
        return "DataSensor{" +
                "id=" + id +
                ", temperature=" + temperature +
                ", humidity=" + humidity +
                ", light=" + light +
                ", time=" + time +
                ", windy=m" + windy +
                '}';
    }
}
