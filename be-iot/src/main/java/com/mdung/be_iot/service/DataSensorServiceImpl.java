package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.DataSensor;
import com.mdung.be_iot.repository.DataSensorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;



@Service
public class DataSensorServiceImpl implements DataSensorService {

    private DataSensorRepository dataSensorRepository;

    @Autowired
    public DataSensorServiceImpl(DataSensorRepository dataSensorRepository) {
        this.dataSensorRepository = dataSensorRepository;
    }

    @Override
    public Pagination getAllDataSensors(int page, int size, String search, String type) {
        Pageable pageable = PageRequest.of(page, size);

        Specification<DataSensor> specification = Specification.where(null);
        try {
            if (search != null && type != null && !type.equals("all")) {
                specification = specification.and((root, query, criteriaBuilder) ->
                        criteriaBuilder.equal(root.get(type), search));
            }
            if (search != null && type != null && type.equals("all")) {
                specification = specification.and((root, query, criteriaBuilder) -> criteriaBuilder.or(
                        criteriaBuilder.equal(root.get("temperature"), search),
                        criteriaBuilder.equal(root.get("humidity"), search),
                        criteriaBuilder.equal(root.get("light"), search))
                );
            }
            if(search != null && type == null){
                specification = specification.and((root, query, criteriaBuilder) -> criteriaBuilder.or(
                        criteriaBuilder.equal(root.get("temperature"), search),
                        criteriaBuilder.equal(root.get("humidity"), search),
                        criteriaBuilder.equal(root.get("light"), search))
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        Page<DataSensor> dataSensors = dataSensorRepository.findAll(specification, pageable);
        return new Pagination(dataSensors.getNumber(), dataSensors.getTotalElements(), dataSensors.getTotalPages(), dataSensors.getContent());
    }

    @Override
    @Transactional
    public DataSensor createDataSensor(DataSensor dataSensor) {
        return dataSensorRepository.save(dataSensor);
    }


}
