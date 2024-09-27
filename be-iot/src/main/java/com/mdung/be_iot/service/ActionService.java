package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.Action;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;

public interface ActionService {
    Action createAction(Action action);

    Pagination getAllActions(String appliance, String search, Pageable pageable, LocalDate startDate, LocalDate endDate);

    int solanBatTatQuatTrongNgay();
}
