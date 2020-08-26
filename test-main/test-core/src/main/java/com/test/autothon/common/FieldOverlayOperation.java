package com.test.autothon.common;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

/**
 * @author Rahul_Goyal
 */
public class FieldOverlayOperation {

    private final static Logger logger = LogManager.getLogger(FieldOverlayOperation.class);

    private String fieldName;
    private String ordinalValue;

    public FieldOverlayOperation(String fieldName, String ordinalValue) {
        this.fieldName = fieldName;
        this.ordinalValue = ordinalValue;
    }

    public String overlayField() {
        String value = null;

        switch (fieldName.toUpperCase()) {
            case "PROPVALUE":
                value = ReadPropertiesFile.getPropertyValue(ordinalValue);
                break;
            case "RANDOMINTEGER":
                value = RandomGenerator.generateRandonIntegerValue(Integer.valueOf(ordinalValue));
                break;
            case "RANDOMSTRING":
                value = RandomGenerator.generateRandomStringValue(Integer.valueOf(ordinalValue));
                break;
            case "RANDOMALPHNUMER":
                value = RandomGenerator.generateRandomAlphaNumericValue(Integer.valueOf(ordinalValue));
                break;
            case "GENERATE_TIMESTAMP":
                TimeZone tz = TimeZone.getTimeZone("UTC");
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat(ordinalValue);
                simpleDateFormat.setTimeZone(tz);
                value = simpleDateFormat.format(new Date());
                break;
        }
        return value;
    }

}
