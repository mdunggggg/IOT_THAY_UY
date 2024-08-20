package com.mdung.be_iot.base;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
public class BaseResponse<T> {
    private Status status;
    private T data;

    static public <T> BaseResponse<T> success(T data) {
        return new BaseResponse<>(new Status(ResponseCode.success, "Thành công"), data);
    }

    static public <T> BaseResponse<T> success() {
        return new BaseResponse<>(new Status(ResponseCode.success, "Thành công"), null);
    }

    static public <T> BaseResponse<T> error(Status status) {
        return new BaseResponse<>(status, null);
    }
}
