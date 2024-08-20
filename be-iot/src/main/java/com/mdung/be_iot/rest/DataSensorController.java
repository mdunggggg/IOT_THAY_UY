package com.mdung.be_iot.rest;

import com.mdung.be_iot.base.BaseResponse;
import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.DataSensor;
import com.mdung.be_iot.service.DataSensorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/data-sensors")
public class DataSensorController {
    private DataSensorService dataSensorService;

    @Autowired
    public DataSensorController(DataSensorService dataSensorService) {
        this.dataSensorService = dataSensorService;
    }

    @GetMapping("/")
    public BaseResponse<Pagination> getAllDataSensors(@RequestParam(value = "page", defaultValue = "0") int page,
                                                      @RequestParam(value = "size", defaultValue = "10") int size) {
        return BaseResponse.success(
                dataSensorService.getAllDataSensors(page, size)
        );
    }


}
