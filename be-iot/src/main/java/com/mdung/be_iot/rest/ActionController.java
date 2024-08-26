package com.mdung.be_iot.rest;

import com.mdung.be_iot.base.BaseResponse;
import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.service.ActionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/v1/actions")
@Tag(name = "Action", description = "API for Action")
public class ActionController {
    private ActionService actionService;

    @Autowired
    public ActionController(ActionService actionService) {
        this.actionService = actionService;
    }

    @GetMapping("/")
    @Operation(summary = "Get all actions")
    public BaseResponse<Pagination> getAllActions(
            @RequestParam(value = "page", defaultValue = "0") int page,
            @RequestParam(value = "size", defaultValue = "10") int size, @RequestParam(required = false) String appliance,
            @RequestParam(required = false) String search,
            @Parameter(
                  description = "Sort by time",
                  in = ParameterIn.QUERY,
                  schema = @Schema(allowableValues = {"desc", "asc"})
            )
            @RequestParam(defaultValue = "desc") String sort,
            @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "dd/MM/yyyy") LocalDate endDate)

    {
        Sort.Direction direction = sort.equalsIgnoreCase("asc") ? Sort.Direction.ASC : Sort.Direction.DESC;
        PageRequest pageable = PageRequest.of(page, size, Sort.by(direction, "time"));
        return BaseResponse.success(
                actionService.getAllActions(appliance, search, pageable, startDate, endDate)
        );
    }
}
