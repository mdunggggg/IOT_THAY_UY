package com.mdung.be_iot.base;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
public class Pagination<T> {
    private long page;
    private long totalElements;
    private long totalPages;
    List<T> elements;
}