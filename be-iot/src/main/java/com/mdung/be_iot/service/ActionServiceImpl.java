package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.Action;
import com.mdung.be_iot.repository.ActionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import static com.mdung.be_iot.utils.DateTimeUtils.*;


@Service
public class ActionServiceImpl implements ActionService {

    private ActionRepository actionRepository;

    @Autowired
    public ActionServiceImpl(ActionRepository actionRepository) {
        this.actionRepository = actionRepository;
    }

    @Override
    @Transactional
    public Action createAction(Action action) {
        return actionRepository.save(action);
    }

    @Override
    public Pagination getAllActions(String appliance, String search, Pageable pageable, LocalDate startDate, LocalDate endDate) {
        Specification<Action> specification = Specification.where(null);

        if (appliance != null) {
            specification = specification.and((root, query, criteriaBuilder) ->
                    criteriaBuilder.or(
                            criteriaBuilder.like(root.get("appliance"), "%" + appliance + "%"),
                            criteriaBuilder.like(root.get("applianceCode"), "%" + appliance + "%")
                    )
            );
        }
        if (search != null) {
            specification = specification.and((root, query, criteriaBuilder) ->
                    criteriaBuilder.or(
                            criteriaBuilder.like(root.get("action"), "%" + search + "%"),
                            criteriaBuilder.like(root.get("appliance"), "%" + search + "%"),
                            criteriaBuilder.like(root.get("actionCode"), "%" + search + "%"),
                            criteriaBuilder.like(root.get("applianceCode"), "%" + search + "%"),
                            criteriaBuilder.like(root.get("deviceId"), "%" + search + "%"),
                            criteriaBuilder.like(
                                    criteriaBuilder.function(
                                            "DATE_FORMAT", String.class, root.get("time"), criteriaBuilder.literal("%H:%i:%s %d/%m/%y")),
                                    "%" + search + "%"
                            )

                    ));
        }
        if (startDate != null) {
            specification = specification.and((root, query, criteriaBuilder) ->
                    criteriaBuilder.greaterThanOrEqualTo(root.get("time"), startDate.atStartOfDay()));
        }
        if (endDate != null) {
            specification = specification.and((root, query, criteriaBuilder) ->
                    criteriaBuilder.lessThanOrEqualTo(root.get("time"), endDate.atTime(23, 59, 59)));
        }
        Page<Action> actions = actionRepository.findAll(specification, pageable);
        return new Pagination<>(actions.getNumber(), actions.getTotalElements(), actions.getTotalPages(), actions.getContent());

    }

    @Override
    public int solanBatTatQuatTrongNgay() {
        LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
        LocalDateTime endOfDay = LocalDate.now().atTime(LocalTime.MAX);
        return actionRepository.findByActionCodeAndApplianceCodeAndToday("on", "light", startOfDay, endOfDay ).size();
    }

}
