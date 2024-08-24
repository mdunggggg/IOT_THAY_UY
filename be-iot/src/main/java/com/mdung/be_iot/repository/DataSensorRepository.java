package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.DataSensor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;


public interface DataSensorRepository extends JpaRepository<DataSensor, Long>, JpaSpecificationExecutor<DataSensor> {
    List<DataSensor> findByIdGreaterThanAndTimeGreaterThanEqualOrderByTimeAscIdAsc(Long lastId, Long time, Pageable pageable);

    List<DataSensor> findByIdGreaterThanAndTimeGreaterThanEqualOrderByTimeAscIdAsc(Long lastId, Long time);
}
