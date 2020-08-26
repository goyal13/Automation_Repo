package com.test.autothon.auto.core;

import com.test.autothon.api.core.CommonRestService;
import com.test.autothon.common.ReadPropertiesFile;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmailOTPProvider extends StepDefinition {

CommonRestService commonRestService = new CommonRestService();
private final static String emailAccountURL= "https://api.mailslurp.com/";
private final static String API_KEY = "06502222d1da867806987649a2053033755c47bee336ebbfdd5724772468bec5";
private final static String JSON_PAYLOAD = "{\"matches\":[{\"field\":\"SUBJECT\",\"should\":\"CONTAIN\",\"value\":\"Your verification code\"}]}";
private final static String MAIL_BOX_ID =  "cb97bf5b-2108-4087-a2cc-b4d4b0e08c11";
private static Map<String, List<String>> productData = new HashMap<>();

private String waitAndGetIDForOTPEmail(){
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
public void getOTP(String otpKey){
    String idForOTPEmail = waitAndGetIDForOTPEmail();
    commonRestService.setRestBaseUrl(emailAccountURL);
    commonRestService.setInputHeader("x-api-key", API_KEY);
    commonRestService.setInputHeader("Content-Type", "application/json");
    commonRestService.httpGet("emails/" + idForOTPEmail);
    Assert.assertEquals(200, commonRestService.getResponseCode());
    String otp = commonRestService.getResponseJsonKeyValue("body").split("Your.*code is ")[1];
    ReadPropertiesFile.setPropertyValue(otpKey,otp);
    deleteAllMailBoxEmails();
}


private void deleteAllMailBoxEmails(){
    commonRestService.setRestBaseUrl(emailAccountURL);
    commonRestService.setInputHeader("x-api-key", API_KEY);
    commonRestService.setInputHeader("Content-Type", "application/json");
    commonRestService.httpDelete("emptyInbox?inboxId=" + MAIL_BOX_ID);
    Assert.assertEquals(204,commonRestService.getResponseCode());

}

@Given("Validate All items under category {string} has data for fields {string}")
public void validateAllItemsUnderCategoryHasDataForFields(String product, String fields) {
    String baseURL = getOverlay("<PROPVALUE(demo.website.rest.base.url)>");
    commonRestService.setRestBaseUrl(baseURL);
    commonRestService.httpGet("/products/category/"+ product);
    Assert.assertEquals(200, commonRestService.getResponseCode());
    int sizeOfResponse = commonRestService.getResponseSize("");
    List<String> allIds = new ArrayList<String>();
    for(int i=0; i<sizeOfResponse; i++) {
        String id = commonRestService.getResponseJsonKeyValue("[" + i + "].id");
        allIds.add(id);
        Assert.assertEquals(product, commonRestService.getResponseJsonKeyValue("[" + i + "].category"));
        for (String field : fields.split(",")) {
            Assert.assertNotEquals("", commonRestService.getResponseJsonKeyValue("[" + i + "]." + field));
        }
    }
    System.out.println("Total Product count under " + product +" : " + allIds.size());

    for(String id: allIds) {
        commonRestService.httpGet("/products/id/" + id);
        Assert.assertEquals(200, commonRestService.getResponseCode());
        Assert.assertEquals(product, commonRestService.getResponseJsonKeyValue("category"));
        Assert.assertEquals(id, commonRestService.getResponseJsonKeyValue("id"));
        List<String> data = new ArrayList<>();
        for (String field : fields.split(",")) {
            String op = commonRestService.getResponseJsonKeyValue(field);
            data.add(field + " : " + op);
            Assert.assertNotEquals("", op);
        }
        productData.put(id, data);
    }


    }
}
