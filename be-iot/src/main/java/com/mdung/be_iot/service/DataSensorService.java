package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.DataSensor;
import com.mdung.be_iot.repository.DataSensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;


public interface DataSensorService {
    Pagination getAllDataSensors(int page, int size);

    DataSensor createDataSensor(DataSensor dataSensor);
}
