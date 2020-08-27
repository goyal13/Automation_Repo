package com.test.autothon.auto.core;

import com.test.autothon.api.core.CommonRestService;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DemoWebSiteCustomizedSteps extends StepDefinition {

    private static final Map<String, List<String>> productData = new HashMap<>();
    CommonRestService commonRestService = new CommonRestService();

    @Given("Validate All items under category {string} has data for fields {string}")
    public void validateAllItemsUnderCategoryHasDataForFields(String product, String fields) {
        String baseURL = getOverlay("<PROPVALUE(demo.website.rest.base.url)>");
        commonRestService.setRestBaseUrl(baseURL);
        commonRestService.httpGet("/products/category/" + product);
        Assert.assertEquals(200, commonRestService.getResponseCode());
        int sizeOfResponse = commonRestService.getResponseSize("");
        List<String> allIds = new ArrayList<String>();
        for (int i = 0; i < sizeOfResponse; i++) {
            String id = commonRestService.getResponseJsonKeyValue("[" + i + "].id");
            allIds.add(id);
            Assert.assertEquals(product, commonRestService.getResponseJsonKeyValue("[" + i + "].category"));
            for (String field : fields.split(",")) {
                Assert.assertNotEquals("", commonRestService.getResponseJsonKeyValue("[" + i + "]." + field));
            }
        }
        System.out.println("Total Product count under " + product + " : " + allIds.size());

        for (String id : allIds) {
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
