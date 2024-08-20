CREATE DATABASE  IF NOT EXISTS `iot_thay_uy`;
USE `iot_thay_uy`;

CREATE TABLE data_sensor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    temperature DOUBLE NOT NULL,
    humidity DOUBLE NOT NULL,
    light DOUBLE NOT NULL, 
    time BIGINT
);


