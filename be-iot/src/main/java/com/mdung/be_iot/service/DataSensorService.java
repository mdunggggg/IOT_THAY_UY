package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.DataSensor;


public interface DataSensorService {
    Pagination getAllDataSensors(int page, int size, String search, String type);

    DataSensor createDataSensor(DataSensor dataSensor);
}
