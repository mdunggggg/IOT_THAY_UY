package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.DataSensor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;


public interface DataSensorRepository extends JpaRepository<DataSensor, Long>, JpaSpecificationExecutor<DataSensor> {
}
