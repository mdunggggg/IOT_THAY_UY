package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.DataSensor;

import java.time.LocalDate;
import java.util.List;


public interface DataSensorService {
    Pagination getAllDataSensors(int page, int size, String search, String type, String sortType, LocalDate startDate, LocalDate endDate);

    DataSensor createDataSensor(DataSensor dataSensor);

    List<DataSensor> getDataSensorsAfterId(Long lastId, Integer size);
}
