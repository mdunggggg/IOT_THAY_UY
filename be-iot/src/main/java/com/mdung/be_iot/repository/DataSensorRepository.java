package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.DataSensor;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;


public interface DataSensorRepository extends JpaRepository<DataSensor, Long>, JpaSpecificationExecutor<DataSensor> {
    List<DataSensor> findByIdGreaterThanOrderByTimeAscIdAsc(Long lastId,Pageable pageable);

    List<DataSensor> findByIdGreaterThanOrderByTimeAscIdAsc(Long lastId);

    @Query("SELECT COUNT(ds) FROM DataSensor ds WHERE ds.temperature >= :temperature")
    long countByTemperatureGreaterThan(@Param("temperature") double temperature);
}
