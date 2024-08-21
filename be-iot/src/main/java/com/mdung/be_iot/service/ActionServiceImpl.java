package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.Action;
import com.mdung.be_iot.repository.ActionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
public class ActionServiceImpl implements ActionService{

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
    public Pagination getAllActions(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Action> actions = actionRepository.findAll(pageable);
        return new Pagination(actions.getNumber(), actions.getTotalElements(), actions.getTotalPages(), actions.getContent());
    }
}
