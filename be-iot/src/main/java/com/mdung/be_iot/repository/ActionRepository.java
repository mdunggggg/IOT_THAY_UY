package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.Action;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ActionRepository extends JpaRepository<Action, Long>, JpaSpecificationExecutor<Action> {
}
