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
    public Pagination getAllActions(String appliance, String search, Pageable pageable) {
        Specification<Action> specification = Specification.where(null);

        if (appliance != null && !appliance.isEmpty()) {
            specification = specification.and((root, query, criteriaBuilder) ->
                    criteriaBuilder.like(root.get("appliance"), "%" + appliance + "%"));
        }

        if (search != null && !search.isEmpty()) {
            specification = specification.and((root, query, criteriaBuilder) ->
                    criteriaBuilder.or(
                            criteriaBuilder.like(root.get("action"), "%" + search + "%"),
                            criteriaBuilder.like(root.get("appliance"), "%" + search + "%")
                    ));
        }

        Page<Action> actions = actionRepository.findAll(specification, pageable);
        return new Pagination<>(actions.getNumber(), actions.getTotalElements(), actions.getTotalPages(), actions.getContent());

    }

}
