CREATE DATABASE  IF NOT EXISTS `iot_thay_uy`;
USE `iot_thay_uy`;

CREATE TABLE data_sensor (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    temperature DOUBLE NOT NULL,
    humidity DOUBLE NOT NULL,
    light DOUBLE NOT NULL, 
    time DATETIME
);

CREATE TABLE `action` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `device_id` VARCHAR(255) NOT NULL,
    `appliance` VARCHAR(255) NOT NULL,
    `appliance_code` VARCHAR(255) NOT NULL,
    `action` VARCHAR(255) NOT NULL,
    `action_code` VARCHAR(255) NOT NULL,
    `time` DATETIME,
    PRIMARY KEY (`id`)
);


-- ALTER TABLE data_sensor
-- ADD COLUMN temp VARCHAR(255);
-- ALTER TABLE data_sensor DROP COLUMN temp;











