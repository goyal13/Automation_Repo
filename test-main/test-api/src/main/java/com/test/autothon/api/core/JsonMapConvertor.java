package com.test.autothon.api.core;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.json.JsonSanitizer;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * @author Rahul_Goyal
 */
public class JsonMapConvertor {
    private final static Logger logger = LogManager.getLogger(JsonMapConvertor.class);

    ObjectMapper mapper = new ObjectMapper();

    public Map<String, Object> convertJsonStringToMap(String input) {
        input = JsonSanitizer.sanitize(input);
        Map<String, Object> result = new HashMap<String, Object>();
        try {
            result = mapper.readValue(input, new TypeReference<HashMap<String, Object>>() {
            });
        } catch (IOException e) {
            logger.error("Error parsing Json String to Map" + e);
        }
        return result;
    }

    public String convertMapToJsonString(Map<String, Object> input) {
        String json = null;
        try {
            json = mapper.writeValueAsString(input);
        } catch (JsonProcessingException e) {
            logger.error("Error converting Json Map to String" + e);
        }
        return json;
    }

    public String toJsonStringPrettyFormat(String jsonInput) {
        Object jsonOutput = new Object();
        String prettyJson = null;
        try {
            jsonOutput = mapper.readValue(jsonInput, Object.class);
            prettyJson = mapper.writerWithDefaultPrettyPrinter().writeValueAsString(jsonOutput);
        } catch (IOException e) {
            logger.error("Error converting json string to pretty format" + e);
            return jsonInput;
        }
        return prettyJson;
    }

    public Map<String, Object> setPayloadkeyByDotNotation(Map<String, Object> inputMap, String key, String value) {
        logger.debug("Setting key/value pair: <" + key + "> <" + value + ">");

        Object result = updateValueByNotation(inputMap, key, value, ".");

        if (result instanceof String && "KEY_NOT_FOUND".equals(result)) {
            logger.debug("FAILURE");
        } else {
            logger.debug("SUCCESS");
        }
        return inputMap;
    }

    private Object updateValueByNotation(Object inputMap, String key, String value, String delimiter) {

        logger.info("Updating value in map via key " + key);
        String splitRegEx = new StringBuilder("\\").append(delimiter).toString();
        String[] explodedKey = key.split(splitRegEx);
        String currentLevelKey = "";
        int listIndex = -1;
        String[] strValues = null;
        int stringLength = 0;

        for (int i = 0; i < explodedKey.length; i++) {
            logger.debug("Exploded key: (" + i + ") " + explodedKey[i]);
        }

        if (explodedKey.length == 1) {
            //last level
            logger.debug("last level node");
            logger.debug("Found Key: " + ((Map) inputMap).get(explodedKey[0]));
            ((Map<String, Object>) inputMap).put(explodedKey[0], value);
            return inputMap;
        } else {
            //more levels
            logger.debug("more levels detected in key");
            checkIfInputMapIsMap(inputMap);

            if (explodedKey[0].contains("[")) {
                //list element
                String[] temp = explodedKey[0].split("\\[");
                currentLevelKey = temp[0];
                listIndex = Integer.valueOf(temp[1].replace("]", ""));

                logger.debug("current key = " + currentLevelKey + " with list index = " + listIndex);
            } else {
                //standard element
                currentLevelKey = explodedKey[0];
                logger.debug("current key = " + currentLevelKey + " with no list index");
            }

            if (((Map) inputMap).containsKey(currentLevelKey)) {
                //value exists
                logger.debug("key exists, iterating further");

                String partialKey = addToPartialKey(explodedKey, delimiter);
                return recurseUpdate(currentLevelKey, partialKey, inputMap, listIndex, value, delimiter);
            } else {
                //key doesn't exist, exit
                logger.debug("key doesn't exist, adding it");

                ((Map) inputMap).put(currentLevelKey, new HashMap<String, Object>());

                String partialKey = addToPartialKey(explodedKey, delimiter);
                return recurseUpdate(currentLevelKey, partialKey, inputMap, listIndex, value, delimiter);
            }
        }
    }

    private String checkIfInputMapIsMap(Object inputMap) {
        String keyVal = null;
        if (!(inputMap instanceof Map<?, ?>)) {
            //the map is a primitive, exit
            logger.debug("input is not a map");

            keyVal = "KEY_NOT_FOUND";
        }
        return keyVal;
    }

    private String addToPartialKey(String[] explodedKey, String delimiter) {
        StringBuffer partialKey = new StringBuffer();

        for (int i = 1; i < explodedKey.length; i++) {
            if (partialKey.length() > 0) {
                partialKey.append(delimiter);
            }
            partialKey.append(explodedKey[i]);
        }
        return partialKey.toString();
    }

    private Object recurseUpdate(String currentLevelKey, String partialKey, Object inputMap, int listIndex,
                                 String value, String delimiter) {
        if (listIndex == -1) {
            //standard key
            logger.debug("recursing based on standard key");
            return updateValueByNotation(((Map) inputMap).get(currentLevelKey), partialKey, value, delimiter);
        } else {
            //list key
            logger.debug("recursing on a list key");
            Object tempValue = ((Map) inputMap).get(currentLevelKey);
            ArrayList<String> tempValueList = (ArrayList<String>) tempValue;

            if (tempValueList.size() >= listIndex) {
                return updateValueByNotation(tempValueList.get(listIndex), partialKey, value, delimiter);
            } else {
                logger.debug("list does not have index");
                return "KEY_NOT_FOUND";
            }
        }
    }

    public Map<String, Object> removePayloadKeyByDotNotation(Map<String, Object> inputMap, String key) {
        logger.info("Removing key/value pair: <" + key + ">");

        Object result = removeValueByNotation(inputMap, key, ".");

        if (result instanceof String && "KEY_NOT_FOUND".equals(result)) {
            logger.debug("FAILURE");
        } else {
            logger.debug("SUCCESS");
        }

        return inputMap;
    }

    private Object removeValueByNotation(Object inputMap, String key, String delimiter) {

        logger.info("Removing Key in map via partial key " + key);

        String splitRegEx = new StringBuilder("\\").append(delimiter).toString();
        String[] explodedKey = key.split(splitRegEx);
        String currentLevelKey = "";
        int listIndex = -1;

        for (int i = 0; i < explodedKey.length; i++) {
            logger.debug("Exploded key: (" + i + ") " + explodedKey[i]);
        }

        if (explodedKey.length == 1) {
            //last level
            logger.debug("last level");
            logger.debug("Found Key: " + ((Map) inputMap).get(explodedKey[0]));

            ((Map<String, Object>) inputMap).remove(explodedKey[0]);

            return inputMap;
        } else {
            //more levels
            logger.debug("more levels detected in key");
            checkIfInputMapIsMap(inputMap);

            if (explodedKey[0].contains("[")) {
                //list element
                String[] temp = explodedKey[0].split("\\[");
                currentLevelKey = temp[0];
                listIndex = Integer.valueOf(temp[1].replace("]", ""));
                logger.debug("current key = " + currentLevelKey + " with list index = " + listIndex);
            } else {
                //standard element
                currentLevelKey = explodedKey[0];
                logger.debug("current key = " + currentLevelKey + " with no list index");
            }

            if (((Map) inputMap).containsKey(currentLevelKey)) {
                //value exists
                logger.debug("key exists, iterating further");

                String partialKey = addToPartialKey(explodedKey, delimiter);
                return recurseRemove(currentLevelKey, partialKey, inputMap, listIndex, delimiter);
            } else {
                //key doesn't exist, exit
                logger.debug("key doesn't exist, adding it");

                ((Map) inputMap).put(currentLevelKey, new HashMap<String, Object>());

                String partialKey = addToPartialKey(explodedKey, delimiter);
                return recurseRemove(currentLevelKey, partialKey, inputMap, listIndex, delimiter);
            }
        }
    }

    private Object recurseRemove(String currentLevelKey, String partialKey, Object inputMap, int listIndex, String delimiter) {
        if (listIndex == -1) {
            //standard key
            logger.debug("recursing based on standard key");
            return removeValueByNotation(((Map) inputMap).get(currentLevelKey), partialKey, delimiter);
        } else {
            //list key
            logger.debug("recursing on a list key");
            Object tempValue = ((Map) inputMap).get(currentLevelKey);
            ArrayList<String> tempValueList = (ArrayList<String>) tempValue;
            logger.debug("list size = " + tempValueList.size());

            if (tempValueList.size() >= listIndex) {
                return removeValueByNotation(tempValueList.get(listIndex), partialKey, delimiter);
            } else {
                logger.debug("list does not have index");
                return "KEY_NOT_FOUND";
            }
        }
    }

    public String getPayloadKeyByDotNotation(Map<String, Object> inputMap, String key) {
        logger.info("Looking for value in json with key : " + key);
        return "" + getValueByNotation(inputMap, key, ".");
    }

    private Object getValueByNotation(Object inputMap, String key, String delimiter) {

        logger.debug("Looking for value in map via partial key " + key);

        String splitRegEx = new StringBuilder("\\").append(delimiter).toString();
        String[] explodedKey = key.split(splitRegEx);
        String currentLevelKey = "";
        int listIndex = -1;

        for (int i = 0; i < explodedKey.length; i++) {
            logger.debug("Exploded key: (" + i + ") " + explodedKey[i]);
        }

        if (explodedKey.length == 1) {
            //last level
            logger.debug("Parser is at the last level");

            if (((Map) inputMap).containsKey(explodedKey[0])) {
                return ((Map) inputMap).get(explodedKey[0]);
            } else {
                logger.debug("key doesn't exist");
                return "KEY_NOT_FOUND";
            }
        } else if (explodedKey.length == 2 && "[]".equals(explodedKey[1])) {
            //last level
            logger.debug("last level of an array having DTO as key");

            if (((Map) inputMap).containsKey(explodedKey[0])) {
                return ((Map) inputMap).get(explodedKey[0]);
            } else {
                logger.debug("key doesn't exist");
                return "KEY_NOT_FOUND";
            }
        } else {
            //more levels
            logger.debug("more levels detected in key");
            checkIfInputMapIsMap(inputMap);

            if (explodedKey[0].contains("[")) {
                //list element
                String[] temp = explodedKey[0].split("\\[");
                currentLevelKey = temp[0];
                listIndex = Integer.valueOf(temp[1].replace("]", ""));

                logger.debug("current key = " + currentLevelKey + " with list index = " + listIndex);
            } else {
                //standard element
                currentLevelKey = explodedKey[0];
                logger.debug("current key = " + currentLevelKey + " with no list index");
            }

            if (((Map) inputMap).containsKey(currentLevelKey)) {
                String partialKey = addToPartialKey(explodedKey, delimiter);
                return recurseGet(currentLevelKey, partialKey, inputMap, listIndex, delimiter);
            } else {
                //key doesn't exist, exit
                logger.debug("key doesn't exist");
                return "KEY_NOT_FOUND";
            }
        }
    }

    private Object recurseGet(String currentLevelKey, String partialKey, Object inputMap, int listIndex, String delimiter) {
        if (listIndex == -1) {
            //standard key
            logger.debug("Parser recursing based on standard key");
            return getValueByNotation(((Map) inputMap).get(currentLevelKey), partialKey, delimiter);
        } else {
            //list key
            logger.debug("Parser recursing on a list key");
            Object tempValue = ((Map) inputMap).get(currentLevelKey);
            ArrayList<Object> tempValueList = (ArrayList<Object>) tempValue;

            logger.debug("list size = " + tempValueList.size());

            if (tempValueList.size() >= listIndex) {
                return getValueByNotation(tempValueList.get(listIndex), partialKey, delimiter);
            } else {
                logger.debug("list does not have index");
                return "KEY_NOT_FOUND";
            }
        }
    }

    public int getSizeOfResponse(String currentLevelKey, Object inputMap) {
                //list key
            logger.debug("Parser recursing on a list key");
            Object tempValue = ((Map) inputMap).get(currentLevelKey);
            ArrayList<Object> tempValueList = (ArrayList<Object>) tempValue;

            logger.debug("list size = " + tempValueList.size());
            return tempValueList.size();

        }
    }
