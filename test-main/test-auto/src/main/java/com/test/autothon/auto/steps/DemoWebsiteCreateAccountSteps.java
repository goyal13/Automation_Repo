package com.test.autothon.auto.steps;

import com.test.autothon.auto.ui.DemoCreateAccount;
import com.test.autothon.common.StepDefinition;
import io.cucumber.java.en.Given;
import org.junit.Assert;

public class DemoWebsiteCreateAccountSteps extends StepDefinition {

    DemoCreateAccount demoSearch = new DemoCreateAccount();

    @Given("^Validate account creation with valid user credentials$")
    public void createAccount() {
        Assert.assertTrue("Account creation failed with valid user details", demoSearch.createAccount());
    }

    @Given("^Validate account with username \"(.*?)\", password \"(.*?)\", email \"(.*?)\" and phone no \"(.*?)\" returns error \"(.*?)\"$")
    public void createAccount(String username, String password, String email, String phoneno, String expErr) {
        username = getOverlay(username);
        email = getOverlay(email);
        password = getOverlay(password);
        phoneno = getOverlay(phoneno);
        expErr = getOverlay(expErr);

        String actErr = demoSearch.createAccount(username, password, email, phoneno);
        Assert.assertEquals(expErr, actErr);
    }
}
