package com.mdung.be_iot.service;

import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.entity.Action;

public interface ActionService {
    Action createAction(Action action);

    Pagination getAllActions(int page, int size);
}
