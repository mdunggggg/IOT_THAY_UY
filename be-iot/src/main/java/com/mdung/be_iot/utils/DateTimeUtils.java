package com.mdung.be_iot.utils;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.ZoneId;

public class DateTimeUtils {
    public static long getCurrentTime() {
        return System.currentTimeMillis();
    }
    public static long localDateToLongStartOfDay(LocalDate localDate) {
        return localDate.atStartOfDay(ZoneId.systemDefault()).toInstant().toEpochMilli();
    }

    public static long localDateToLongEndOfDay(LocalDate localDate) {
        return localDate.atTime(LocalTime.MAX).atZone(ZoneId.systemDefault()).toInstant().toEpochMilli();
    }
}
