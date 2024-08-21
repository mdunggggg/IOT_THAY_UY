package com.mdung.be_iot.rest;

import com.mdung.be_iot.base.BaseResponse;
import com.mdung.be_iot.base.Pagination;
import com.mdung.be_iot.service.ActionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    public BaseResponse<Pagination> getAllActions(@RequestParam(value = "page", defaultValue = "0") int page,
                                                  @RequestParam(value = "size", defaultValue = "10") int size) {
        return BaseResponse.success(
                actionService.getAllActions(page, size)
        );
    }
}
