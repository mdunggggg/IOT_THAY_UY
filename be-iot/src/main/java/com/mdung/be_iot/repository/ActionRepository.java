package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.Action;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ActionRepository extends JpaRepository<Action, Long> {
}
