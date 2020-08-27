package com.test.autothon.auto.core;

import com.test.autothon.api.core.CommonRestService;
import com.test.autothon.common.ReadPropertiesFile;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class EmailOTPProvider extends StepDefinition {

    private final static String emailAccountURL = "https://api.mailslurp.com/";
    private final static String API_KEY = "06502222d1da867806987649a2053033755c47bee336ebbfdd5724772468bec5";
    private final static String JSON_PAYLOAD = "{\"matches\":[{\"field\":\"SUBJECT\",\"should\":\"CONTAIN\",\"value\":\"Your verification code\"}]}";
    private final static String MAIL_BOX_ID = "cb97bf5b-2108-4087-a2cc-b4d4b0e08c11";
    CommonRestService commonRestService = new CommonRestService();

    private String waitAndGetIDForOTPEmail() {
        commonRestService.setRestBaseUrl(emailAccountURL);
        commonRestService.setInputHeader("x-api-key", API_KEY);
        commonRestService.setInputHeader("Content-Type", "application/json");
        commonRestService.setInputJsonPayload(JSON_PAYLOAD);
        commonRestService.httpPost("waitForMatchingEmails?count=1&inboxId=" + MAIL_BOX_ID + "&timeout=60000&unreadOnly=true");
        int responseCode = commonRestService.getResponseCode();
        Assert.assertEquals(200, responseCode);
        return commonRestService.getResponseJsonKeyValue("").split("id=")[1].split(",")[0];
    }

    @Given("^Get and store OTP as \"(.*?)\"$")
    public void getOTP(String otpKey) {
        String idForOTPEmail = waitAndGetIDForOTPEmail();
        commonRestService.setRestBaseUrl(emailAccountURL);
        commonRestService.setInputHeader("x-api-key", API_KEY);
        commonRestService.setInputHeader("Content-Type", "application/json");
        commonRestService.httpGet("emails/" + idForOTPEmail);
        Assert.assertEquals(200, commonRestService.getResponseCode());
        String otp = commonRestService.getResponseJsonKeyValue("body").split("Your.*code is ")[1];
        ReadPropertiesFile.setPropertyValue(otpKey, otp);
        deleteAllMailBoxEmails();
    }


    private void deleteAllMailBoxEmails() {
        commonRestService.setRestBaseUrl(emailAccountURL);
        commonRestService.setInputHeader("x-api-key", API_KEY);
        commonRestService.setInputHeader("Content-Type", "application/json");
        commonRestService.httpDelete("emptyInbox?inboxId=" + MAIL_BOX_ID);
        Assert.assertEquals(204, commonRestService.getResponseCode());
    }

}
