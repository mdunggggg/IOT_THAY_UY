package com.mdung.be_iot.rest;

import com.mdung.be_iot.base.BaseResponse;
import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.service.DataSensorService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;


@RestController
@RequestMapping("/api/v1/data-sensors")
@Tag(name = "Data Sensor", description = "API for Data Sensor")
public class DataSensorController {
    private DataSensorService dataSensorService;

    @Autowired
    public DataSensorController(DataSensorService dataSensorService) {
        this.dataSensorService = dataSensorService;
    }

    @GetMapping("/")
    @Operation(summary = "Get all data sensors")
    public BaseResponse<Pagination> getAllDataSensors(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            @RequestParam(required = false) String search,
            @Parameter(
                    description = "Search by type",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"all", "temperature", "humidity", "light"})
            )
            @RequestParam(required = false) String type,
            @Parameter(
                    description = "Sort by type",
                    in = ParameterIn.QUERY,
                    schema = @Schema(allowableValues = {"temp", "-temp", "humidity", "-humidity", "light", "-light", "time", "-time"})
            )
            @RequestParam(defaultValue = "time") String sortType
    ) {
        return BaseResponse.success(
                dataSensorService.getAllDataSensors(page, size, search, type, sortType)
        );
    }


}
