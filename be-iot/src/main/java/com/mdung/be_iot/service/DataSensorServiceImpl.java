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

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static com.mdung.be_iot.utils.DateTimeUtils.localDateToLongEndOfDay;
import static com.mdung.be_iot.utils.DateTimeUtils.localDateToLongStartOfDay;


@Service
public class DataSensorServiceImpl implements DataSensorService {

    private DataSensorRepository dataSensorRepository;

    @Autowired
    public DataSensorServiceImpl(DataSensorRepository dataSensorRepository) {
        this.dataSensorRepository = dataSensorRepository;
    }

    @Override
    public Pagination getAllDataSensors(int page, int size, String search, String type, String sortType, LocalDate startDate, LocalDate endDate) {
        Pageable pageable = PageRequest.of(page, size);

        Specification<DataSensor> specification = Specification.where(null);
        try {
            if(sortType != null){
                specification = specification.and(buildSpecification(sortType));
            }
            if (search != null && type != null && !type.equals("all")) {
                specification = specification.and((root, query, criteriaBuilder) ->
                        criteriaBuilder.like(root.get(type), "%" + search + "%"));
            }
            if (search != null && type != null && type.equals("all")) {
                specification = specification.and((root, query, criteriaBuilder) -> criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.function("str", String.class, root.get("temperature")), "%" + search + "%"),
                        criteriaBuilder.like(criteriaBuilder.function("str", String.class, root.get("humidity")), "%" + search + "%"),
                        criteriaBuilder.like(criteriaBuilder.function("str", String.class, root.get("light")), "%" + search + "%"),
                        criteriaBuilder.like(
                                criteriaBuilder.function(
                                        "DATE_FORMAT", String.class, root.get("time"), criteriaBuilder.literal("%H:%i:%s %d/%m/%y")),
                                "%" + search + "%"
                        ))
                );
            }
            if(search != null && type == null){
                specification = specification.and((root, query, criteriaBuilder) -> criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.function("str", String.class, root.get("temperature")), "%" + search + "%"),
                        criteriaBuilder.like(criteriaBuilder.function("str", String.class, root.get("humidity")), "%" + search + "%"),
                        criteriaBuilder.like(criteriaBuilder.function("str", String.class, root.get("light")), "%" + search + "%")
                        ,  criteriaBuilder.like(
                                criteriaBuilder.function(
                                        "DATE_FORMAT", String.class, root.get("time"), criteriaBuilder.literal("%H:%i:%s %d/%m/%y")),
                                "%" + search + "%"
                        ))
                );
            }
            if (startDate != null) {
                specification = specification.and((root, query, criteriaBuilder) ->
                        criteriaBuilder.greaterThanOrEqualTo(root.get("time"), startDate.atStartOfDay()));
            }
            if (endDate != null) {
                specification = specification.and((root, query, criteriaBuilder) ->
                        criteriaBuilder.lessThanOrEqualTo(root.get("time"), endDate.atTime(23, 59, 59)));
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

    public Specification<DataSensor> buildSpecification(String sortType) {
        Specification<DataSensor> specification = Specification.where(null);

        if (sortType != null) {
            switch (sortType) {
                case "temp":
                    specification = specification.and(sortBy("temperature", true));
                    break;
                case "-temp":
                    specification = specification.and(sortBy("temperature", false));
                    break;
                case "humidity":
                    specification = specification.and(sortBy("humidity", true));
                    break;
                case "-humidity":
                    specification = specification.and(sortBy("humidity", false));
                    break;
                case "light":
                    specification = specification.and(sortBy("light", true));
                    break;
                case "-light":
                    specification = specification.and(sortBy("light", false));
                    break;
                case "time":
                    specification = specification.and(sortBy("time", true));
                    break;
                case "-time":
                    specification = specification.and(sortBy("time", false));
                    break;
                default:
                    throw new IllegalArgumentException("Invalid sort type: " + sortType);
            }
        }

        return specification;
    }

    @Override
    public List<DataSensor> getDataSensorsAfterId(Long lastId, Integer size) {
        if (lastId == null) {
            lastId = 0L;
        }
        if (size == null || size <= 0) {
            return dataSensorRepository.findByIdGreaterThanOrderByTimeAscIdAsc(lastId );
        } else {
            Pageable pageable = PageRequest.of(0, size);
            return dataSensorRepository.findByIdGreaterThanOrderByTimeAscIdAsc(lastId, pageable);
        }
    }

    @Override
    public long countByTemperatureGreaterThan(double temperature) {
        return dataSensorRepository.countByTemperatureGreaterThan(26.2) ;
    }

    private Specification<DataSensor> sortBy(String field, boolean ascending) {
        return (root, query, criteriaBuilder) -> {
            if (ascending) {
                query.orderBy(criteriaBuilder.asc(root.get(field)));
            } else {
                query.orderBy(criteriaBuilder.desc(root.get(field)));
            }
            return criteriaBuilder.conjunction();
        };
    }





}
