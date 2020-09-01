package com.test.autothon.auto.core;

import com.test.autothon.api.core.JsonMapConvertor;
import com.test.autothon.common.ReadPropertiesFile;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class CognitoHelper extends StepDefinition {

    private final JsonMapConvertor jmc = new JsonMapConvertor();
    private String cognitoResponse;
    private final String POOL_ID = ReadPropertiesFile.getPropertyValue("POOL_ID");
    private final String CLIENTAPP_ID = ReadPropertiesFile.getPropertyValue("CLIENTAPP_ID");
    private final String CLIENT_SECRET = ReadPropertiesFile.getPropertyValue("CLIENT_SECRET");
    private final String REGION = ReadPropertiesFile.getPropertyValue("REGION");
    private String loginToken;


    @Given("^Authenticate and login to AWS Cognito using username \"(.*?)\" and password \"(.*?)\"$")
    public void ValidateUser(String username, String password) {
        username = getOverlay(username);
        password = getOverlay(password);
        System.out.println("Signing with user: " + username + " and Password: " + password);
        AuthenticationHelper helper = new AuthenticationHelper(POOL_ID, CLIENTAPP_ID, CLIENT_SECRET, REGION);
        loginToken = helper.PerformSRPAuthentication(username, password);
        cognitoResponse = helper.getCognitoLoginUserDetails();
        ReadPropertiesFile.setPropertyValue("loginToken", loginToken);
        System.out.println("Token: " + loginToken);
        System.out.println(jmc.toJsonStringPrettyFormat(cognitoResponse));
    }

    @Given("^Validate AWS Cognito login response with key \"(.*?)\" contains value \"(.*?)\"$")
    public void validateAWSData(String key, String value){
        key = getOverlay(key);
        value = getOverlay(value);
        String expVal = jmc.getPayloadKeyByDotNotation(jmc.convertJsonStringToMap(cognitoResponse),key);
        Assert.assertTrue("AWS Cognito Login response for key [" + key + "] does not contains expected value", expVal.contains(value));
    }

}
