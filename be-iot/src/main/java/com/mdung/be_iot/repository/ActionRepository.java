package com.mdung.be_iot.repository;

import com.mdung.be_iot.entity.Action;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface ActionRepository extends JpaRepository<Action, Long>, JpaSpecificationExecutor<Action> {
    @Query("SELECT a FROM Action a WHERE a.actionCode = :actionCode AND a.applianceCode = :applianceCode AND a.time BETWEEN :startOfDay AND :endOfDay")
    List<Action> findByActionCodeAndApplianceCodeAndToday(@Param("actionCode") String actionCode,
                                                          @Param("applianceCode") String applianceCode,
                                                          @Param("startOfDay") LocalDateTime startOfDay,
                                                          @Param("endOfDay") LocalDateTime endOfDay);

}
