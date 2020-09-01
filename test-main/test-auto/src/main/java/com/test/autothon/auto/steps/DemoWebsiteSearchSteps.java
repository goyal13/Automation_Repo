package com.test.autothon.auto.steps;

import com.test.autothon.auto.ui.DemoSearch;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class DemoWebsiteSearchSteps extends StepDefinition {

    DemoSearch demoSearch = new DemoSearch();

    @Given("^Search for \"(.*?)\"$")
    public void search(String text) {
        Assert.assertTrue(demoSearch.searchString(text));
    }
}
