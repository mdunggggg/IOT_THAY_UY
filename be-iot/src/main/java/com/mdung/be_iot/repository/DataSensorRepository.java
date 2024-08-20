package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.DataSensor;
import org.hibernate.query.Page;
import org.springframework.data.jpa.repository.JpaRepository;

import java.awt.print.Pageable;

public interface DataSensorRepository extends JpaRepository<DataSensor, Long> {
}
