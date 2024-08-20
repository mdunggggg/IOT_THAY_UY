package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.DataSensor;
import com.mdung.be_iot.repository.DataSensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;


@Service
public class DataSensorServiceImpl implements DataSensorService {

    private DataSensorRepository dataSensorRepository;

    @Autowired
    public DataSensorServiceImpl(DataSensorRepository dataSensorRepository) {
        this.dataSensorRepository = dataSensorRepository;
    }

    @Override
    public Pagination getAllDataSensors(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<DataSensor> dataSensors = dataSensorRepository.findAll(pageable);
        return new Pagination(dataSensors.getNumber(), dataSensors.getTotalElements(), dataSensors.getTotalPages(), dataSensors.getContent());
    }

    @Override
    public DataSensor createDataSensor(DataSensor dataSensor) {
        return dataSensorRepository.save(dataSensor);
    }


}
